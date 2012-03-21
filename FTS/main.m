//
//  main.m
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright Jared's Software Company 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <signal.h>

void handleSignal(int signal) {
	@throw [NSException exceptionWithName:@"system signal"
								   reason:signal == 10 ? @"EXC_BAD_ACCESS" : [NSString stringWithFormat:@"%d", signal]
								 userInfo:nil];
}

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	for (int i = 0; i < SIGUSR1; i++) {
		signal(i, handleSignal);
	}
	
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
