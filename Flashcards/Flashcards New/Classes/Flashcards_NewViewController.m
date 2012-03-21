//
//  Flashcards_NewViewController.m
//  Flashcards New
//
//  Created by Jared Pochtar on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Flashcards_NewViewController.h"

@implementation Flashcards_NewViewController

- (IBAction)shownext {
	if ([spanish isHidden]) {
		[spanish setHidden:NO];
	} else {
		NSString *newEnglishWord = [[translations allKeys] objectAtIndex:rand() % translations.count];
		[english setText:newEnglishWord];
		[spanish setText:[translations objectForKey:newEnglishWord]];
		
		[spanish setHidden:YES];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *translationsPath = [[NSBundle mainBundle] pathForResource:@"translation" ofType:@"txt"];
	NSString *translationsFile = [NSString stringWithContentsOfFile:translationsPath encoding:NSUTF8StringEncoding error:nil];
	
	translations = [NSMutableDictionary new];
	for (NSString *enSpPair in [translationsFile componentsSeparatedByString:@";\n"]) {
		NSArray *pair = [enSpPair componentsSeparatedByString:@","];
		
		NSString *en = [pair objectAtIndex:0];
		NSString *sp = [pair objectAtIndex:1];
		
		[translations setObject:sp forKey:en];
	}
	
	[self shownext];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
