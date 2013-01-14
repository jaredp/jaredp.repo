//
//  TradeViewController.m
//  Multiplayer
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "TradeViewController.h"

@interface TradeViewController ()

@end

@implementation TradeViewController
@synthesize priceField, whoControl;
@synthesize tradeHandler, titles;

- (IBAction)makeTrade:(id)sender {
	
	int segment = whoControl.selectedSegmentIndex;
	if (segment == UISegmentedControlNoSegment) return;

	NSString *who = [whoControl titleForSegmentAtIndex:segment];
	int price = priceField.text.intValue;

	tradeHandler(who, price);
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)fixTitles {
	[whoControl removeAllSegments];
	for (NSString *title in titles) {
		[whoControl insertSegmentWithTitle:title atIndex:0 animated:NO];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self fixTitles];
	
	[priceField becomeFirstResponder];
	
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
	[self setPriceField:nil];
	[self setWhoControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[priceField release];
	[whoControl release];
	[super dealloc];
}

@end
