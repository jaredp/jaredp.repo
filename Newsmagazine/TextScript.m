//
//  TextScript.m
//  Newsmagazine
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
- (NSString *)automaticSuccessorScene;
- (id)initWithScanner:(NSScanner *)scanner;
- (NSString *)getNextChoiceLabelWithInputTokens:(NSArray *)inputTokens;

@property (readonly) NSString *text;
@property (retain) NSString *image, *scenename;
@end

@implementation Scene
@synthesize text, image, scenename; 

- (void)dealloc {
	[text release];
	[defaultNextScene release];
	[successorScenes release];
	[choices release];
	[super dealloc];
}

- (NSString *)automaticSuccessorScene {
	return successorScenes.count == 1 ? defaultNextScene : nil;	
}

- (id)initWithScanner:(NSScanner *)scanner {
	if (self = [super init]) {
		successorScenes = [[NSMutableSet set] retain];
		choices = [[NSMutableDictionary dictionary] retain];
		//TODO: ADD syntax for fail formats, scene choice descriptions
		
		static NSCharacterSet *keywordOrNewSceneMarkers = nil, *keywordSeparaterOrSceneNameMarkers, *whitespaceChars;
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

- (NSString *)getNextChoiceLabelWithInputTokens:(NSArray *)inputTokens {
	if (!choices || successorScenes.count == 0) {
		return nil;
	} else if (successorScenes.count == 1) {
		return defaultNextScene;
	}
	
	NSMutableSet *matchingScenes = [NSMutableSet setWithSet:successorScenes];
	NSMutableSet *relatedScenes = [NSMutableSet set];
	
	for (int currentToken = 0; currentToken < inputTokens.count; currentToken++) {
		for (int tokenCount = MIN(maxWordsPerKeyword, inputTokens.count - currentToken); tokenCount > 0; tokenCount--) {
			NSSet *scenesForKeywords = [choices objectForKey:[[[inputTokens subarrayWithRange:NSMakeRange(currentToken, tokenCount)]
															   componentsJoinedByString:@" "]
															  lowercaseString]];
			if (scenesForKeywords) {
				[matchingScenes intersectSet:scenesForKeywords];
				[relatedScenes unionSet:scenesForKeywords];
				currentToken += tokenCount - 1;
				break;
			}
		}
	}
	
	if (matchingScenes.count == 1) {
		return [matchingScenes anyObject];
	} else {
		if (defaultNextScene) {
			return defaultNextScene;
		}
		
		//NSArray *possibleChoices = [(relatedScenes.count == 0 ? successorScenes : relatedScenes) allObjects];
		//do something here: im not even really sure what
		/*
		 NSString *choiceString;
		 if (possibleChoices.count == 2) {
		 choiceString = [NSString stringWithFormat:@"%@ or %@", [possibleChoices objectAtIndex:0], possibleChoices.lastObject];
		 } else {				
		 choiceString = [[possibleChoices subarrayWithRange:NSMakeRange(0, possibleChoices.count - 1)] componentsJoinedByString:@", "];
		 choiceString = [choiceString stringByAppendingFormat:@", or %@", possibleChoices.lastObject];
		 }
		 
		 output([@"\nDid you mean {matches}?\n" stringByReplacingOccurrencesOfString:@"{matches}" withString:choiceString]);
		 */
	}
	
	return scenename;	//eh whatever
}

@end

@implementation ScriptEngine
@synthesize output, ended, currentScene;

- (id)initWithTextScript:(NSString *)text {
	scenes = [[NSMutableDictionary alloc] init];
	
	NSScanner *scanner = [NSScanner scannerWithString:text];
	NSCharacterSet *whitespaceChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	while ([scanner scanString:@":" intoString:nil]) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSString *sceneName;
		NSString *image = nil;
		
		[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"[:"] intoString:&sceneName];
		if ([scanner scanString:@"[" intoString:nil]) {
			[scanner scanUpToString:@"]" intoString:&image];
			[scanner scanString:@"]" intoString:nil];
		}
		[scanner scanString:@":" intoString:nil];
		
		sceneName = [sceneName stringByTrimmingCharactersInSet:whitespaceChars];
		
		Scene *scene = [[Scene alloc] initWithScanner:scanner];
		[scene setImage:image];
		[scene setScenename:sceneName];
		
		[scenes setObject:scene forKey:sceneName];
		[scene release];
		
		[pool release];
	}
	
	return self;
}

- (void)input:(NSString *)input {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSCharacterSet *whitespaceChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	static NSCharacterSet *statementSeparators, *separatorCharacters;
	if (!statementSeparators) {
		statementSeparators = [[NSCharacterSet characterSetWithCharactersInString:@";."] retain];
		separatorCharacters = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] retain];
	}
	
	NSArray *statements = [input componentsSeparatedByCharactersInSet:statementSeparators];
	NSString *lastSentance;
	int lastSentanceIndex = statements.count;
	do {
		lastSentanceIndex--;
		if (lastSentanceIndex < 0) {
			return;
		}
		lastSentance = [[statements objectAtIndex:lastSentanceIndex] stringByTrimmingCharactersInSet:whitespaceChars];
	} while ([lastSentance length] == 0);
	lastSentance = [lastSentance lowercaseString];
	
	NSArray *inputTokens = [lastSentance componentsSeparatedByCharactersInSet:separatorCharacters];
	self.currentScene = [[scenes objectForKey:currentScene] getNextChoiceLabelWithInputTokens:inputTokens];
	
	[pool release];
}

- (void)setCurrentScene:(NSString *)newScene {
	[newScene retain];
	[currentScene release];
	currentScene = newScene;
	
	Scene *actualScene = [scenes objectForKey:newScene];
	output([actualScene text], [actualScene image]);
	if ([actualScene automaticSuccessorScene]) {
		[self setCurrentScene:[actualScene automaticSuccessorScene]];
	}
	
	if (actualScene == nil) {
		output(@"The END", nil);
		ended();
	}
}

- (void)dealloc {
	[scenes release];
	[currentScene release];
	[super dealloc];
}

@end
