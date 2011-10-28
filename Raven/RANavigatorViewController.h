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
#import "RAWebViewController.h"
#import "RAAddressField.h"
#import "RADatabaseController.h"


@interface RANavigatorViewController : NSViewController <NSMenuDelegate, NSTextFieldDelegate, NSWindowDelegate, RAWebViewControllerDelegate>{
    IBOutlet NSView *mainView; 
    IBOutlet NSView *tabPlaceHolder; 
    IBOutlet NSButton *tabsButton;  
    IBOutlet NSButton *allTabsButton; 
    IBOutlet NSTabView *tabController; 
    NSString *UA; 
    NSString *PassedUrl; //THIS variable is super important, it is a mess, but believe me or not it is super important
    NSMutableArray *tabsArray;
    NSInteger curentSelectedTab;
    NSInteger count; 
    BOOL istab; 
    int fromOtherViews; 
    NSWindow *localWindow; 
    IBOutlet NSMenu *navigatorMenu; 
    BOOL inBackground;
}
//Bouton action
-(IBAction)addtabs:(id)sender;
-(IBAction)closeSelectedTab:(id)sender; 
-(IBAction)menutabs:(id)sender;
-(IBAction)closeAllTabs:(id)sender; 
-(IBAction)nextTab:(id)sender;
-(IBAction)previousTab:(id)sender;
-(NSMenu *)getTabsMenu;
-(void)openTabInBackgroundWithUrl:(id)sender;
-(void)windowResize:(id)sender; 
-(void)setImageOnSelectedTab; 
-(void)redrawTabs:(BOOL)fromWindow;
-(void)setMenu; 
//method
-(void)checkua; 
-(void)resetAllTabsButon; 

@property int fromOtherViews;
@property (assign) NSString *PassedUrl;
@property (assign) NSMutableArray *tabsArray; 


@end
