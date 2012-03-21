//
//  NewsmagazineViewController.h
//  Newsmagazine
//
//  Created by Jared Pochtar on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextScript.h"

@interface NewsmagazineViewController : UIViewController<UITextViewDelegate> {
	ScriptEngine *scriptingEngine;
	
	IBOutlet UITextView *textView;
	IBOutlet UIImageView *imageView;
	
	NSUInteger lengthofimmutable;
}
- (IBAction)restart:(id)sender;
- (void)output:(NSString *)string;
- (IBAction)lockInput:(id)sender;

@end

@interface UITextView (ZOMGTOTALHACKTHISMIGHTBREAK) <UITextInput>
@end

