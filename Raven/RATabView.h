//
//  RATabView.h
//  Raven
//
//  Created by Thomas Ricouard on 13/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RATabButton.h"
#import "RATabFaviconView.h"
#import "StopActivityButton.h"

@protocol RATabViewDelegate;
@interface RATabView : NSViewController <RATabButtonDelegate>
{
    id<RATabViewDelegate> delegate;
    //TabView Outlet
    IBOutlet RATabFaviconView *faviconTab; 
    IBOutlet NSTextField *pageTitleTab; 
    IBOutlet RATabButton *tabButtonTab; 
    IBOutlet StopActivityButton *closeButtonTab; 
    IBOutlet NSProgressIndicator *progressTab;
    IBOutlet NSBox *boxTab; 
    IBOutlet NSBox *tabHolder; 
}

//tabs
-(IBAction)closeButtonTabClicked:(id)sender;
-(IBAction)tabsButtonClicked:(id)sender;

-(void)setToolTip:(NSString *)theTooltip; 
-(void)updateTitleAndToolTip:(NSString *)string; 
-(void)updateFavicon:(NSImage *)newFavicon; 
-(void)setInitialState; 

-(void)startLoading; 
-(void)stopLoading; 

-(void)setSelectedState; 
-(void)setNormalState; 

@property (nonatomic, assign) id<RATabViewDelegate> delegate;
@property (nonatomic, retain) NSProgressIndicator *progressTab; 
@property (nonatomic, retain) NSBox *boxTab;
@property (nonatomic, retain) NSBox *tabHolder;
@property (nonatomic, retain) RATabButton *tabButtonTab;
@property (nonatomic, retain) NSButton *closeButtonTab; 
@property (nonatomic, retain) NSImageView *faviconTab; 
@property (nonatomic, retain) NSTextField *pageTitleTab;
@end

//delegate
@protocol RATabViewDelegate
@required
-(void)tabWillClose:(RATabView *)tabView;
-(void)tabDidSelect:(RATabView *)tabView;
-(void)tabDidMoveLeft:(RATabView *)tabView; 
-(void)tabDidMoveRight:(RATabView *)tabView;
-(void)tabDidStartDragging:(RATabView *)tabView; 
-(void)tabDidStopDragging:(RATabView *)tabView; 
@end

