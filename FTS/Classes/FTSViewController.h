//
//  FTSViewController.h
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright Jared's Software Company 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interpreter.h"

@interface FTSViewController : UIViewController {
	IBOutlet UITextView *sourceView;
	IBOutlet UITextView *consoleView;
	
	IBOutlet UIBarButtonItem *runButton;
	
	Interpreter *interpreter;
}
- (IBAction)cancelRun:(id)sender;

- (IBAction)run:(id)sender;
- (void)runWithSource:(NSString *)source;
- (void)done:(id)sender;

- (IBAction)clearLog:(id)sender;

@end

