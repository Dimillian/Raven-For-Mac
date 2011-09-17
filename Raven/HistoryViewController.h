//
//  HistoryViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <sqlite3.h>
#import "WebViewController.h"
#import "HistoryViewController.h"
#import "bookmarkObject.h"
#import "DatabaseController.h"
#import "PXListView.h"
#import "PXListDocumentView.h"
#import "LionClipView.h"


@interface HistoryViewController : NSViewController <NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource, PXListViewDelegate> {
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
    WebViewController *newtab; 
    IBOutlet PXListView	*listView;
    IBOutlet PXListDocumentView *documentView; 
    IBOutlet NSDateFormatter *formater; 
    IBOutlet NSSearchField *search; 
    IBOutlet NSProgressIndicator *progressIndicator; 
    NSInteger count; 
    BOOL isSearching; 
}

-(IBAction)check:(id)sender; 
-(void)DeleteAction; 
-(IBAction)reloadListView:(id)sender;
-(IBAction)beginUpdateUi:(id)sender;
//-(IBAction)LoadSelectedRow:(id)sender; 
-(IBAction)deleteAnHistoryItem:(id)sender;


@end
