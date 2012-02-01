//
//  RAShelfView.h
//  Raven
//
//  Created by Thomas Ricouard on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RAGridViewCell.h"
#import "RAGridViewContentView.h"
#import "RAGridScrollView.h"

@class RAMainWindowController;
@interface RALibraryScreen : NSViewController <NSCollectionViewDelegate, NSWindowDelegate, RAGridScrollViewDelegate, RAGridViewDataSource>
{
    IBOutlet RAGridScrollView *gridView; 
    IBOutlet NSButton *toggleEditButton; 
    IBOutlet NSSegmentedControl *selectorButton;
    NSMutableArray *cellArray; 
    RAMainWindowController *mainWindow; 
     
}

@property (nonatomic, retain) RAGridScrollView *gridView; 
-(void)resetView; 
-(void)receiveNotification:(NSNotification *)notification;
-(void)deleteItem:(RASmartBarItem *)item; 

-(IBAction)toggleEditPressed:(id)sender; 
-(IBAction)selectorButtonPressed:(id)sender; 
-(IBAction)openAppStore:(id)sender;


@end
