//
//  MyDocument.h
//  Notecards
//
//  Created by Jared Pochtar on 11/27/11.
//  Copyright Devclub 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyDocument : NSPersistentDocument {
	IBOutlet NSWindow *mainWindow;
	
	IBOutlet NSTextView *contentEditor;
	IBOutlet NSTextField *pagenumberField;
	IBOutlet NSPopUpButton *sourceSelector;
	
	IBOutlet NSWindow *sourcesEditor;
	IBOutlet NSArrayController *notesController;
}

- (id)addNew:(id)sender;

- (IBAction)focusContentEditor:(id)sender;	//for hitting enter on pagenumberField

- (void)messWithSourceSelector;
- (IBAction)editSources:(id)sender;
- (IBAction)dismissSources:(id)sender;

- (void)receivedVoiceDictation:(NSString *)dictation;

@end
