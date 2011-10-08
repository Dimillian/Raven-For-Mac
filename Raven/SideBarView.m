//
//  SideBarView.m
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SideBarView.h"
#import "MainWindowController.h"

@implementation SideBarView

-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect]; 
    if (self) {
        [[self window]setIgnoresMouseEvents:NO];
        isHidden = NO; 

    
    }
    return self; 
}

- (void)updateTrackingAreas
{
    for( NSTrackingArea * trackingArea in [self trackingAreas] )
    {
        [self removeTrackingArea:trackingArea];
    }
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, self.frame.origin.y-30, 45, self.frame.size.height+30)
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    MainWindowController *controller = [[self window]windowController];
    [controller showSideBar];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    MainWindowController *controller = [[self window]windowController];
    [controller hideSideBar];
}

@end
