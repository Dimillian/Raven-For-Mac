//
//  TextFieldController.h
//  Raven
//
//  Created by Thomas Ricouard on 20/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RANavigatorViewController.h"
#import "MAAttachedWindow.h"
#import "RADatabaseController.h"


@interface RAAddressField : NSTextField <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate> {
    
    NSTableView *tableViewEdit; 
    NSUInteger i; 
    IBOutlet NSView *test; 
    MAAttachedWindow *attachedWindow;
    IBOutlet NSScrollView *scrollView; 
    NSInteger count; 
    IBOutlet NSTableView *tableview; 
    IBOutlet NSTableColumn *titleColumn; 
    IBOutlet NSTableColumn *urlColumn; 
    IBOutlet NSTableColumn *faviconColumn; 
    int ind; 
}
-(IBAction)LoadSelectedRow:(id)sender; 
-(void)closeSuggestionBox;
-(void)check:(id)sender; 
@property (nonatomic, retain) NSTableView *tableViewEdit; 

@end
