//
//  MainWindowController.h
//  Raven
//
//  Created by Thomas Ricouard on 24/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Carbon/Carbon.h>
#import <sqlite3.h>
#import "RAHistoryViewController.h"
#import "RANavigatorViewController.h"
#import "RABookmarkViewController.h"
#import "RADownloadViewController.h"
#import "RASettingViewController.h"
#import "RADatabaseController.h"
#import "RASmartBarViewController.h"
#import "RAlistManager.h"
#import "RASettingViewController.h"
#import "Growl/Growl.h"
#import "Growl/GrowlApplicationBridge.h"


@protocol RAMainDelegate; 
@class RavenAppDelegate; 
@interface RAMainWindowController : NSWindowController <NSWindowDelegate, RASmartBarViewControllerDelegate>{
    //the view controller
    id<RAMainDelegate>delegate; 
    IBOutlet NSViewController* myCurrentViewController;
    IBOutlet NSViewController *titleBarViewController; 
    
    //The middle view that is swapped when click on button
    IBOutlet NSView *centeredView; 
    IBOutlet NSView *mainView; 
    IBOutlet NSView *backupView; 
    IBOutlet NSScrollView *smartBarScrollView; 
    CGFloat staticRightViewHeight;
    
    
    //The view under the button, later texture will be applied
    IBOutlet NSView *rightView;  
    
    //keep the navigation mode (need to switch to enum)
    NSUInteger *mode; 
    
    int i; 
    int f; 
    int previousIndex;
    int previousAppNumber; 
    BOOL isHidden; 
    
    NSMutableArray *appList; 
    
    
    
    //button
    IBOutlet NSButton *ravenMenuButton; 
    IBOutlet NSButton *homeButton; 
    IBOutlet NSButton *historyButton;
    IBOutlet NSButton *bookmarkButton; 
    IBOutlet NSButton *downloadButton;
    IBOutlet NSButton *settingButton; 
    
    IBOutlet NSBox *cornerBox; 
    
    IBOutlet NSTextField *firstButtonNumber; 
    
    
    //Raven view
    RANavigatorViewController *navigatorview;
    RAHistoryViewController *historyviewcontroller;
    RABookmarkViewController *bookmarkview; 
    RADownloadViewController *downloadview; 
    RASettingViewController *settingview; 
    
    
    IBOutlet NSView *titleBar;
    
    
    NSString *passedUrl; 
    BOOL isAdressBarHidden; 
    BOOL isAnimated; 
    
    
    
    
}
-(IBAction)hideSideBar:(id)sender;
//button action
-(IBAction)history:(id)sender; 
-(IBAction)home:(id)sender; 
-(IBAction)bookmark:(id)sender;
-(IBAction)download:(id)sender; 
-(IBAction)setting:(id)sender; 
-(IBAction)raven:(id)sender; 

-(IBAction)nextApp:(id)sender;
-(IBAction)previousApp:(id)sender;

//method
-(void)showSideBar; 
-(void)hideSideBar; 
-(IBAction)hideShowAddressBar:(id)sender;
-(void)animate:(NSUInteger)setMode;
-(void)hideall; 
-(void)SetMenuButton;
-(void)updateMenu; 
-(void)initSmartBar; 
-(void)updateSmartBarUi;
-(void)resetSmartBarUi:(BOOL)animated;
-(void)newAppInstalled;
-(void)removeAppAtIndex:(NSUInteger)index; 
-(void)hideAppAtIndex:(NSUInteger)index; 
-(void)showAppAtIndex:(NSUInteger)index; 
-(void)moveAppFromIndex:(NSUInteger)from toIndex:(NSUInteger)to; 
-(void)launchRuntime;
-(NSString *)numberOfDotToDisplay:(NSUInteger)numberOfTabs;
-(void)receiveNotification:(NSNotification *)notification;
@property (nonatomic, assign) id<RAMainDelegate> delegate;
@property (assign) NSString *passedUrl; 
@property (assign) RANavigatorViewController *navigatorview; 
@property (assign) NSButton *downloadButton; 
@property (assign) NSView *centeredView;
@property (assign) NSViewController *myCurrentViewController;
@property (nonatomic, assign) NSMutableArray *appList;
@property BOOL isAnimated; 
@end

//delegate
@protocol RAMainDelegate
@optional
-(void)closeButtonClicked:(RAMainWindowController *)thisWindow; 
@end
