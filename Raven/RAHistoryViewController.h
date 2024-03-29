//
//  HistoryViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <sqlite3.h>
#import "RAWebViewController.h"
#import "RAHistoryViewController.h"
#import "RAItemObject.h"
#import "RADatabaseController.h"
#import "PXListView.h"
#import "PXListDocumentView.h"
#import "LionClipView.h"
#import "RAHistoryCell.h"

@class RAMainWindowController, RavenAppDelegate; 
@interface RAHistoryViewController : NSViewController <NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource, PXListViewDelegate> {
    IBOutlet NSView *mainView; 
    IBOutlet NSViewController *myCurrentViewController; 
    IBOutlet NSView *switchView; 
    IBOutlet NSView *leftView; 
    IBOutlet NSView *labelView; 
    IBOutlet NSView *loadingView; 
    IBOutlet NSView *tempview; 
    //IBOutlet NSTableView *tableview;
    IBOutlet NSTableColumn *titleColumn; 
    IBOutlet NSTableColumn *DateColumn; 
    IBOutlet NSTableColumn *faviconColumn; 
    RAWebViewController *newtab; 
    IBOutlet PXListView	*listView;
    IBOutlet PXListDocumentView *documentView; 
    IBOutlet NSDateFormatter *formater; 
    IBOutlet NSSearchField *search; 
    IBOutlet NSProgressIndicator *progressIndicator; 
    NSInteger count; 
    BOOL isSearching; 
    int tempUdid; 
}

-(IBAction)check:(id)sender; 
-(void)DeleteAction; 
-(IBAction)reloadListView:(id)sender;
-(IBAction)beginUpdateUi:(id)sender;
//-(IBAction)LoadSelectedRow:(id)sender; 
-(IBAction)deleteAnHistoryItem:(id)sender;


@end
