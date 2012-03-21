//
//  Note.h
//  Notecards
//
//  Created by Jared Pochtar on 11/27/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Source;

@interface Note :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * pagenumber;
@property (nonatomic, retain) Source * source;

@end



