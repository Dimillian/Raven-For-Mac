//
//  RATabView.m
//  Raven
//
//  Created by Thomas Ricouard on 12/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RATabButton.h"
#define mouse_in_icon 25

@implementation RATabButton
@synthesize delegate; 

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

-(void)dealloc
{
    [super dealloc]; 
}

-(void)awakeFromNib
{
    [self acceptsTouchEvents];
    isDown = NO; 
    
}

-(void)mouseDown:(NSEvent *)theEvent
{
    
    BOOL keepOn = YES;
    BOOL isInside = YES;
    NSPoint mouseLoc;
    initialMousePosition = [theEvent locationInWindow]; 
    originalSuperView = self.superview.superview;
    swapForce = 0; 
    while (keepOn) {
        theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask |
                    NSLeftMouseDraggedMask];
        mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        isInside = [self mouse:mouseLoc inRect:[self bounds]];
        
        switch ([theEvent type]) {
            case NSLeftMouseDragged:
                [delegate beginDrag:self]; 
                [self moveToLocation:theEvent.locationInWindow withInitialMousePosition:initialMousePosition]; 
                break;
            case NSLeftMouseUp:
                if (isInside) {
                    if (!isDragging){
                        [super mouseDown:theEvent]; 
                    }  
                }
                keepOn = NO;
                isDragging = NO; 
                //[originalSuperView addSubview:self.superview];
                [delegate endDrag:self]; 
                break;
            default:
                
                break;
        }
        
    };
    
    return;
    
}

-(void)moveToLocation:(NSPoint)location withInitialMousePosition:(NSPoint)position
{
    float frameWidth = self.frame.size.width/1; 
    isDragging = YES; 
    if (isDragging) {
        //down
        if (previousMousePosition.x > location.x) {
            float current = position.x - location.x;
            swapForce = round(current/frameWidth); 
            if (swapForce != 0 && swapForce != previousSwapForce) {
                [delegate swapDown:self];
            }
        }
        //up
        else{
            float current = location.x - position.x;
            swapForce = round(current/frameWidth);
            if (swapForce != 0 && swapForce != previousSwapForce) {
                [delegate swapUp:self];
            }
        }
    }
    [self.superview setFrameOrigin:NSMakePoint(location.x - 30, originalSuperView.frame.origin.y)];
    //[windowContentView addSubview:self.superview];
    previousSwapForce = swapForce; 
    previousMousePosition = location; 
}


@end
