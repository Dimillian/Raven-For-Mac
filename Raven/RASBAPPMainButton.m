//
//  RASBAPPMainButton.m
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RASBAPPMainButton.h"
#import <math.h>

@implementation RASBAPPMainButton
@synthesize delegate; 

#pragma mark -
#pragma mark INIT
-(id)init
{
    self = [super init]; 
    if (self){
        
    }
    return self; 
}

-(void)awakeFromNib
{
    [self acceptsTouchEvents]; 
    isDown = NO; 
    originalSuperView = [self superview]; 
    originaleFrame = [self frame]; 
}

-(void)setNewOriginaleFrame
{
    originaleFrame = [self frame]; 
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

#pragma mark -
#pragma mark EVENT

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

    BOOL keepOn = YES;
    BOOL isInside = YES;
    NSPoint mouseLoc;
    initialMousePosition = [theEvent locationInWindow]; 
    while (keepOn) {
        theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask |
                    NSLeftMouseDraggedMask];
        mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        isInside = [self mouse:mouseLoc inRect:[self bounds]];

        switch ([theEvent type]) {
            case NSLeftMouseDragged:
                [self moveToLocation:theEvent.locationInWindow withInitialMousePosition:initialMousePosition]; 
                [self displayDraggingMod]; 
                break;
            case NSLeftMouseUp:
                if (isInside) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    if(([[NSApp currentEvent] modifierFlags] & NSControlKeyMask)){
                        [self popupMenuWithLocation:[theEvent locationInWindow]];
                    }
                    else if (!isDragging){
                        [delegate mouseDidClicked:self]; 
                        [super mouseDown:theEvent]; 
                    }  
                }
                keepOn = NO;
                isDragging = NO; 
                [originalSuperView addSubview:self];
                [delegate endDrag:self]; 
                [self displayNormalMod]; 
                [self setFrame:originaleFrame]; 
                break;
            default:
            
                break;
        }
        
    };
    
    return;

}

//Need to review the formula, compare previous with new location and see how many time 60 fit in the rest. 
//Then send the delegate X time, X is the rest
-(void)moveToLocation:(NSPoint)location withInitialMousePosition:(NSPoint)position
{
    isDragging = YES; 
    windowContentView = [[self window]contentView]; 
    
    if (isDragging) {
        //down
        if (location.y < position.y) {
            float rest = fmodf(initialMousePosition.y, location.y);
            float result = fmodf(rest, 60); 
            if(result > 59) {
                [delegate swapDown:self];
            }
        }
        //up
        else{
            float rest = fmodf(location.y, initialMousePosition.y);
            float result = fmodf(rest, 60); 
            if(result > 59) {
                [delegate swapUp:self];
            }
        }
    }
    [self setFrameOrigin:NSMakePoint(0, location.y-25)];
    [windowContentView addSubview:self];
    previousMousePosition = location; 
}

-(void)displayNormalMod
{
    [[self animator]setAlphaValue:1.0];  
}

-(void)displayDraggingMod
{
    [[self animator]setAlphaValue:0.8];  
}

-(void)popupMenuWithLocation:(NSPoint)location
{
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:location
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:0
                                     windowNumber:[[self window] windowNumber]
                                          context:[[self window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1]; 
    
    [NSMenu popUpContextMenu:[self getMenu] withEvent:event forView:self];    
}

-(void)mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent]; 
}

-(void)rightMouseDown:(NSEvent *)theEvent
{
    [self popupMenuWithLocation:[theEvent locationInWindow]]; 
    [super rightMouseDown:theEvent]; 
}


-(void)scrollWheel:(NSEvent *)theEvent
{
    [delegate mouseDidScroll:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super scrollWheel:theEvent];
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

#pragma mark -
#pragma mark MENU
-(NSMenu *)getMenu
{
    NSMenu *menu = [[NSMenu alloc]initWithTitle:@"Smart Bar App Menu"];
    NSMenuItem *firstItem = [[NSMenuItem alloc]init];
    [firstItem setTitle:@"Close Web App"];
    [firstItem setTarget:self];
    [firstItem setAction:@selector(sendCloseDelegate:)];
    [firstItem setEnabled:YES];
    [menu addItem:firstItem]; 
    [firstItem release]; 
    [menu addItem:[NSMenuItem separatorItem]]; 
    NSMenuItem *secondItem = [[NSMenuItem alloc]init];
    [secondItem setTitle:@"Remove from Smart Bar"];
    [secondItem setTarget:self];
    [secondItem setAction:@selector(sendHideDelegate:)];
    [secondItem setEnabled:YES];
    [menu addItem:secondItem]; 
    [secondItem release]; 
    [menu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *thirdItem = [[NSMenuItem alloc]init];
    [thirdItem setTitle:@"Hide/Show Smart bar"];
    [thirdItem setTarget:self.window.windowController];
    [thirdItem setAction:@selector(toggleSmartBar:)];
    [thirdItem setEnabled:YES];
    [menu addItem:thirdItem]; 
    [thirdItem release]; 
    NSMenuItem *fourItem = [[NSMenuItem alloc]init];
    [fourItem setTitle:@"Manage Web Apps"];
    [fourItem setTarget:self.window.windowController];
    [fourItem setAction:@selector(setting:)];
    [fourItem setEnabled:YES];
    [menu addItem:fourItem]; 
    [fourItem release]; 
    NSMenuItem *fiveItem = [[NSMenuItem alloc]init];
    [fiveItem setTitle:@"Visit Web App Shop"];
    [fiveItem setTarget:[[NSApplication sharedApplication]delegate]];
    [fiveItem setAction:@selector(webAppShop:)];
    [fiveItem setEnabled:YES]; 
    [menu addItem:fiveItem]; 
    [fiveItem release]; 
    return [menu autorelease]; 

}

#pragma mark -
#pragma mark other

-(void)sendHideDelegate:(id)sender
{
    [delegate shouldHideApp:self];
}

-(void)sendCloseDelegate:(id)sender
{
    [delegate shouldCloseApp:self];
}
@end
