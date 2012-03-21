//
//  Interpreter.h
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tokenizer.h"

@interface Interpreter : NSObject {
	Tokenizer *tokenizer;
	NSMutableDictionary *variables;
	
	BOOL cancel;
}
- (void)interpret:(const char *)source;
- (void)cancel;

- (void)interpretStatementWithSideEffects:(BOOL)sideEffects;
- (id)interpretExpressionWithSideEffects:(BOOL)sideEffects;

@end
