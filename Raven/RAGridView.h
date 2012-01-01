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

@class RAMainWindowController;
@interface RAGridView : NSViewController <NSCollectionViewDelegate, RAGridViewCellDelegate, NSWindowDelegate>
{
    IBOutlet NSScrollView *scrollView; 
    IBOutlet RAGridViewContentView *contentView; 
    IBOutlet NSButton *toggleEditButton; 
    IBOutlet NSSegmentedControl *selectorButton;
    NSMutableArray *cellArray; 
    RAMainWindowController *mainWindow; 
     
}
-(CGFloat)getXbase; 
-(void)resetView; 
-(void)receiveNotification:(NSNotification *)notification;
-(void)reDrawView;
-(void)deleteItem:(RASmartBarItem *)item; 

-(IBAction)toggleEditPressed:(id)sender; 
-(IBAction)selectorButtonPressed:(id)sender; 
-(IBAction)openAppStore:(id)sender;


@end
