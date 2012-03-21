//
//  FTSViewController.m
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright Jared's Software Company 2010. All rights reserved.
//

#import "FTSViewController.h"
#import "Log.h"

@implementation FTSViewController

#define RunButtonPrimaryTitle @"Run"
#define RunButtonAlternateTitle @"Cancel"

- (IBAction)cancelRun:(id)sender {
	[interpreter cancel];
	[runButton setEnabled:NO];
}

- (IBAction)run:(id)sender {	
	[sourceView resignFirstResponder];
	
	[self performSelectorInBackground:@selector(runWithSource:) withObject:sourceView.text];
	
	[sender setAction:@selector(cancelRun:)];
	[sender setTitle:RunButtonAlternateTitle];
}

- (void)runWithSource:(NSString *)source {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[interpreter interpret:source.UTF8String];
	[self performSelectorOnMainThread:@selector(done:) withObject:nil waitUntilDone:NO];
	
	[pool release];	
}

- (IBAction)done:(id)sender {
	[runButton setEnabled:YES];
	[runButton setAction:@selector(run:)];
	[runButton setTitle:RunButtonPrimaryTitle];
	
	consoleView.text = [Log output];
	
	//The following pair scroll consoleView to the bottom, for some reason
	[consoleView becomeFirstResponder];
	[consoleView resignFirstResponder];
}

- (IBAction)clearLog:(id)sender {
	[Log clear];
	[consoleView setText:[Log output]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		interpreter = [[Interpreter alloc] init];
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[sourceView becomeFirstResponder];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
