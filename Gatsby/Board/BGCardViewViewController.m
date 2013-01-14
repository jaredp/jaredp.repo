//
//  BGCardViewViewController.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGCardViewViewController.h"

@interface BGCardViewViewController ()

@end

@implementation BGCardViewViewController
@synthesize cardLabel;

+ (BGCardViewViewController *)viewForCard:(BGCard *)card {
	BGCardViewViewController *this = [self alloc];
	this->card = card;
	this = [this initWithNibName:[card viewNibName] bundle:nil];
	return this;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	cardLabel.text = card.text;
	self.view.userInteractionEnabled = NO;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[self setCardLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
