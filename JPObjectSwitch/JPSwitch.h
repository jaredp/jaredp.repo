/*
 *  JPSwitch.h
 *  JPObjectSwitch
 *
 *  Created by Jared Pochtar on 9/6/10.
 *  Copyright 2010 Jared's Software Company. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/* 
 nil is ignored, so we need a terminator value.  Additionally, we need one for default.
 solution: create two dummy statics, which we will then pass and check references to.
 eg: JPSwitch(selectorobject, ...cases and code..., &JPSwitchTermationIndicator);
 */

extern char JPSwitchTermationIndicator;
extern char JPSwitchDefaultCaseIndicator;

void __JPSwitch(id selector, ...);
#define JPSwitch(selector)	__JPSwitch(selector, ^
#define JPCase(obj)			}, obj, ^{ JPSwitchCase
#define JPStringCase(str)	JPCase(@#str)
#define JPDefaultCase		}, &JPSwitchDefaultCaseIndicator, ^{ JPSwitchCase
#define JPSwitchEnd			, &JPSwitchTermationIndicator)
