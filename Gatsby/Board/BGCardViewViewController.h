//
//  BGCardViewViewController.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGCard.h"

@interface BGCardViewViewController : UIViewController {
	BGCard *card;
}

@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

+ (BGCardViewViewController *)viewForCard:(BGCard *)card;

@end
