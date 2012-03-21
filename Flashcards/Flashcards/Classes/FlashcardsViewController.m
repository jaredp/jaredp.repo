//
//  FlashcardsViewController.m
//  Flashcards
//
//  Created by Jared Pochtar on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashcardsViewController.h"

@implementation FlashcardsViewController

- (IBAction)nextWord {
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
	
	[self nextWord];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
