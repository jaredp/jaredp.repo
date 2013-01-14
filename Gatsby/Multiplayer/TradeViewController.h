//
//  TradeViewController.h
//  Multiplayer
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeViewController : UIViewController 

@property (retain, nonatomic) IBOutlet UITextField *priceField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *whoControl;

- (IBAction)makeTrade:(id)sender;
- (IBAction)cancel:(id)sender;

@property (retain) NSArray *titles;
- (void)fixTitles;

@property (copy) void (^tradeHandler)(NSString *toWhom, int forPrice);

@end
