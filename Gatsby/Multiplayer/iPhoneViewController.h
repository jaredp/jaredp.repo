//
//  iPhoneViewController.h
//  Multiplayer
//
//  Created by Jared Pochtar on 4/12/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface iPhoneViewController : UIViewController <GKSessionDelegate> {
	GKSession *serverConnectionSession;
	NSString *gkId;
	IBOutlet UILabel *statusLabel;
	
	NSString *avatar;
	NSMutableArray *otherPlayers;
}

- (IBAction)selectAvatar:(UIButton *)sender;

- (void)sendData:(NSData *)data;

@end
