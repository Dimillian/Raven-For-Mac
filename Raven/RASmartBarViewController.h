//
//  RASmartBarViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/*
*/
#import <Cocoa/Cocoa.h>
#import "RANavigatorViewController.h"
#import "RASmartBarButton.h"

@protocol RASmartBarViewControllerDelegate;
@interface RASmartBarViewController : NSViewController
{
    id<RASmartBarViewControllerDelegate> delegate;
    NSImage *mainIcon; 
    NSImage *firstIcon; 
    NSImage *secondIcon; 
    NSImage *thirdIcon; 
    NSImage *fourthIcon; 
    NSString *folderName; 
    NSString *appName; 
    NSString *firstURL; 
    NSString *secondURL; 
    NSString *thirdURL; 
    NSString *fourthURL; 
    NSInteger *type; 
    int state;
    int selectedButton; 
    
    //google view
    RANavigatorViewController *firstNavigatorView;
    RANavigatorViewController *SecondNavigatorView;
    RANavigatorViewController *ThirdtNavigatorView;
    RANavigatorViewController *FourthNavigatorView;
    
    IBOutlet NSButton *mainButton; 
    IBOutlet RASmartBarButton *firstButton; 
    IBOutlet RASmartBarButton *secondButton; 
    IBOutlet RASmartBarButton *thirdButton;
    IBOutlet RASmartBarButton *fourthButton;
    
    IBOutlet NSImageView *badgeView; 
    IBOutlet NSImageView *lightVIew; 
    
    IBOutlet NSTextField *totalTabsNumber; 
    IBOutlet NSTextField *firstButtonNumber; 
    IBOutlet NSTextField *secondButtonNumber; 
    IBOutlet NSTextField *thirdButtonNumber; 
    IBOutlet NSTextField *fourfthButtonNumber; 
    
    IBOutlet NSView *mainView; 
    
    NSUInteger totalTabs;

}
-(id)initWithDelegate:(id<RASmartBarViewControllerDelegate>)dgate;
-(IBAction)expandApp:(id)sender;
-(IBAction)retractApp:(id)sender;
-(IBAction)firstItemClicked:(id)sender;
-(IBAction)secondItemClicked:(id)sender;
-(IBAction)thirdItemClicked:(id)sender;
-(IBAction)fourItemClicked:(id)sender;
-(void)resetAllButton; 
-(void)setSelectedButton;
-(void)updateTabsNumber; 
-(void)checkButtonNumber; 
-(void)receiveNotification:(NSNotification *)notification;
@property (nonatomic, assign) id<RASmartBarViewControllerDelegate> delegate;
@property (copy) NSString *folderName; 
@property (copy) NSString *appName; 
@property (copy) NSString *firstURL;
@property (copy) NSString *secondURL;
@property (copy) NSString *thirdURL;
@property (copy) NSString *fourthURL;
@property int selectedButton;
@property int state;
@end

@protocol RASmartBarViewControllerDelegate
@optional
//- (void)selectionDidChange:(RASmartBarViewController *)smartBarApp;
- (void)itemDidExpand:(RASmartBarViewController *)smartBarApp;
//- (void)itemDidRetract:(RASmartBarViewController *)smartBarApp;
@end