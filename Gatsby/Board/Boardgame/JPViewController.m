//
//  JPViewController.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "JPViewController.h"
#import "BGAvatar.h"
#import "JPNSDataStream.h"
#import "JPCommController.h"

@interface JPViewController ()

@end

@implementation JPViewController

- (void)setPlayers:(NSArray *)_players {
	players = _players;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSMutableArray *names = [NSMutableArray array];
	for (BGAvatar *player in players) {
		[names addObject:player.avatar];
	}
	
	JPNSDataWriteStream *stream = [JPNSDataWriteStream new];
	[stream writeChar:'D'];
	[stream writeNSArray:names];
	
	JPCommController *comm = [JPCommController sharedController];
	[comm tellAll:stream.data];

	for (BGAvatar *player in players) {
		[board addPlayer:player];
	}
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

@end
