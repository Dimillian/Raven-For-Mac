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
#import "HistoryViewController.h"
#import "NavigatorViewController.h"
#import "BookmarkViewController.h"
#import "DownloadViewController.h"
#import "SettingViewController.h"
#import "bookmarkObject.h"
#import "url.h"
#import "DatabaseController.h"
#import "RASmartBarViewController.h"


@interface MainWindowController : NSWindowController <NSWindowDelegate, RASmartBarViewControllerDelegate>{
    //the view controller
    IBOutlet NSViewController* myCurrentViewController;
    
    //The middle view that is swapped when click on button
    IBOutlet NSView *centeredView; 
    IBOutlet NSView *mainView; 
    IBOutlet NSView *backupView; 
    IBOutlet NSScrollView *smartBarScrollView; 
    
    
    //The view under the button, later texture will be applied
    IBOutlet NSView *rightView;  
    
    //keep the navigation mode (need to switch to enum)
    NSUInteger *mode; 
    
    int i; 
    int f; 
    int previousIndex;
    
    NSMutableArray *appList; 
    
    //button
    IBOutlet NSButton *ravenMenuButton; 
    IBOutlet NSButton *homeButton; 
    IBOutlet NSButton *historyButton;
    IBOutlet NSButton *bookmarkButton; 
    IBOutlet NSButton *downloadButton;
    IBOutlet NSButton *settingButton; 
    
    //Raven view
    NavigatorViewController *navigatorview;
    HistoryViewController *historyviewcontroller;
    BookmarkViewController *bookmarkview; 
    DownloadViewController *downloadview; 
    SettingViewController *settingview; 
    
    
    NSString *passedUrl; 
    
    
    
    
}
-(IBAction)hideSideBar:(id)sender;
//button action
-(IBAction)history:(id)sender; 
-(IBAction)home:(id)sender; 
-(IBAction)bookmark:(id)sender;
-(IBAction)download:(id)sender; 
-(IBAction)setting:(id)sender; 
-(IBAction)raven:(id)sender; 

//method
-(void)animate:(NSUInteger)setMode;
-(void)hideall; 
-(void)SetMenuButton; 
-(void)initSmartBar; 
-(void)updateSmartBarUi;
-(void)resetSmartBarUi;
@property (assign) NSString *passedUrl; 
@property (assign) NavigatorViewController *navigatorview; 
@property (assign) NSButton *downloadButton; 
@property (assign) NSView *centeredView;
@property (assign) NSViewController *myCurrentViewController;
@property (nonatomic, assign) NSMutableArray *appList;

@end
