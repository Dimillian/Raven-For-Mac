//
//  NavigatorViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//As a note, tabs view is store alongside the webview, with the webview view nib

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <WebKit/WebFrameLoadDelegate.h>
#import "RAItemObject.h"
#import "url.h"
#import "RAAdressTextField.h"
#import "RADatabaseController.h"
#import "RATabPlaceholderView.h"
#import "RAWebViewController.h"
#import "RANSURLDownloadDelegate.h"
#import "RAPopupWindowController.h"
#import "RATabItem.h"


@class RavenAppDelegate;
@interface RANavigatorViewController : NSViewController <NSMenuDelegate, NSTextFieldDelegate, NSWindowDelegate, RATabItemDelegate, RATabPlaceHolderDelegate, RAPopupWindowDelegate>{
    
    //Outlet
    IBOutlet NSView *mainView; 
    IBOutlet RATabPlaceholderView *tabPlaceHolder; 
    IBOutlet NSButton *tabsButton;  
    IBOutlet NSButton *allTabsButton; 
    IBOutlet NSTabView *tabController; 
    
    NSString *_baseURL; 
    NSString *_PassedUrl; //THIS variable is super important, it is a mess, but believe me or not it is super important
    NSMutableArray *_tabsArray;
    NSMutableArray *_popupWindowArray; 
    NSInteger count; 
    BOOL istab; 
    int _fromOtherViews; 
    NSWindow *localWindow; 
    IBOutlet NSMenu *navigatorMenu; 
    BOOL inBackground;
    BOOL isAdressBarHidden; 
    BOOL askForNewWindow; 
    BOOL cmdKey; 
}

-(IBAction)addtabs:(id)sender;
-(IBAction)closeSelectedTab:(id)sender; 
-(IBAction)menutabs:(id)sender;
-(IBAction)closeAllTabs:(id)sender; 
-(IBAction)nextTab:(id)sender;
-(IBAction)previousTab:(id)sender; 
-(void)closeFirtTab; 
-(NSMenu *)getTabsMenu;
-(void)openTabInBackgroundWithUrl:(id)sender;
-(void)openNewTab:(id)sender;
-(void)windowResize:(id)sender; 
-(void)setTabSelectedState; 
-(void)moveIndexOfTabControllerFromIndex:(NSInteger)from toIndex:(NSInteger)to; 
-(void)redrawTabs:(BOOL)fromWindow;
-(void)hideTabHolder; 
-(void)setMenu; 
//method
-(void)resetAllTabsButon; 
-(BOOL)firstTimeLaunch;
-(BOOL)shouldOpenBaseUrl; 
-(BOOL)shouldOpenInBackground:(id)sender; 

@property int fromOtherViews;
@property (nonatomic, copy) NSString *PassedUrl;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) NSMutableArray *tabsArray; 



@end
