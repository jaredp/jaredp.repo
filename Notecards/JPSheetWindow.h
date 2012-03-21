//
//  JPSheetWindow.h
//  Notecards
//
//  Created by Jared Pochtar on 11/27/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JPSheetWindow : NSWindow {
	IBOutlet NSWindow *windowToAttatchTo;
}
- (IBAction)showSheet:(id)sender;
- (IBAction)dismissSheet:(id)sender;

@end
