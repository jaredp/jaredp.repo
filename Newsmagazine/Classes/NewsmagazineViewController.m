//
//  NewsmagazineViewController.m
//  Newsmagazine
//
//  Created by Jared Pochtar on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsmagazineViewController.h"

@implementation NewsmagazineViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)restart:(id)sender {
	textView.text = @"";
	[scriptingEngine setCurrentScene:@"Start"];
	lengthofimmutable = textView.text.length;
}

- (void)viewDidLoad {
	[super viewDidLoad];
		
	NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"script" ofType:@"txt"];
	NSString *script = [NSString stringWithContentsOfFile:scriptPath encoding:NSASCIIStringEncoding error:nil];
		
	scriptingEngine = [[ScriptEngine alloc] initWithTextScript:script];
	[scriptingEngine setOutput:^(NSString *output, NSString *image){
		[self output:output];
		if (image) {
			[imageView setImage:[UIImage imageNamed:image]];
		}
	}];
	[scriptingEngine setEnded:^{
		[textView resignFirstResponder];
	}];
	
	[self restart:self];
}

- (void)viewDidUnload {

}

- (void)dealloc {
    [super dealloc];
}

#pragma mark text view terminal mode

- (void)output:(NSString *)string {
	[textView setSelectedRange:NSMakeRange(textView.text.length, 0)];
	[textView insertText:string];
	[textView insertText:@"\n"];
}

- (IBAction)lockInput:(id)sender {
	CGPoint scrollpos = [textView contentOffset];
	scrollpos.y += 25;
	
	NSString *input = [textView.text substringFromIndex:lengthofimmutable];
	[scriptingEngine input:input];
	lengthofimmutable = textView.text.length;
	
	[textView setContentOffset:scrollpos animated:YES];
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if (range.location >= lengthofimmutable) {
		if ([text rangeOfString:@"\n"].location != NSNotFound && range.location == textView.text.length) {
			[self output:text];
			[self lockInput:self];
			return NO;
		} else {
			return YES;
		}
	} else {
		return NO;
	}
}

- (void)textViewDidChangeSelection:(UITextView *)aTextView {
	NSRange selection = textView.selectedRange;
	if (selection.location < lengthofimmutable && selection.length == 0) {
		textView.selectedRange = NSMakeRange(textView.text.length, 0);
	}
}

@end
