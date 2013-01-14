//
//  JPViewController.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPBoardView.h"


@interface JPViewController : UIViewController {
	__weak IBOutlet JPBoardView *board;
	NSArray *players;
}
- (void)setPlayers:(NSArray *)_players;

@end
