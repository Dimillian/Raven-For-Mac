//
//  MyWebView.m
//  Raven
//
//  Created by Thomas Ricouard on 29/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAMainWebView.h"
#import "RAMainWindowController.h"


@implementation RAMainWebView

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
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, self.frame.origin.y - 30, 45, self.frame.size.height + 20)
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    RAMainWindowController *controller = [[self window]windowController];
    [controller showSideBar];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    RAMainWindowController *controller = [[self window]windowController];
    [controller hideSideBar];
}

- (void)dealloc
{
    [super dealloc];
}

@end
