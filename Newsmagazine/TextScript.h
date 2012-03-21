//
//  TextScript.h
//  Newsmagazine
//
//  Created by Jared Pochtar on 10/5/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScriptEngine : NSObject {
	NSMutableDictionary *scenes;
	NSString *currentScene;
}
- (id)initWithTextScript:(NSString *)text;
- (void)input:(NSString *)input;

@property (copy) void(^output)(NSString *output, NSString *correspondingImage);
@property (copy) void(^ended)();
@property (copy) NSString *currentScene;
@end


