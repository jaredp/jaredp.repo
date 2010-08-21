#import <Foundation/Foundation.h>
#import "NSObject+SuperMessanger.h"

@interface superclass : NSObject

- (CGRect)CGRectRet;
- (long long)longLongRet;
- (double)doubleRet;
- (int)intRet;
- (char)charRet;

+ (NSRange)NSRangeRet;
+ (short)shortRet;
+ (float)floatRet;
+ (id)objectRet;

@end

@implementation superclass

- (long long)longLongRet {
	return 0xABCDEF0123456789;
}

- (double)doubleRet {
	return 12.28;
}

- (int)intRet {
	return 0xDEADBEEF;
}

- (CGRect)CGRectRet {
	return CGRectMake(12.5, 223.3, 405.6, 58.3);
}

- (char)charRet {
	return 'A';
}

+ (short)shortRet {
	return 12;
}

+ (NSRange)NSRangeRet {
	return NSMakeRange(12, 32);
}

+ (float)floatRet {
	return 12.28;
}

+ (id)objectRet {
	return @"imma string";
}

- (id)objectRet {
	return @"instance imma different string";
}

@end

@interface subclass : superclass @end
@implementation subclass

- (long long)longLongRet {
	return 0x0000000000ABCDEF;
}

- (double)doubleRet {
	return 98.45;
}

- (int)intRet {
	return 77;
}

- (CGRect)CGRectRet {
	return CGRectMake(0.5, 995.6, 400.9, 58.3);
}

- (char)charRet {
	return 'S';
}

+ (short)shortRet {
	return 99;
}

+ (NSRange)NSRangeRet {
	return NSMakeRange(0, 16);
}

+ (float)floatRet {
	return 9.9;
}

+ (id)objectRet {
	return @"imma different string";
}

@end

@interface subsubclass : subclass @end
@implementation subsubclass

- (double)doubleRet {
	return 10000.5;
}

+ (id)objectRet {
	return [NSString stringWithFormat:@"sub sub %@", [[superclass levelSuperOf:self] objectRet]];
}

@end

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	subclass *instance = [subclass new];
	NSLog(@"%X", [instance.super intRet]);
	NSLog(@"%llX", [[instance superWithClass:[superclass class]] longLongRet]);
	
	id instanceSuper = [superclass levelSuperOf:instance];
	NSLog(@"%c", [instanceSuper charRet]);

	CGRect strct = [instanceSuper CGRectRet];
	NSLog(@"{%f, %f, %f, %f}", strct.origin.x, strct.origin.y, strct.size.width, strct.size.height);
	[instance release];

	instance = [subsubclass new];
	NSLog(@"%f", [[[instance super] super] doubleRet]);
	NSLog(@"%@", [[superclass levelSuperOf:instance] performSelector:@selector(objectRet)]);
	[instance release];
	
	NSLog(@"%d", [[superclass levelSuperOf:[subclass class]] shortRet]);
	NSLog(@"%f", [[subclass superWithClass:[superclass class]] floatRet]);
	NSLog(@"%@", NSStringFromRange([[subclass super] NSRangeRet]));
	NSLog(@"%@", [subsubclass objectRet]);
	
    [pool drain];
    return 0;
}
