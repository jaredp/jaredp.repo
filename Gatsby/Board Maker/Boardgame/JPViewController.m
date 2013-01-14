//
//  JPViewController.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "JPViewController.h"

@interface JPViewController ()

@end

@implementation JPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[board setDotColorCode:0];
}

- (void)viewDidUnload
{
	board = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight 
		|| interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

- (IBAction)changeColor:(UIButton *)sender {
	[board setDotColorCode:sender.tag];
}

@end
