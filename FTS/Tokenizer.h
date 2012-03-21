//
//  Tokenizer.h
//  FTS
//
//  Created by Jared Pochtar on 7/6/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SourceCodeError @"FTSInterpreterReachedSourceCodeError"

@interface Tokenizer : NSObject {
	const char *string;
	size_t currChar;
	
	NSCharacterSet *identifierCharacterSet;
	NSCharacterSet *identiferStartCharacterSet;
	
	NSSet *languageKeywords;
	NSArray *languageOperators;
}
- (id)initWithSource:(const char *)source identifierCharacterSet:(NSCharacterSet *)idChars
	languageKeywords:(NSSet *)keywords;

- (void)skipWhitespace;
- (BOOL)isAtEndOfText;

- (BOOL)getAndMapKeyword:(NSDictionary *)map orIdentifier:(SEL)handleIdentifier withHandler:(id)handler;
- (NSString *)getRequiredKeyword:(NSString *)requiredKeyword;

- (BOOL)getNextTokenIfTokenIsIdentifier:(NSString **)identifier;
- (NSString *)getIdentifier;

- (BOOL)getNextTokenIfTokenIs:(NSString *)possibleToken;		//Does not continue reading past token in string
- (NSString *)getRequiredToken:(NSString *)requiredToken;

- (BOOL)getNextTokenIfTokenIsConstant:(id *)constant;

typedef size_t TokenizerPosition;
@property (getter=position, setter=restorePosition:) TokenizerPosition currChar;
@end
