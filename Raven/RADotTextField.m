//
//  RADotTextField.m
//  Raven
//
//  Created by Thomas Ricouard on 13/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RADotTextField.h"

@implementation RADotTextField

-(id)init
{
    self = [super init]; 
    if (self) {
        [self setEditable:NO];
        [self setDrawsBackground:NO];
        [self setFocusRingType:0];
        [self setBordered:NO]; 
        [self setRefusesFirstResponder:YES]; 
        [self setTextColor:[NSColor disabledControlTextColor]];
        [self setFont:[NSFont fontWithName:@"Helvetica" size:11]];
        [self setAlignment:NSCenterTextAlignment];
    }
    return self; 
    

}

- (void)updateTrackingAreas
{
    for( NSTrackingArea * trackingArea in [self trackingAreas] )
    {
        [self removeTrackingArea:trackingArea];
    }
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow|NSTrackingEnabledDuringMouseDrag
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}


-(void)dealloc
{
    [super dealloc]; 
}

@end
