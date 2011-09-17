//
//  BookmarkViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "bookmarkObject.h"
#import "DatabaseController.h"
#import "LionClipView.h"
#import "PXListView.h"
#import "PXListDocumentView.h"
#import "WebViewController.h"
#import "AddFavoritePanel.h"
#import "NavigatorViewController.h"
#import "GGReadability.h"


@interface BookmarkViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, PXListViewDelegate, NSWindowDelegate, GGReadabilityDelegate> {
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
    WebViewController *newtab; 
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
@property (assign) NSSegmentedControl *selectorButton;
@end
