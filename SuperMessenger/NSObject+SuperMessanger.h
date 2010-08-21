//
//  NSObject+SuperMessanger.h
//  SuperMessenger
//
//  Created by Jared Pochtar on 8/18/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (SuperMessanger)

+ (id)levelSuperOf:(id)object;
+ (id)superWithClass:(Class)superclass;

- (id)superWithClass:(Class)superclass;
- (id)super;

@end

id object_getSuper(id object, Class superclass);
