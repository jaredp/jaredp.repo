//
//  BGPlayerConnectorViewController.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPCommController.h"

@interface BGPlayerConnectorViewController : UIViewController <JPCommHandshake> {
	NSMutableArray *players;
	NSMutableSet *availableAvatars;
	
	NSDictionary *avatarToSelectedView;
}

@property (weak, nonatomic) IBOutlet UIImageView *NickImage;
@property (weak, nonatomic) IBOutlet UIImageView *JordanImage;
@property (weak, nonatomic) IBOutlet UIImageView *TomImage;
@property (weak, nonatomic) IBOutlet UIImageView *DaisyImage;

@end
