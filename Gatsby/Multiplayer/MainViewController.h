//
//  MainViewController.h
//  Multiplayer
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "JPNSDataStream.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GKSessionDelegate> {
	GKSession *server;
	NSString *gkId;
	
	NSString *avatar;
	NSArray *otherPlayers;
	
	IBOutlet UILabel *moneyLabel;
	IBOutlet UITableView *cardTableView;
	
	NSArray *cards;
}

- (void)setGKSession:(GKSession *)sess gkId:(NSString *)_gkId
			  avatar:(NSString *)me otherPlayers:(NSArray *)peers;

- (void)sendData:(NSData *)data;

- (void)setMoney:(int)value;
- (void)setCards:(NSArray *)cards;

- (void)writeSelectionToStream:(JPNSDataWriteStream *)stream;
- (IBAction)sendSelection:(id)sender;

@end
