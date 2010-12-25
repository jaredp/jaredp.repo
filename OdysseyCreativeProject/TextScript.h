//
//  TextScript.h
//  OdysseyCreativeProject
//
//  Created by Jared Pochtar on 10/5/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSString(TextScript)
- (void)runAsTextScriptWithFirstScene:(NSString *)firstScene
							   output:(void(^)(NSString *))output
						  reactionGet:(NSString*(^)())getReaction;
@end
