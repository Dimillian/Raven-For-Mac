//
//  RAGridViewCell.m
//  Raven
//
//  Created by Thomas Ricouard on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAGridViewCell.h"

@implementation RAGridViewCell
@synthesize delegate; 

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithItem:(RASmartBarItem *)item
{
    self = [super initWithFrame:NSMakeRect(0, 0, 130, 140)];
    if (self) {
        data = item; 
    
    }
    return self; 
}

-(void)viewDidMoveToSuperview
{
    iconView = [[NSImageView alloc]initWithFrame:NSMakeRect(10, 30, 100, 100)];
    [iconView setImage:data.mainIconBig]; 
    [iconView setImageFrameStyle:NSImageFrameNone];
    [iconView setImageScaling:NSImageScaleProportionallyUpOrDown];
    
    overlay = [[NSImageView alloc]initWithFrame:NSMakeRect(10, 30, 100, 100)];
    [overlay setImage:[NSImage imageNamed:@"overlay_app.png"]];
    [overlay setImageFrameStyle:NSImageFrameNone];
    [overlay setImageScaling:NSImageScaleProportionallyUpOrDown];
    [overlay setAlphaValue:0.0]; 
    
    closeButton = [[NSButton alloc]initWithFrame:NSMakeRect(0, 100, 40, 40)];
    [closeButton setAction:@selector(closeButtonClicked:)]; 
    [closeButton setTarget:self]; 
    [closeButton setImage:[NSImage imageNamed:@"close_app.png"]]; 
    [closeButton setButtonType:NSMomentaryChangeButton];
    [closeButton setBordered:NO]; 
    [closeButton setAlphaValue:0.0]; 
    [closeButton setEnabled:NO]; 
    
    addButton = [[NSButton alloc]initWithFrame:NSMakeRect(0, 100, 40, 40)];
    [addButton setAction:@selector(addButtonClicked:)]; 
    [addButton setTarget:self]; 
    [addButton setImage:[NSImage imageNamed:@"add_off.png"]]; 
    [addButton setButtonType:NSMomentaryChangeButton];
    [addButton setBordered:NO]; 
    [addButton setAlphaValue:0.0]; 
    [addButton setEnabled:NO]; 
    
    removeButton = [[NSButton alloc]initWithFrame:NSMakeRect(0, 100, 40, 40)];
    [removeButton setAction:@selector(removeButtonClicked:)]; 
    [removeButton setTarget:self]; 
    [removeButton setImage:[NSImage imageNamed:@"remove_app.png"]]; 
    [removeButton setButtonType:NSMomentaryChangeButton];
    [removeButton setBordered:NO]; 
    [removeButton setAlphaValue:0.0]; 
    [removeButton setEnabled:NO]; 
    
    shadowView = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 17, 120, 30)]; 
    [shadowView setImage:[NSImage imageNamed:@"shadow_shelf.png"]]; 
    [shadowView setImageFrameStyle:NSImageFrameNone]; 
    [shadowView setImageScaling:NSImageScaleProportionallyUpOrDown]; 
    
    textView = [[NSTextField alloc]initWithFrame:NSMakeRect(10, 0, 100, 20)];
    [textView setEditable:NO];
    [textView setDrawsBackground:NO];
    [textView setFocusRingType:0];
    [textView setBordered:NO]; 
    [textView setRefusesFirstResponder:YES]; 
    [textView setTextColor:[NSColor darkGrayColor]];
    [textView setFont:[NSFont fontWithName:@"Helvetica bold" size:13]];
    [textView setAlignment:NSCenterTextAlignment];
    [textView setStringValue:data.appName];
    
    
    [self addSubview:shadowView];     
    [self addSubview:iconView]; 
    [self addSubview:textView]; 
    [self addSubview:overlay];
    [self addSubview:closeButton];
    [self addSubview:removeButton]; 
    [self addSubview:addButton];

}

-(void)enableOverlay:(BOOL)cond
{
    if (cond) {
        [[overlay animator]setAlphaValue:1.0]; 
        if (data.isVisible) {
            [[closeButton animator]setAlphaValue:1.0]; 
            [closeButton setEnabled:YES]; 
        }
        else{
            [[addButton animator]setAlphaValue:1.0];
            [addButton setEnabled:YES]; 
        }
    }
    else{
        [[overlay animator]setAlphaValue:0.0]; 
        [[closeButton animator]setAlphaValue:0.0]; 
        [[addButton animator]setAlphaValue:0.0]; 
        [closeButton setEnabled:NO]; 
        [addButton setEnabled:NO]; 
    }
}

-(void)displayRemoveButton
{
    
}


-(void)closeButtonClicked:(id)sender
{
    [delegate onCloseButtonClick:data]; 
}

-(void)removeButtonClicked:(id)sender
{
    [delegate onRemoveButtonClick:data];
}

-(void)addButtonClicked:(id)sender
{
    [delegate onAddButtonClick:data];
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

-(void)mouseEntered:(NSEvent *)theEvent
{
    [self enableOverlay:YES]; 
}

-(void)mouseExited:(NSEvent *)theEvent
{
    [self enableOverlay:NO]; 
}

-(void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent]; 
}

-(void)mouseUp:(NSEvent *)theEvent
{
    
    [super mouseUp:theEvent];
}


@end
