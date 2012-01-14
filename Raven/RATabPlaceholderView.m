//
//  RATabView.m
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RATabPlaceholderView.h"

@implementation RATabPlaceholderView
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithDelegate:(id<RATabPlaceHolderDelegate>)dgate
{
    self = [super init]; 
    if (self !=nil)
    {
        self.delegate = dgate;
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

-(void)mouseDown:(NSEvent *)theEvent
{
    if ([theEvent clickCount] >= 2) {
        [delegate didReceiveDoubleClick:self];
    }
}

@end
