//
//  Flashcards_NewViewController.h
//  Flashcards New
//
//  Created by Jared Pochtar on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Flashcards_NewViewController : UIViewController {
	IBOutlet UILabel *english;
	IBOutlet UILabel *spanish;
	
	NSMutableDictionary *translations;
}
- (IBAction)shownext;

@end

