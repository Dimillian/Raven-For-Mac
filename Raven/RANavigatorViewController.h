//
//  NavigatorViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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

@class RavenAppDelegate;
@interface RANavigatorViewController : NSViewController <NSMenuDelegate, NSTextFieldDelegate, NSWindowDelegate, RAWebViewControllerDelegate, RATabViewDelegate>{
    
    //Outlet
    IBOutlet NSView *mainView; 
    IBOutlet RATabPlaceholderView *tabPlaceHolder; 
    IBOutlet NSButton *tabsButton;  
    IBOutlet NSButton *allTabsButton; 
    IBOutlet NSTabView *tabController; 
    
    NSString *_baseURL; 
    NSString *_PassedUrl; //THIS variable is super important, it is a mess, but believe me or not it is super important
    NSMutableArray *_tabsArray;
    NSInteger count; 
    BOOL istab; 
    int _fromOtherViews; 
    NSWindow *localWindow; 
    IBOutlet NSMenu *navigatorMenu; 
    BOOL inBackground;
    BOOL isAdressBarHidden; 
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
-(void)windowResize:(id)sender; 
-(void)setImageOnSelectedTab; 
-(void)redrawTabs:(BOOL)fromWindow;
-(void)setMenu; 
//method
-(void)resetAllTabsButon; 

@property int fromOtherViews;
@property (nonatomic, copy) NSString *PassedUrl;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) NSMutableArray *tabsArray; 


@end
