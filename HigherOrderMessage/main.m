#import <Foundation/Foundation.h>
#import "NSObject+HigherOrderMessage.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString *string = @"string";
	NSMutableArray *array = [NSMutableArray array];
	
	@try {
		NSLog(@"%@", [string stringByAppendingString:string]);
		NSLog(@"%@", [array stringByAppendingString:string]);
	} @catch (NSException * e) {
		NSLog(@"error: %@", e);
		NSLog(@"now with ifResponds...");
		NSLog(@"%@", [string.ifResponds stringByAppendingString:string]);
		NSLog(@"%@", [array.ifResponds stringByAppendingString:string]);
		NSLog(@"%@", NSStringFromClass([array.ifResponds class]));
	}
	
    // insert code here...
    [pool drain];
    return 0;
}
