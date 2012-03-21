//
//  JPZipper.h
//  Finder
//
//  Created by Jared Pochtar on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPZipper : NSObject {
	NSTask *zipProcess;
	
	NSString *destination;
	NSString *name;
	
	id target;
	SEL selector;
}
- (id)initWithFilePath:(NSString *)path name:(NSString *)_name;

@property (retain) id target;
@property (assign) SEL selector;

@property (readonly) NSString *destination;
@property (readonly) NSString *name;
@end
