//
//  FlashcardsViewController.h
//  Flashcards
//
//  Created by Jared Pochtar on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashcardsViewController : UIViewController {
	IBOutlet UILabel *english;
	IBOutlet UILabel *spanish;
	
	NSMutableDictionary *translations;
}
- (IBAction)nextWord;

@end

