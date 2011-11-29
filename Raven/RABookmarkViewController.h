//
//  BookmarkViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RAItemObject.h"
#import "RADatabaseController.h"
#import "LionClipView.h"
#import "PXListView.h"
#import "PXListDocumentView.h"
#import "RAWebViewController.h"
#import "RAFavoritePanelWController.h"
#import "RANavigatorViewController.h"
#import "GGReadability.h"
#import "RABookmarkCell.h"
#import "RAHistoryCell.h"

@class RAMainWindowController; 
@interface RABookmarkViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, PXListViewDelegate, NSWindowDelegate, GGReadabilityDelegate> {
    IBOutlet NSView *mainView; 
    //IBOutlet NSScrollView *scrollview; 
    //IBOutlet NSTableView *tableview;
    //IBOutlet NSTableColumn *titleColumn; 
    //BOutlet NSTableColumn *urlColumn; 
    //IBOutlet NSTableColumn *faviconColumn; 
    IBOutlet PXListView	*listView;
    IBOutlet PXListDocumentView *documentView; 
    NSInteger count; 
    IBOutlet NSTextField *titleField; 
    IBOutlet NSTextField *urlField; 
    IBOutlet NSImageView *favicon; 
    IBOutlet NSSegmentedControl *selectorButton;
    RAWebViewController *newtab; 
    IBOutlet NSViewController *myCurrentViewController; 
    IBOutlet NSView *switchView;
    IBOutlet NSView *leftView; 
    IBOutlet NSView *labelView;
    IBOutlet NSImageView *placeholder; 
    NSUInteger selectedDefaultRow; 
      IBOutlet NSDateFormatter *formater; 
    IBOutlet NSButton *readButton; 
    IBOutlet NSProgressIndicator *parsingRead; 
    
}

-(void)check:(id)sender; 
-(void)DeleteAction;
-(void)applyCustomCSS; 
-(void)noCustomCSS; 
-(void)reselectRow:(id)sender;
-(IBAction)DeleteSelectedRow:(id)sender; 
-(IBAction)addFavorite:(id)sender;
-(IBAction)changeSegment:(id)sender;
-(IBAction)readabilityButton:(id)sender;
@property (nonatomic, assign) NSSegmentedControl *selectorButton;
@end
