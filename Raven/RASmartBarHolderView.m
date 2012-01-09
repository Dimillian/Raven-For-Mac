//
//  RASmartBarHolderView.m
//  Raven
//
//  Created by Thomas Ricouard on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RASmartBarHolderView.h"

@implementation RASmartBarHolderView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self acceptsTouchEvents];
        
    }
    
    return self;
}

- (void)updateTrackingAreas
{
    for( NSTrackingArea * trackingArea in [self trackingAreas] )
    {
        [self removeTrackingArea:trackingArea];
    }
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow|NSTrackingEnabledDuringMouseDrag
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}

-(void)rightMouseUp:(NSEvent *)theEvent
{
    
    if (theEvent.locationInWindow.y > self.bounds.origin.y - 50) {
        NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                             location:theEvent.locationInWindow
                                        modifierFlags:NSLeftMouseDownMask // 0x100
                                            timestamp:0
                                         windowNumber:[[self window] windowNumber]
                                              context:[[self window] graphicsContext]
                                          eventNumber:0
                                           clickCount:1
                                             pressure:1]; 
        
        [NSMenu popUpContextMenu:[self getMenu] withEvent:event forView:self];
        
    }
    [super rightMouseUp:theEvent];
     
}

-(NSMenu *)getMenu
{
    
    NSMenu *menu = [[NSMenu alloc]initWithTitle:@"Smart Bar App Menu"];
    NSMenuItem *thirdItem = [[NSMenuItem alloc]init];
    [thirdItem setTitle:@"Hide Smart Bar"];
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

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
