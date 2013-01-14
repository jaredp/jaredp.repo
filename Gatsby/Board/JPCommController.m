//
//  JPCommController.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "JPCommController.h"

@implementation JPCommController
@synthesize handshakeDelegate;

JPCommController *sharedController = nil;

+ (id)sharedController {
	if (sharedController == nil) {
		sharedController = [self new];
	}
	return sharedController;
}

- (id)init {
	players = [NSMutableDictionary dictionary];
	uninitializedPlayers = [NSMutableSet set];

	multiplayerSession = [[GKSession alloc] initWithSessionID:@"GreatGatsbyProject"
												  displayName:@"SERVER"
												  sessionMode:GKSessionModeServer];
	multiplayerSession.delegate = self;
	[multiplayerSession setDataReceiveHandler:self withContext:NULL];
	
	multiplayerSession.available = YES;
	
	return self;
}

- (void)notAvailableAnymore {
//	multiplayerSession.available = NO;
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)ctx {
	BGAvatar *player = [players objectForKey:peerID];

	if (handshakeDelegate && [uninitializedPlayers containsObject:peerID]) {
		NSString *selectedAvatar = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		BOOL ok = [handshakeDelegate player:player selectedAvatar:selectedAvatar];
		
		[self command:player to:(ok ? 'O' : '!')];
		if (ok) {
			[uninitializedPlayers removeObject:peerID];
		}
		
		return;
	} else if (handshakeDelegate == nil) {
		[player handleCommData:data];
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	NSLog(@"here %@", handshakeDelegate);

	if (handshakeDelegate) {
		[session acceptConnectionFromPeer:peerID error:nil];
		
		BGAvatar *player = [BGAvatar new];
		player.gkID = peerID;
		[players setObject:player forKey:peerID];
		[uninitializedPlayers addObject:peerID];
				
	} else {
		NSLog(@"disconnected from %@", peerID);
		[session denyConnectionFromPeer:peerID];
	}
}

- (void)tellAll:(NSData *)data {
	NSError *err = nil;
	[multiplayerSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&err];
	if (err) NSLog(@"%@", err);
}

- (void)tell:(BGAvatar *)player data:(NSData *)data {
	NSArray *peers = [NSArray arrayWithObject:player.gkID];
	
	NSError *err = nil;
	[multiplayerSession sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&err];
	if (err) NSLog(@"%@", err);
}

- (void)commandAll:(char)code {
	char data = code;
	[self tellAll:[NSData dataWithBytes:&data length:1]];
}

- (void)command:(BGAvatar *)player to:(char)code {
	char data = code;
	[self tell:player data:[NSData dataWithBytes:&data length:1]];
}



@end
