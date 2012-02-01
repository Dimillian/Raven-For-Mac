//
//  RAGridViewCell.m
//  Raven
//
//  Created by Thomas Ricouard on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAGridViewCell.h"

@implementation RAGridViewCell
@synthesize delegate, data; 

#pragma mark - init and dealloc
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
        if (data) {
            iconView = [[NSImageView alloc]initWithFrame:NSMakeRect(10, 30, 100, 100)];
            [iconView setImage:data.mainIconBig]; 
            [iconView setImageFrameStyle:NSImageFrameNone];
            [iconView setImageScaling:NSImageScaleProportionallyUpOrDown];
            
            overlay = [[NSImageView alloc]initWithFrame:NSMakeRect(10, 30, 100, 100)];
            [overlay setImage:[NSImage imageNamed:@"black_background.png"]];
            [overlay setImageFrameStyle:NSImageFrameNone];
            [overlay setImageScaling:NSImageScaleProportionallyUpOrDown];
            [overlay setAlphaValue:0.0]; 
            
            closeButton = [[NSButton alloc]initWithFrame:NSMakeRect(-3, 100, 40, 40)];
            [closeButton setTitle:@""]; 
            [closeButton setAction:@selector(closeButtonClicked:)]; 
            [closeButton setTarget:self]; 
            [closeButton setImage:[NSImage imageNamed:@"close_app.png"]]; 
            [closeButton setButtonType:NSMomentaryChangeButton];
            [closeButton setBordered:NO]; 
            [closeButton setAlphaValue:0.0]; 
            [closeButton setEnabled:NO]; 
            
            addButton = [[NSButton alloc]initWithFrame:NSMakeRect(10, 30, 100, 100)];
            [addButton setTitle:@""]; 
            [addButton setAction:@selector(addButtonClicked:)]; 
            [addButton setTarget:self]; 
            [addButton setButtonType:NSMomentaryChangeButton];
            [addButton setBordered:NO]; 
            [addButton setAlphaValue:0.0]; 
            [addButton setEnabled:NO]; 
            
            removeButton = [[NSButton alloc]initWithFrame:NSMakeRect(-3, 100, 40, 40)];
            [removeButton setTitle:@""]; 
            [removeButton setAction:@selector(removeButtonClicked:)]; 
            [removeButton setTarget:self]; 
            [removeButton setImage:[NSImage imageNamed:@"delete_app.png"]]; 
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
            [self addSubview:addButton];
            [self addSubview:closeButton];
            [self addSubview:removeButton]; 
        }

    
    }
    return self; 
}

-(void)dealloc
{
    [iconView release]; 
    [overlay release]; 
    [closeButton release]; 
    [removeButton release]; 
    [addButton release]; 
    [shadowView release]; 
    [textView release]; 
    
    [super dealloc]; 
}

#pragma mark - method
-(void)enableOverlay:(BOOL)cond
{
    if (!inEditMod) {
        if (cond) {
            [[shadowView animator]setAlphaValue:0.5]; 
            [[overlay animator]setAlphaValue:0.5];
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
            [[shadowView animator]setAlphaValue:1.0]; 
            [[closeButton animator]setAlphaValue:0.0]; 
            [[addButton animator]setAlphaValue:0.0]; 
            [closeButton setEnabled:NO]; 
            [addButton setEnabled:NO]; 
            
            [[removeButton animator]setAlphaValue:0.0]; 
            [removeButton setEnabled:NO]; 
        }
    }
}


-(void)toggleEditMod:(BOOL)cond
{
    if (cond) {
        [[addButton animator]setAlphaValue:1.0];
        [addButton setEnabled:YES]; 
        [[closeButton animator]setAlphaValue:0.0]; 
        [closeButton setEnabled:NO];
        [[removeButton animator]setAlphaValue:1.0]; 
        [removeButton setEnabled:YES]; 
        inEditMod = cond; 
    }
    else{
        [[addButton animator]setAlphaValue:0.0];
        [addButton setEnabled:NO]; 
        [[removeButton animator]setAlphaValue:0.0]; 
        [removeButton setEnabled:NO];  
        inEditMod = cond; 
    }
}


#pragma mark - delegate
-(void)closeButtonClicked:(id)sender
{
    [delegate onCloseButtonClick:self]; 
}

-(void)removeButtonClicked:(id)sender
{
    [delegate onRemoveButtonClick:self];
}

-(void)addButtonClicked:(id)sender
{
    [delegate onAddButtonClick:self];
}


#pragma mark - view event
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
    [super mouseEntered:theEvent]; 
}

-(void)mouseExited:(NSEvent *)theEvent
{
    [self enableOverlay:NO]; 
    [super mouseExited:theEvent]; 
}

-(void)mouseDown:(NSEvent *)theEvent
{
    [delegate onMouseDown:self];
    [self enableOverlay:NO]; 
    [super mouseDown:theEvent]; 
}

-(void)mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent];
}

-(void)scrollWheel:(NSEvent *)theEvent
{
    [self enableOverlay:NO]; 
    [super scrollWheel:theEvent]; 
}


@end
