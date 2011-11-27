//
//  RASBAPPMainButton.m
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RASBAPPMainButton.h"

@implementation RASBAPPMainButton
@synthesize delegate; 

-(id)init
{
    self = [super init]; 
    if (self){
        [self acceptsTouchEvents]; 
        isDown = NO; 
        
    }
    return self; 
}
- (void)updateTrackingAreas
{
    for( NSTrackingArea * trackingArea in [self trackingAreas] )
    {
        [self removeTrackingArea:trackingArea];
    }
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:NSMakeRect(self.bounds.origin.x, self.bounds.origin.y, 55, 55)
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow|NSTrackingEnabledDuringMouseDrag
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}



-(void)mouseEntered:(NSEvent *)theEvent
{
    [self performSelector:@selector(sendMouseEntered:) withObject:nil afterDelay:0.5f];
    [delegate mouseDidEntered:self]; 
    [super mouseEntered:theEvent]; 
}

-(void)mouseExited:(NSEvent *)theEvent
{
    [delegate mouseDidExited:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super mouseExited:theEvent]; 
}

-(void)mouseDown:(NSEvent *)theEvent
{
    [delegate mouseDidClicked:self]; 
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    isDown = YES; 
    [super mouseDown:theEvent]; 
}

-(void)mouseUp:(NSEvent *)theEvent
{
    isDown = NO; 
    [super mouseUp:theEvent]; 
}

-(void)scrollWheel:(NSEvent *)theEvent
{
    [delegate mouseDidScroll:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super scrollWheel:theEvent];
}


-(void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent]; 
}


-(void)sendMouseEntered:(id)sender
{
    [delegate shouldDisplayCloseButton:self];
}

-(void)mouseDownLongPress:(id)sender
{
    isDown = NO; 
    [delegate shouldDisplayHideButton:self]; 
}

@end
