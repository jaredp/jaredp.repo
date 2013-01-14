//
//  JPNSDataStream.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <Foundation/Foundation.h>

enum typecodes {
	charCode,
	intCode,
	stringCode,		//as NSData
	dataCode,		//length, bytes
	arrayCode,		//followed by length int
	dictionaryCode	//kv pairs int, (key, obj) * pairs
};

@interface JPNSDataReadStream : NSObject

@property (retain) NSData *data;
@property NSUInteger position;

- (id)read;		//nil probably means is at end

//following are internal

- (char)readChar;
- (int)readInt;

- (NSString *)readNSString;
- (NSData *)readNSData;

- (NSArray *)readNSArray;
- (NSDictionary *)readNSDictionary;

@end

@interface JPNSDataWriteStream : NSObject

@property (retain) NSMutableData *data;
@property NSUInteger position;

- (void)writeChar:(char)c;
- (void)writeInt:(int)i;
- (void)write:(id)object;

- (void)writeNSInt:(int)i;
- (void)writeNSChar:(char)i;

- (void)writeNSString:(NSString *)string;
- (void)writeNSData:(NSData *)data;
- (void)writeData:(NSData *)data;

- (void)writeNSArray:(NSArray *)array;
- (void)writeNSDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryForObject:(id)obj keys:(NSArray *)keys;

// should probably do something for (void *) for ids back and forth...

@end

