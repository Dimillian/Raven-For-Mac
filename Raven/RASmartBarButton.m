//
//  NSButtonSub.m
//  Raven
//
//  Created by Thomas Ricouard on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASmartBarButton.h"


@implementation RASmartBarButton


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

/*
-(void)showToolTip
{
    if ([self toolTip] != nil) { 
        int side = 2;
        NSPoint where = [self frame].origin;
		where.x += [self frame].size.width / 2;
		where.y += [self frame].size.height / 2;
        [attachedWindow display]; 
        if (!attachedWindow) {
            [NSBundle loadNibNamed:@"tooltip" owner:self];
            attachedWindow = [[MAAttachedWindow alloc] initWithView:tooltip 
                                                    attachedToPoint:where 
                                                           inWindow:[self window] 
                                                             onSide:side 
                                                         atDistance:30];
            [attachedWindow setBorderColor:[NSColor whiteColor]];
            [attachedWindow setBackgroundColor:[NSColor whiteColor]];
            [attachedWindow setAlphaValue:0.65];
            [attachedWindow setViewMargin:3];
            [attachedWindow setBorderWidth:0];
            [attachedWindow setCornerRadius:3];
            [attachedWindow setHasArrow:1];
            [attachedWindow setDrawsRoundCornerBesideArrow:1];
            [attachedWindow setArrowBaseWidth:10];
            [attachedWindow setArrowHeight:10];
            [attachedWindow setAlphaValue:0.0];
            [tooltipText setStringValue:[self toolTip]];
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0.3];  
            [[self window] addChildWindow:attachedWindow ordered:NSWindowAbove];
            [[attachedWindow animator] setAlphaValue:1.0];
            [NSAnimationContext endGrouping];
            
        }
        else
        {
            [self closeSuggestionBox];
        }
    }
}


-(void)closeSuggestionBox
{  
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];  
    [[attachedWindow animator] setAlphaValue:0.0];
    [NSAnimationContext endGrouping];
    [[self window] removeChildWindow:attachedWindow];
    [attachedWindow orderOut:self];
    [attachedWindow release], attachedWindow = nil;; 
}
*/

- (void)mouseEntered:(NSEvent *)theEvent
{
    if ([self isEnabled] == YES) {
        [[self animator]setAlphaValue:0.7f];
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults) {
            if ([standardUserDefaults integerForKey:BUTTON_TOOLTIP] == 1) {
                //timer = [NSTimer scheduledTimerWithTimeInterval:(0.0) target:self selector:@selector(showToolTip) userInfo:nil repeats:NO];
                    [super mouseEntered:theEvent];
            }
        }
    }
    
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if ([self isEnabled] == YES) {
        [[self animator]setAlphaValue:1.0f]; 
    }
    [super mouseExited:theEvent];
    //[self closeSuggestionBox];
}


-(void)mouseDown:(id)sender
{
    if ([self isEnabled] == YES){
        [self setAlphaValue:0.5f];
        
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


- (void)dealloc
{
    [timer release];
    [attachedWindow release]; 
    [tooltipText release]; 
    [super dealloc];
}

@end
