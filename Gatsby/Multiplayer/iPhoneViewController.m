//
//  iPhoneViewController.m
//  Multiplayer
//
//  Created by Jared Pochtar on 4/12/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "iPhoneViewController.h"
#import "MainViewController.h"
#import "JPNSDataStream.h"

@interface iPhoneViewController ()

@end

@implementation iPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
		
	serverConnectionSession = [[GKSession alloc] initWithSessionID:@"GreatGatsbyProject"
													   displayName:nil
													    sessionMode:GKSessionModeClient];
														
	[serverConnectionSession setDataReceiveHandler:self withContext:NULL];
	serverConnectionSession.delegate = self;
	serverConnectionSession.available = YES;
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	NSLog(@"peer %@ %@ is %d", peerID, [session displayNameForPeer:peerID], state);
	
	if (![@"SERVER" isEqualToString:[session displayNameForPeer:peerID]]) {
		return;
	}
		
	if (state == GKPeerStateAvailable) {
		[session connectToPeer:peerID withTimeout:5.0];
		statusLabel.text = gkId;
	} else if (state == GKPeerStateConnected) {
		gkId = peerID;
		statusLabel.text = [NSString stringWithFormat:@"connected: %@", [session displayNameForPeer:gkId]];
		serverConnectionSession.available = NO;
	}
}

- (void)viewDidUnload
{
	[statusLabel release];
	statusLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)sendData:(NSData *)data {
	NSError *err = nil;
	NSArray *array = [NSArray arrayWithObject:gkId];
	[serverConnectionSession sendData:data toPeers:array 
						 withDataMode:GKSendDataReliable error:&err];
	if (err) NSLog(@"%@", err);
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID
		  inSession:(GKSession *)session context:(void *)ctx
{
	JPNSDataReadStream *stream = [JPNSDataReadStream new];
	stream.data = data;
	char code = [stream readChar];
	switch (code) {
		case 'O':
			statusLabel.text = @"locked";
			break;
			
		case '!':
			avatar = nil;
			statusLabel.text = @"failed";
			break;
			
		case 'D': {
			otherPlayers = [stream read];
			[otherPlayers removeObject:avatar];
			[self performSegueWithIdentifier:@"start" sender:self];
			break;
		}
		
		default:
			NSLog(@"unknown: %c (%d)", code, code);
			break;
	}
	[stream release];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	MainViewController *mvc = segue.destinationViewController;
	[mvc setGKSession:serverConnectionSession gkId:gkId avatar:avatar otherPlayers:otherPlayers];
	serverConnectionSession.delegate = mvc;
}

- (IBAction)selectAvatar:(UIButton *)sender {
	if (avatar) return;

	avatar = sender.titleLabel.text;
	[self sendData:[avatar dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc {
	[statusLabel release];
	[super dealloc];
}
@end
