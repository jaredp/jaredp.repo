//
//  JPMenuWithStaticItems.h
//  Notecards
//
//  Created by Jared Pochtar on 11/27/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JPMenuWithStaticItems : NSMenu {
	IBOutlet NSMenu *staticMenuToAppend;
}
@property (retain) NSMenu *staticMenuToAppend;

@end

@interface JPObjCMsgLogger {
	Class isaFake;
//	IBOutlet NSMenu *staticMenuToAppend;
	id internal;
}

+ (Class)classToMonitor;

@end

@interface _JPMenuWithStaticItems : JPObjCMsgLogger

@end

@interface NSMenuItem_intercepter : JPObjCMsgLogger

@end
