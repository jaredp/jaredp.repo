/*
 *  JPSwitch.c
 *  JPObjectSwitch
 *
 *  Created by Jared Pochtar on 9/6/10.
 *  Copyright 2010 Jared's Software Company. All rights reserved.
 *
 */

#import "JPSwitch.h"

char JPSwitchTermationIndicator, JPSwitchDefaultCaseIndicator;

void __JPSwitch(id selector, ...) {
	va_list args;
	va_start(args, selector);
	
	id caseLabel;
	void(^caseBlock)();
	void(^defaultCaseBlock)() = nil;
	
	va_arg(args, void(^)());	//Eat empty first block
	
	NSMapTable *allCases = [NSMapTable mapTableWithWeakToWeakObjects];
	while ((caseLabel = va_arg(args, id)) != (void *)&JPSwitchTermationIndicator) {
		caseBlock = va_arg(args, id);
		if (caseLabel == (void *)&JPSwitchDefaultCaseIndicator) {
			defaultCaseBlock = caseBlock;
		} else if (caseLabel != nil) {
			[allCases setObject:caseBlock forKey:caseLabel];
		}
	}
	
	caseBlock = (void(^)())[allCases objectForKey:selector] ?: defaultCaseBlock;
	if (caseBlock) caseBlock();
}
