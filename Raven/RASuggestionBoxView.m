//
//  SuggestionBoxView.m
//  Raven
//
//  Created by Thomas Ricouard on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASuggestionBoxView.h"


@implementation RASuggestionBoxView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect]; 
    if (self) {
        [[self window]setIgnoresMouseEvents:NO];
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



-(void)mouseDown:(id)sender
{
    NSLog(@"hello"); 
    // this blocks until the button is released
    [super mouseDown:sender];
    // we know the button was released, so we can send this
    [self mouseUp:sender];
}

-(void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"hello"); 
}


- (void)dealloc
{
    [super dealloc];
}

@end
