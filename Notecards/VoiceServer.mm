//
//  VoiceServer.m
//  Notecards
//
//  Created by Jared Pochtar on 12/3/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import "VoiceServer.h"
#import "SocketServer.h"

#include <sys/types.h>
#include <ifaddrs.h>
#include <netinet/in.h> 
#include <string.h> 
#include <arpa/inet.h>


@implementation VoiceServer

- (void)awakeFromNib {
	[self spawnServer];
	struct ifaddrs * ifAddrStruct=NULL;
    struct ifaddrs * ifa=NULL;
    void * tmpAddrPtr=NULL;
	
    getifaddrs(&ifAddrStruct);
	
    for (ifa = ifAddrStruct; ifa != NULL; ifa = ifa->ifa_next) {
        if (ifa ->ifa_addr->sa_family==AF_INET) { // check it is IP4
												  // is a valid IP4 Address
            tmpAddrPtr=&((struct sockaddr_in *)ifa->ifa_addr)->sin_addr;
            char addressBuffer[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, tmpAddrPtr, addressBuffer, INET_ADDRSTRLEN);
            printf("%s IP Address %s\n", ifa->ifa_name, addressBuffer); 
        } else if (ifa->ifa_addr->sa_family==AF_INET6) { // check it is IP6
														 // is a valid IP6 Address
            tmpAddrPtr=&((struct sockaddr_in6 *)ifa->ifa_addr)->sin6_addr;
            char addressBuffer[INET6_ADDRSTRLEN];
            inet_ntop(AF_INET6, tmpAddrPtr, addressBuffer, INET6_ADDRSTRLEN);
            printf("%s IP Address %s\n", ifa->ifa_name, addressBuffer); 
        } 
    }
    if (ifAddrStruct!=NULL) freeifaddrs(ifAddrStruct);
	
	//use url to generate qrs: http://qrcode.kaywa.com/img.php?s=8&d=http://192.168.1.5:8000
	
}

- (void)spawnServer {
	[self performSelectorInBackground:@selector(runServer) withObject:nil];
}

- (void)runServer {
	NSAutoreleasePool *outerpool = [NSAutoreleasePool new];
	
	NSURL *html_file_url = [[NSBundle mainBundle] URLForResource:@"voicedictationreciever"
												   withExtension:@"html"];
	
	NSString *html = [NSString stringWithContentsOfURL:html_file_url 
											  encoding:NSUTF8StringEncoding 
												 error:nil];
	
	SocketServer socket(8000);		//should probably be a pref to set the server
	NSLog(@"server running on port %d", socket.getPort());

	while (1) {
		NSAutoreleasePool *pool = [NSAutoreleasePool new];
		
		Connection c = socket.acceptConnection();
		std::string ln = c.read_available();
		if (ln[0] == 'P') ln += c.read_available(false);
		
		NSString *str = [NSString stringWithCString:ln.c_str() encoding:NSUTF8StringEncoding];
		[self performSelectorOnMainThread:@selector(sendStringToFirstResponder:)
							   withObject:str 
							waitUntilDone:NO];
		
		c.send("HTTP/1.1 200 OK\r\n\r\n");
		c.send([html UTF8String]);
		c.send("\r\n");
		
		[pool release];
	}
	[outerpool release];
}

- (void)sendStringToFirstResponder:(NSString *)str {
	NSRange separator = [str rangeOfString:@"\r\n\r\n"];
	if (separator.location == NSNotFound) {
		//some kind of error
		NSLog(@"there was an error?");
		return;
	}
	
	NSString *post_body = [str substringFromIndex:separator.location + separator.length];
	post_body = [post_body stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	if (![post_body isEqual:@""]) {
		[NSApp sendAction:@selector(receivedVoiceDictation:) to:nil from:post_body];
	} else {
		NSLog(@"there was no body?\n%@", str);
	}

}

@end
