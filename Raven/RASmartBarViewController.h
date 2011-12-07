//
//  RASmartBarViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RANavigatorViewController.h"
#import "RASmartBarButton.h"
#import "RASBAPPMainButton.h"
#import "RASmartBarHolderView.h"
#import "RAlistManager.h"
#import "RASmartBarItem.h"

@class RAMainWindowController; 
@protocol RASmartBarViewControllerDelegate;
@interface RASmartBarViewController : NSViewController <RASBAPPMainButtonDelegate>
{
    id<RASmartBarViewControllerDelegate> delegate;
    RASmartBarItem *_smartBarItem; 
    NSMutableArray *buttonArray; 
    NSMutableArray *tabNumberFieldArray; 
    int _state;
    int _selectedButton; 
    int _localArrayIndex; 

    
    //self view outlet
    IBOutlet RASmartBarHolderView *mainView; 
    
    //Button outlet
    IBOutlet RASBAPPMainButton *mainButton; 
    IBOutlet NSButton *closeAppButton; 
    
    IBOutlet NSImageView *badgeView; 
    IBOutlet NSImageView *lightVIew; 

    NSUInteger totalTabs;
    
    int _appNumber; 

}
-(id)initWithDelegate:(id<RASmartBarViewControllerDelegate>)dgate 
      withDictionnary:(NSDictionary *)dictionnary
         withArrayIndex:(int)localIndex
   andWithPlistIndex:(int)globalIndex; 

-(void)buttonDidClicked:(id)sender; 
-(void)calculateTotalTab;
-(IBAction)expandApp:(id)sender;
-(void)retractApp:(id)sender;
-(IBAction)closeAppButtonCliced:(id)sender; 
-(void)resetAllButton; 
-(void)setSelectedButton;
-(void)updateTabsNumber; 
-(void)hideCloseAppButton; 
-(void)showCloseAppButton; 
-(void)hoverMainButton; 
-(void)hideHoverMainButton; 
-(void)receiveNotification:(NSNotification *)notification;
-(NSString *)numberOfDotToDisplay:(NSUInteger)numberOfTabs; 


@property (nonatomic, assign) id<RASmartBarViewControllerDelegate> delegate;
@property (nonatomic, retain) RASmartBarItem *smartBarItem; 
@property int selectedButton;
@property int localArrayIndex;
@property int state;
@end

@protocol RASmartBarViewControllerDelegate
@optional
//- (void)selectionDidChange:(RASmartBarViewController *)smartBarApp;
- (void)itemDidExpand:(RASmartBarViewController *)smartBarApp;
//- (void)itemDidRetract:(RASmartBarViewController *)smartBarApp;
@end