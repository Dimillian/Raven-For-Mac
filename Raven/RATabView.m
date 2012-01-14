//
//  RATabView.m
//  Raven
//
//  Created by Thomas Ricouard on 13/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RATabView.h"

@implementation RATabView
@synthesize tabHolder, tabButtonTab, boxTab, faviconTab, progressTab, pageTitleTab, closeButtonTab, delegate; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self.tabButtonTab setDelegate:self];
    [self.pageTitleTab setStringValue:NSLocalizedString(@"New tab", @"NewTab")];
}

-(void)setInitialState
{
    [self.view setAlphaValue:0.0]; 
    [progressTab setHidden:YES];

}

-(IBAction)tabsButtonClicked:(id)sender{
    [delegate tabDidSelect:self];
}

-(IBAction)closeButtonTabClicked:(id)sender{
    [delegate tabWillClose:self];
    
}

-(void)setToolTip:(NSString *)theTooltip
{
    [self.tabButtonTab setToolTip:theTooltip]; 
}

-(void)updateFavicon:(NSImage *)newFavicon
{
    [self.faviconTab setImage:newFavicon]; 
}

-(void)updateTitleAndToolTip:(NSString *)string
{
    [self.pageTitleTab setStringValue:string];
    [self.pageTitleTab setToolTip:string];  
}

-(void)startLoading
{
    [[faviconTab animator]setAlphaValue:0.0];
    [progressTab startAnimation:self];
}

-(void)stopLoading
{
    [progressTab stopAnimation:self];
    [[faviconTab animator]setAlphaValue:1.0];
}

-(void)setSelectedState
{
    [boxTab setBorderWidth:0.0]; 
    [boxTab setBorderColor:[NSColor blackColor]];
    [boxTab setFillColor:[NSColor windowBackgroundColor]];

}

-(void)setNormalState
{
    [[self boxTab]setFillColor:[NSColor scrollBarColor]];
    [[self boxTab]setBorderWidth:1.0]; 
    [[self boxTab]setBorderColor:[NSColor darkGrayColor]];
}


#pragma mark - RATabViewDelegate

-(void)beginDrag:(RATabButton *)button
{
    [delegate tabDidStartDragging:self]; 
}

-(void)swapUp:(RATabButton *)button
{
    [delegate tabDidMoveRight:self]; 
}

-(void)swapDown:(RATabButton *)button
{
    [delegate tabDidMoveLeft:self]; 
}

-(void)endDrag:(RATabButton *)button
{
    [delegate tabDidStopDragging:self]; 
}

-(void)dealloc
{
    [super dealloc]; 
}


@end
