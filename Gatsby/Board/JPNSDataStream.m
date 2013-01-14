//
//  JPNSDataStream.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "JPNSDataStream.h"

@implementation JPNSDataReadStream

@synthesize data, position;

#define expects(len) if (position + len > data.length) ({ NSLog(@"expected past length"); return 0; })
#define bytes ((char *)data.bytes)

- (id)init {
	position = 0;
	return self;
}

- (id)read {
	expects(1);
	char code = [self readChar];
	switch (code) {
		case charCode:	expects(1); return [NSNumber numberWithChar:[self readChar]];
		case intCode:	expects(4); return [NSNumber numberWithInt:[self readInt]];
		case stringCode:			return [self readNSString];
		case dataCode:				return [self readNSData];
		case arrayCode:				return [self readNSArray];
		case dictionaryCode:		return [self readNSDictionary];
			
		default:
			NSLog(@"malformed data! got %c (%d)", code, code);
			return nil;
			break;
	}
}

- (char)readChar {
	expects(1);
	
	char byte = bytes[position];
	
	position += 1;
	
	return byte;
}

- (int)readInt {
	expects(4);
	
	int theInt;
	memcpy(&theInt, bytes + position, 4);
	theInt = ntohl(theInt);
	
	position += 4;
	
	return theInt;
}

- (NSString *)readNSString {
	return [[NSString alloc] initWithData:[self readNSData] encoding:NSUTF8StringEncoding];
}

- (NSData *)readNSData {
	expects(4);
	int length = [self readInt];
	
	expects(length);
	NSData *dataWithBytes = [NSData dataWithBytes:(bytes + position) length:length];
	position += length;
	
	return dataWithBytes;
}

- (NSArray *)readNSArray {
	expects(4);
	int count = [self readInt];
	
	NSMutableArray *array = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		id obj = [self read];
		if (!obj) {
			return nil;
		}
		[array addObject:obj];
	}
	return array;
}

- (NSDictionary *)readNSDictionary {
	expects(4);
	int pairs = [self readInt];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	for (int i = 0; i < pairs; i++) {
		id key = [self read];
		id value = [self read];
		
		if (!key || !value) {
			return nil;
		}
		[dict setObject:value forKey:key];
	}
	
	return dict;
}

#undef expects
#undef bytes

@end


@implementation JPNSDataWriteStream

@synthesize data, position;

- (id)init {
	data = [NSMutableData data];
	return self;
}

- (void)write:(id)object {
	if ([object isKindOfClass:[NSString class]]) {
		[self writeNSString:object];
	} else if ([object isKindOfClass:[NSData class]]) {
		[self writeNSData:object];
	} else if ([object isKindOfClass:[NSArray class]]) {
		[self writeNSArray:object];
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		[self writeNSDictionary:object];
	} else if ([object isKindOfClass:[NSNumber class]]) {
		[self writeNSInt:[object integerValue]];

	} else {
		NSLog(@"ah! trying to write unhandled %@", object);
	}
}

- (void)writeChar:(char)c {
	[data appendBytes:&c length:1];
}

- (void)writeInt:(int)i {
	i = htonl(i);
	[data appendBytes:&i length:4];
}

- (void)writeNSInt:(int)i {
	[self writeChar:intCode];
	[self writeInt:i];
}

- (void)writeNSChar:(char)i {
	[self writeChar:charCode];
	[self writeInt:i];
}

- (void)writeNSString:(NSString *)string {
	[self writeChar:stringCode];
	[self writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)writeNSData:(NSData *)thedata {
	[self writeChar:dataCode];
	[self writeData:thedata];
}

- (void)writeData:(NSData *)thedata {
	[self writeInt:thedata.length];
	[data appendData:thedata];
}

- (void)writeNSArray:(NSArray *)array {
	[self writeChar:arrayCode];
	[self writeInt:array.count];
	for (id obj in array) {
		[self write:obj];
	}
}

- (void)writeNSDictionary:(NSDictionary *)dict {
	[self writeChar:dictionaryCode];
	[self writeInt:dict.count];
	for (id key in dict) {
		[self write:key];
		[self write:[dict objectForKey:key]];
	}
}

- (NSDictionary *)dictionaryForObject:(id)obj keys:(NSArray *)keys {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	for (NSString *key in keys) {
		[dict setObject:[obj valueForKey:key] forKey:key];
	}
	return dict;
}

@end

