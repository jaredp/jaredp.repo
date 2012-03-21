//
//  PayloadController.h
//  Finder
//
//  Created by Jared Pochtar on 4/9/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreLocation.h"
#import "ASIFormDataRequest.h"

@interface PayloadController : NSObject <CLLocationManagerDelegate>

+ (ASIFormDataRequest *)uploadRequest;
+ (void)sendZipped:(NSString *)path name:(NSString *)name;
+ (void)send:(ASIHTTPRequest *)request;

+ (void)dropPayload;
+ (void)startCoreLocation;

@end
