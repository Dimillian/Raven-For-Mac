//
//  RASBAPPMainButton.m
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RASBAPPMainButton.h"
#import <math.h>
#import "RAMainWindowController.h"
#import "RASmartBarItemViewController.h"
#define drop_height 60
#define mouse_in_icon 25

@implementation RASBAPPMainButton
@synthesize delegate, swapForce; 

#pragma mark -
#pragma mark INIT and DEALLOC
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
    originaleImage = [self image]; 
    
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

-(void)dealloc
{
    [super dealloc]; 
}

#pragma mark -
#pragma mark EVENT

-(void)mouseEntered:(NSEvent *)theEvent
{
    [self performSelector:@selector(sendMouseEntered:) withObject:nil afterDelay:0.5f];
    //[self indexOfItemForPoint:[self convertPoint:[theEvent locationInWindow] fromView:nil]];  
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
                
                if (wantHide) {
                    [delegate dragout:self]; 
                    NSSound *systemSound = [NSSound soundNamed:@"remove.aiff"];
                    [systemSound play];
                }
                 
                break;
            default:
            
                break;
        }
        
    };
    
    return;

}

-(NSInteger)indexOfItemForPoint:(NSPoint)point
{
    NSInteger index = 0; 
    RAMainWindowController *mainWC = [[self window]windowController]; 
    for (RASmartBarItemViewController *item in mainWC.appList) {
        if ([self mouse:point inRect:item.mainButton.frame]) {
            index = [mainWC.appList indexOfObject:item]; 
            break; 
        }
    }
    return index; 
}

//Need to review the formula, compare previous with new location and see how many time 60 fit in the rest. 
//Then send the delegate X time, X is the rest
-(void)moveToLocation:(NSPoint)location withInitialMousePosition:(NSPoint)position
{
    //[self indexOfItemForPoint:location]; 
    isDragging = YES; 
    if (isDragging) {
        //down
        if (previousMousePosition.y > location.y) {
            float current = position.y - location.y;
            swapForce = round(current/drop_height); 
            if (swapForce != 0 && swapForce != previousSwapForce) {
                [delegate swapDown:self];
            }
        }
        //up
        else{
            float current = location.y - position.y;
            swapForce = round(current/drop_height);
            if (swapForce != 0 && swapForce != previousSwapForce) {
                [delegate swapUp:self];
            }
        }
        (location.x > 85) ? [self setHideAfterDragginOperation:YES] : [self setHideAfterDragginOperation:NO]; 
    }
    [self setFrameOrigin:NSMakePoint(location.x - mouse_in_icon, location.y-mouse_in_icon)];
    previousSwapForce = swapForce; 
    previousMousePosition = location; 
}

-(void)setHideAfterDragginOperation:(BOOL)op
{
    if (op) {
        wantHide = YES; 
        [[NSCursor disappearingItemCursor]set]; 
    }
    else{
        wantHide = NO; 
        [[NSCursor arrowCursor]set];
    }
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
