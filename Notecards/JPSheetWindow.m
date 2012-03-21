//
//  JPSheetWindow.m
//  Notecards
//
//  Created by Jared Pochtar on 11/27/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import "JPSheetWindow.h"


@implementation JPSheetWindow

- (IBAction)showSheet:(id)sender {
	[NSApp beginSheet:self 
	   modalForWindow:windowToAttatchTo
		modalDelegate:nil
	   didEndSelector:NULL
		  contextInfo:NULL];	
}

- (IBAction)dismissSheet:(id)sender {
	[NSApp endSheet:self];
	[self orderOut:nil];
}

@end
