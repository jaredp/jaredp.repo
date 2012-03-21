//
//  UIScrollView+adjustForKeyboard.m
//  Newsmagazine
//
//  Created by Jared Pochtar on 3/19/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import "KBDAwareTextView.h"

@implementation KBDAwareTextView

- (void)adjustForKeyboardPosition {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];	
}

- (void)ignoreKeyboardPosition {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];	
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	[self adjustForKeyboardPosition];
	return self;
}

- (void)dealloc {
	[self ignoreKeyboardPosition];
	[super dealloc];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    UIEdgeInsets contentInsets = self.contentInset;
	contentInsets.bottom = MIN(kbSize.height, kbSize.width);
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
	
	[UIView beginAnimations:@"keyboardsomethingorother" context:nil];
	[UIView setAnimationDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	[UIView setAnimationCurve:[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];

	CGPoint scroll = self.contentOffset;
	scroll.y += contentInsets.bottom;
	self.contentOffset = scroll;
	
	[UIView commitAnimations];
	
	isKBDUp = YES;
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
	isKBDUp = NO;

    UIEdgeInsets contentInsets = self.contentInset;
	
	float delta = contentInsets.bottom;
	
	contentInsets.bottom = 0;
    self.contentInset = contentInsets;
	self.scrollIndicatorInsets = contentInsets;
}

- (void)setContentInset:(UIEdgeInsets)e {
	if (!isKBDUp) {
		[super setContentInset:e];
	}
}

@end
