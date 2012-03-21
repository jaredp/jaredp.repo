//
//  UIScrollView+adjustForKeyboard.h
//  Newsmagazine
//
//  Created by Jared Pochtar on 3/19/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 sets up / tears down automatic adjusting of UIScrollView so that it's not obscured by the keyboard
 assumes that this object reaches the bottom of the screen, and always will (until -ignoreKeyboardPosition anyway)
 assumes that the keyboard is wider than it is tall
 Check impl. for details
 on all known iOS devices, this is true, but newer devices may change this
 assumes that the height of the keyboard is the amount of screen from the bottom that is covered by it
 eg no toolbars on top of the kbd
 assumes that there is no other content offset wanted
 */

@interface KBDAwareTextView : UITextView {
	BOOL isKBDUp;
}
@end
