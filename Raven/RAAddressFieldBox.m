//
//  RAAddressFieldBox.m
//  Raven
//
//  Created by Thomas Ricouard on 16/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAAddressFieldBox.h"

@implementation RAAddressFieldBox
-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect]; 
    if (self) {
    }
    return self; 
}

- (void)updateTrackingAreas
{
    for( NSTrackingArea * trackingArea in [self trackingAreas] )
    {
        [self removeTrackingArea:trackingArea];
    }
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}


- (void)mouseEntered:(NSEvent *)theEvent
{
    [self setFocusColor];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    [self setNormalColor];
}

-(void)setFocusColor
{
    [[self animator]setBorderWidth:2.0];
    [self setBorderColor:[NSColor keyboardFocusIndicatorColor]];
}

-(void)setNormalColor
{
    [[self animator]setBorderWidth:1.0];
    [self setBorderColor:[NSColor disabledControlTextColor]];
}


@end
