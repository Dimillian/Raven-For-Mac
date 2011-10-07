//
//  RABadgeField.m
//  Raven
//
//  Created by Thomas Ricouard on 07/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RABadgeField.h"

@implementation RABadgeField

-(void)awakeFromNib
{
    [self setDrawsBackground:NO];
}

-(void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    [self lockFocus];
    [[NSImage imageNamed:@"badge.png"]drawInRect:rect
                                        fromRect:rect 
                                       operation:NSCompositeSourceOver 
                                        fraction:1.0];
    [self unlockFocus];
    
}

@end
