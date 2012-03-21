//
//  VoiceServer.h
//  Notecards
//
//  Created by Jared Pochtar on 12/3/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface VoiceServer : NSObject {

}

- (void)runServer;
- (void)spawnServer;
- (void)sendStringToFirstResponder:(NSString *)str;

@end
