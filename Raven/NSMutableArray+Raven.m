//
//  NSMutableArray+Raven.m
//  Raven
//
//  Created by Thomas Ricouard on 12/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Raven.h"

@implementation NSMutableArray (customArray)

-(void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
        [obj retain];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
        [obj release];
    }
}

@end
