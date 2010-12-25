//
//  TextScript.m
//  OdysseyCreativeProject
//
//  Created by Jared Pochtar on 10/5/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "TextScript.h"

@interface Scene : NSObject {
	NSString *text;
	
	NSString *defaultNextScene;
	NSMutableSet *successorScenes;
	NSMutableDictionary *choices;					//string -> set(string scenename)
	NSUInteger maxWordsPerKeyword;
}
- (id)initWithScanner:(NSScanner *)scanner;
- (NSString *)getNextChoiceLabelWithOutput:(void(^)(NSString *))output reactionGet:(NSArray*(^)())getReactionTokens;
@end

@implementation Scene

- (void)dealloc {
	[text release];
	[defaultNextScene release];
	[successorScenes release];
	[choices release];
	[super dealloc];
}

- (id)initWithScanner:(NSScanner *)scanner {
	if (self = [super init]) {
		successorScenes = [[NSMutableSet set] retain];
		choices = [[NSMutableDictionary dictionary] retain];
		//TODO: ADD syntax for fail formats, scene choice descriptions
		
		static NSCharacterSet *keywordOrNewSceneMarkers, *keywordSeparaterOrSceneNameMarkers, *whitespaceChars;
		if (!keywordOrNewSceneMarkers) {
			keywordOrNewSceneMarkers = [[NSCharacterSet characterSetWithCharactersInString:@":@"] retain];
			keywordSeparaterOrSceneNameMarkers = [[NSCharacterSet characterSetWithCharactersInString:@",:"] retain];
			whitespaceChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		}
				
		[scanner scanUpToCharactersFromSet:keywordOrNewSceneMarkers intoString:&text];
		text = [[text stringByTrimmingCharactersInSet:whitespaceChars] retain];
		
		while ([scanner scanString:@"@" intoString:nil]) {
			if ([scanner scanString:@":" intoString:nil]) {
				[scanner scanUpToCharactersFromSet:keywordOrNewSceneMarkers intoString:&defaultNextScene];
				defaultNextScene = [[defaultNextScene stringByTrimmingCharactersInSet:whitespaceChars] retain];
				[successorScenes addObject:defaultNextScene];
			} else {
				NSMutableSet *keywords = [NSMutableSet set];
				do {
					NSString *keyword;
					[scanner scanUpToCharactersFromSet:keywordSeparaterOrSceneNameMarkers intoString:&keyword];
					keyword = [[keyword lowercaseString] stringByTrimmingCharactersInSet:whitespaceChars];
					
					size_t wordsInKeyword = [keyword componentsSeparatedByCharactersInSet:whitespaceChars].count;
					maxWordsPerKeyword = MAX(maxWordsPerKeyword, wordsInKeyword);
					
					[keywords addObject:keyword];
				} while ([scanner scanString:@"," intoString:nil]);
				
				[scanner scanString:@":" intoString:nil];
				NSString *sceneNameForKeywords;
				[scanner scanUpToCharactersFromSet:keywordOrNewSceneMarkers intoString:&sceneNameForKeywords];
				sceneNameForKeywords = [sceneNameForKeywords stringByTrimmingCharactersInSet:whitespaceChars];
				[successorScenes addObject:sceneNameForKeywords];
				
				for (NSString *keyword in keywords) {
					NSMutableSet *scenesForKeyword = [choices objectForKey:keyword];
					if (!scenesForKeyword) {
						[choices setObject:[NSMutableSet setWithObject:sceneNameForKeywords] forKey:keyword];
					} else {
						[scenesForKeyword addObject:sceneNameForKeywords];
					}
				}
			}
		}
	}
	
	return self;
}

