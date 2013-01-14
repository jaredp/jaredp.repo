//
//  JPCommController.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "BGAvatar.h"

@protocol JPCommHandshake <NSObject>

- (BOOL)player:(BGAvatar *)p selectedAvatar:(NSString *)avatar;

@end

@interface JPCommController : NSObject<GKSessionDelegate> {
	GKSession *multiplayerSession;
	BOOL acceptsNewConnections;
	
	NSMutableDictionary *players;
	NSMutableSet *uninitializedPlayers;
}

+ (id)sharedController;

@property __weak id<JPCommHandshake> handshakeDelegate;

- (void)tellAll:(NSData *)data;
- (void)tell:(BGAvatar *)player data:(NSData *)data;

- (void)commandAll:(char)code;
- (void)command:(BGAvatar *)player to:(char)code;

- (void)notAvailableAnymore;

@end
