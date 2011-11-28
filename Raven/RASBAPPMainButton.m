//
//  RASBAPPMainButton.m
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RASBAPPMainButton.h"

@implementation RASBAPPMainButton
@synthesize delegate; 

#pragma mark -
#pragma mark INIT
-(id)init
{
    self = [super init]; 
    if (self){
        [self acceptsTouchEvents]; 
        isDown = NO; 
        
    }
    return self; 
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
    [delegate mouseDidClicked:self]; 
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super mouseDown:theEvent]; 
}

-(void)rightMouseUp:(NSEvent *)theEvent
{
    
    NSMenu *menu = [self getMenu];
    
    //Draw the menu on a frame 
    NSRect frame = [self frame];
    NSPoint menuOrigin = [[self superview] convertPoint:NSMakePoint(frame.origin.x+20, frame.origin.y+frame.size.height-25)
                                                               toView:nil];
    
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:menuOrigin
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:0
                                     windowNumber:[[self window] windowNumber]
                                          context:[[self window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1]; 
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:self];
    [super rightMouseUp:theEvent]; 
}

-(void)mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent]; 
}

-(void)scrollWheel:(NSEvent *)theEvent
{
    [delegate mouseDidScroll:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super scrollWheel:theEvent];
}


-(void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent]; 
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
    [secondItem setTitle:@"Hide from Smart Bar"];
    [secondItem setTarget:self];
    [secondItem setAction:@selector(sendHideDelegate:)];
    [secondItem setEnabled:YES];
    [menu addItem:secondItem]; 
    [secondItem release]; 
    [menu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *thirdItem = [[NSMenuItem alloc]init];
    [thirdItem setTitle:@"Hide/Show Smart Bar"];
    [thirdItem setTarget:self.window.windowController];
    [thirdItem setAction:@selector(hideSideBar:)];
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