- (NSString *)getNextChoiceLabelWithOutput:(void(^)(NSString *))output reactionGet:(NSArray*(^)())getReplyTokens {
	output(text);
	if (!choices || successorScenes.count == 0) {
		return nil;
	} else if (successorScenes.count == 1) {
		return defaultNextScene;
	}
	
	NSString *nextSceneName = nil;
	while (!nextSceneName) {
		NSMutableSet *matchingScenes = [NSMutableSet setWithSet:successorScenes];
		NSMutableSet *relatedScenes = [NSMutableSet set];
		NSArray *replyTokens = getReplyTokens();
		
		for (int currentToken = 0; currentToken < replyTokens.count; currentToken++) {
			for (int tokenCount = MIN(maxWordsPerKeyword, replyTokens.count - currentToken); tokenCount > 0; tokenCount--) {
				NSSet *scenesForKeywords = [choices objectForKey:[[replyTokens
																   subarrayWithRange:NSMakeRange(currentToken, tokenCount)]
																  componentsJoinedByString:@" "]];
				if (scenesForKeywords) {
					[matchingScenes intersectSet:scenesForKeywords];
					[relatedScenes unionSet:scenesForKeywords];
					currentToken += tokenCount - 1;
					break;
				}
			}
		}
		
		if (matchingScenes.count == 1) {
			nextSceneName = [matchingScenes anyObject];
		} else {
			if (defaultNextScene) {
				return defaultNextScene;
			}
			
			NSArray *possibleChoices = [(relatedScenes.count == 0 ? successorScenes : relatedScenes) allObjects];
			NSString *choiceString;
			if (possibleChoices.count == 2) {
				choiceString = [NSString stringWithFormat:@"%@ or %@", [possibleChoices objectAtIndex:0], possibleChoices.lastObject];
			} else {				
				choiceString = [[possibleChoices subarrayWithRange:NSMakeRange(0, possibleChoices.count - 1)] componentsJoinedByString:@", "];
				choiceString = [choiceString stringByAppendingFormat:@", or %@", possibleChoices.lastObject];
			}
			
			output([@"\nDid you mean {matches}?\n" stringByReplacingOccurrencesOfString:@"{matches}" withString:choiceString]);
		}
	}
	
	return nextSceneName;
}

@end

@implementation NSString (TextScript)

- (void)runAsTextScriptWithFirstScene:(NSString *)firstScene
							   output:(void(^)(NSString *))output
						  reactionGet:(NSString*(^)())getReaction
{
	NSCharacterSet *whitespaceChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];

	NSMutableDictionary *scenes = [NSMutableDictionary dictionary];
	NSScanner *scanner = [NSScanner scannerWithString:self];
	while ([scanner scanString:@":" intoString:nil]) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSString *sceneName;
		[scanner scanUpToString:@":" intoString:&sceneName];
		[scanner scanString:@":" intoString:nil];
		sceneName = [sceneName stringByTrimmingCharactersInSet:whitespaceChars];
		
		Scene *scene = [[Scene alloc] initWithScanner:scanner];
		[scenes setObject:scene forKey:sceneName];
		[scene release];
		
		[pool release];
	}
			
	NSString *currentScene = [firstScene retain];
	while (currentScene) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSString *newScene = [[scenes objectForKey:currentScene] getNextChoiceLabelWithOutput:output reactionGet:^NSArray* {
			NSString *input = getReaction();
			static NSCharacterSet *statementSeparators, *separatorCharacters;
			if (!statementSeparators) {
				statementSeparators = [[NSCharacterSet characterSetWithCharactersInString:@";."] retain];
				separatorCharacters = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] retain];
			}
			
			NSArray *statements = [input componentsSeparatedByCharactersInSet:statementSeparators];
			NSString *lastSentance = statements.lastObject;
			
			if (statements.count > 1 && [[lastSentance stringByTrimmingCharactersInSet:whitespaceChars] length] == 0) {
				lastSentance = [statements objectAtIndex:statements.count - 2];
			}
			lastSentance = [lastSentance lowercaseString];
			return [lastSentance componentsSeparatedByCharactersInSet:separatorCharacters];
		}];
		[currentScene release];
		currentScene = [newScene retain];
		
		[pool release];
	}
}

@end
