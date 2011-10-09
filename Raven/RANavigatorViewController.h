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


@interface RANavigatorViewController : NSViewController <NSMenuDelegate, NSTextFieldDelegate, NSWindowDelegate>{
    IBOutlet NSView *mainView; 
    IBOutlet NSView *tabPlaceHolder; 
    //the view controller
    IBOutlet NSText *text; 
    IBOutlet NSButton *tabsButton;  
    IBOutlet NSButton *allTabsButton; 
    IBOutlet NSScrollView *scrollView; 
    IBOutlet NSTabView *tabController; 
    NSString *UA; 
    NSString *PassedUrl; //THIS variable is super important, it is a mess, but believe me or not it is super important
    NSMutableArray *tabsArray;
    NSInteger curentSelectedTab;
    NSInteger count; 
    double buttonId;  
    
    BOOL istab; 
    
    int fromOtherViews; 
    
    
}
//Bouton action
-(IBAction)tabs:(id)sender; 
-(IBAction)addtabs:(id)sender;
-(IBAction)closeSelectedTab:(id)sender; 
-(IBAction)menutabs:(id)sender;
-(IBAction)closeAllTabs:(id)sender; 
-(void)windowResize:(id)sender; 
-(void)setImageOnSelectedTab; 
//method
-(void)checkua; 
-(void)resetAllTabsButon; 

@property int fromOtherViews;
@property (assign) NSString *PassedUrl;
@property (assign) NSMutableArray *tabsArray; 


@end
