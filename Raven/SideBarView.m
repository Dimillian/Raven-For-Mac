//
//  SideBarView.m
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SideBarView.h"

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
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}


-(void)mouseEntered:(NSEvent *)theEvent
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults integerForKey:SIDEBAR_LIKE_DOCK] == 1 && [[self toolTip]isEqualToString:@"isHidden"]) {
    [       [self animator]setAlphaValue:1.0]; 
            if (isHidden == NO) {
                [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 29)];
                [self display];
                isHidden = YES;
            }
        }
    }

}

-(void)mouseExited:(NSEvent *)theEvent
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults integerForKey:SIDEBAR_LIKE_DOCK] == 1 && [[self toolTip]isEqualToString:@"isHidden"]) {
                [self setAlphaValue:0.0]; 
            if (isHidden == YES) {
                [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 29)];
                isHidden = NO; 
            }
          
        }
     
    }

}
 

@end
