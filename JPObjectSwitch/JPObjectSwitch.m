#import <Foundation/Foundation.h>
#import "JPSwitch.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	char str[256];
	fgets(str, 256, stdin);
	*(char *)memchr(str, '\n', 256) = '\0';
	
	JPSwitch([NSString stringWithUTF8String:str]) {
		JPCase(@"option one"):
		NSLog(@"the first posibility was selected");
		
		JPCase(@"Do Non-NSString objects work?"):
		NSLog(@"Yes, technically any object would work as a key,"
			  @"and anything else would work with an NSValue wrapper");
		
	JPDefaultCase:
		NSLog(@"None of the possiblities were selected.  Oh noes!");
	} JPSwitchEnd;	

    [pool drain];
    return 0;
}
