//
//  BGPlayerConnectorViewController.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGPlayerConnectorViewController.h"
#import "JPViewController.h"
#import "BGAvatar.h"

@interface BGPlayerConnectorViewController ()

@end

@implementation BGPlayerConnectorViewController
@synthesize NickImage;
@synthesize JordanImage;
@synthesize TomImage;
@synthesize DaisyImage;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	JPViewController *vc = segue.destinationViewController;
	[vc setPlayers:players];
	
	JPCommController *comm = [JPCommController sharedController];
	[comm notAvailableAnymore];
	comm.handshakeDelegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	JPCommController *comm = [JPCommController sharedController];
	comm.handshakeDelegate = self;
	
	players = [NSMutableArray new];
	
	availableAvatars = [NSMutableSet set];
	[availableAvatars addObject:@"Tom"];
	[availableAvatars addObject:@"Daisy"];
	[availableAvatars addObject:@"Nick"];
	[availableAvatars addObject:@"Jordan"];
	
	avatarToSelectedView = [NSDictionary dictionaryWithObjectsAndKeys:
							TomImage, @"Tom",
							DaisyImage, @"Daisy",
							NickImage, @"Nick",
							JordanImage, @"Jordan",
							nil];
}


- (BOOL)player:(BGAvatar *)p selectedAvatar:(NSString *)avatar {
	if (![availableAvatars containsObject:avatar]) {
		return NO;
	}
	
	[availableAvatars removeObject:avatar];
	[p setAvatar:avatar];
	[players addObject:p];
	
	UIImageView *selectedAvatar = [avatarToSelectedView objectForKey:avatar];
	[selectedAvatar setBackgroundColor:[UIColor greenColor]];
	
	return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight 
	|| interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
	[self setNickImage:nil];
	[self setTomImage:nil];
	[self setDaisyImage:nil];
	[self setJordanImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
