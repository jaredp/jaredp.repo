//
//  MyDocument.m
//  Notecards
//
//  Created by Jared Pochtar on 11/27/11.
//  Copyright Devclub 2011 . All rights reserved.
//

#import "MyDocument.h"
#import "Source.h"
#import "Note.h"


/*
NOTE:
there is a crash when we do not save a file we're closing
other conditions seen:
-Unsaved document -- still untitled
-
*/

@implementation MyDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
        // initialization code
    }
    return self;
}

- (NSString *)windowNibName 
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
}

- (id)addNew:(id)sender {
	[mainWindow makeFirstResponder:mainWindow]; //commits whatever was being edited

	Note *newnote = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
												  inManagedObjectContext:self.managedObjectContext];

	NSArray *oldSelection = [notesController selectedObjects];
	if (oldSelection.count == 1) {
		Note *oldnote = [oldSelection lastObject];

		[newnote setSource:[oldnote source]];
		[newnote setPagenumber:[oldnote pagenumber]];
	}
	
	[notesController addObject:newnote];
	
	[mainWindow makeFirstResponder:pagenumberField];
	
	return newnote;
}

- (IBAction)focusContentEditor:(id)sender {
	[mainWindow makeFirstResponder:contentEditor];
}

- (void)awakeFromNib {
	[self messWithSourceSelector];
}

- (void)messWithSourceSelector {
//	NSMenu *sourceMenu = [sourceSelector menu];
//	NSLog(@"%@", sourceMenu);
//	[sourceMenu addItem:[NSMenuItem separatorItem]];
////	[sourceSelector addItemWithTitle:@"Add source..."];
}

- (IBAction)editSources:(id)sender {
}

- (IBAction)dismissSources:(id)sender {
	[self messWithSourceSelector];
}

- (void)receivedVoiceDictation:(NSString *)dictation {
	NSLog(@"recieved dictation: %@", dictation);
	[[self addNew:self] setContent:dictation];
}

@end
