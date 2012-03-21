#import <Foundation/Foundation.h>
#import "JPModelObject.h"

@protocol mymodel_protocol
typedef NSObject <mymodel_protocol> mymodel;

m NSString *name;
m NSString *title;
m NSMutableDictionary *kvp;

@end


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    mymodel *mod = [JPModelObject new];
	[mod setName:@"foo"];
	mod.title = @"hello world!";
	mod.kvp = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
	
	NSLog(@"%@", mod);
	
	NSLog(@"%@", @protocol(mymodel_protocol));
	
	[pool drain];
    return 0;
}
