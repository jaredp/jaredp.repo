//
//  JPModelObject.h
//  Records
//
//  Created by Jared Pochtar on 5/8/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define m @property (assign)

@interface JPModelObject : NSObject {
	NSMutableDictionary *members;
}
- (void)log;

@end
