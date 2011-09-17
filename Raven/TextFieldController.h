//
//  TextFieldController.h
//  Raven
//
//  Created by Thomas Ricouard on 20/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigatorViewController.h"
#import "MAAttachedWindow.h"
#import "DatabaseController.h"


@interface TextFieldController : NSTextField <NSTableViewDelegate, NSTableViewDataSource> {
    
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
