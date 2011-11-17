//
//  StopActivityButton.m
//  Raven
//
//  Created by Thomas Ricouard on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StopActivityButton.h"

@implementation StopActivityButton

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
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, self.superview.frame.origin.y, self.superview.frame.size.width, self.superview.frame.size.height)
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}


- (void)mouseEntered:(NSEvent *)theEvent
{
    if ([self isEnabled] == YES) {
        [[self animator]setAlphaValue:1.0f];
    }
    
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if ([self isEnabled] == YES) {
        [[self animator]setAlphaValue:0.0f]; 
    }
    
}


-(void)mouseDown:(id)sender
{
    if ([self isEnabled] == YES){
        [self setAlphaValue:1.0f]; 
    }
    // this blocks until the button is released
    [super mouseDown:sender];
    // we know the button was released, so we can send this
    [self mouseUp:sender];
}

-(void)mouseUp:(NSEvent *)theEvent
{
    if ([self isEnabled] == YES) {
        [[self animator]setAlphaValue:1.0f];
    }
}


@end
