//
//  MyWebView.m
//  Raven
//
//  Created by Thomas Ricouard on 29/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyWebView.h"


@implementation MyWebView

- (void)swipeWithEvent:(NSEvent *)event
{
    
    NSLog(@"%@", [event key]);
    CGFloat x = [event deltaX];
    CGFloat y = [event deltaY];
    int i; 
    if (x != 0) {
        i = (x > 0)  ? 1 : 2;
    }
    if (y != 0) {
        i = (y > 0)  ? 3 : 4;
    }    
    switch (i) {
        case 1:
            [self goBack];
            break;
        case 2:
            [self goForward];
            break;
        case 3:
            break;
        case 4:
        default:
            break;

            
    }
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


- (void)dealloc
{
    [super dealloc];
}

@end
