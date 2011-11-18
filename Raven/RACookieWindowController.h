//
//  RACookieWindowController.h
//  Raven
//
//  Created by Thomas Ricouard on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RACookieWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet NSTableView *tableview;
    IBOutlet NSTableColumn *titleColumn; 
    IBOutlet NSTableColumn *urlColumn; 
    IBOutlet NSTableColumn *commentColumn; 
    IBOutlet NSButton *deleteButton; 
    NSMutableArray *localCookieStore; 
}

-(void)fetchCookie; 
-(IBAction)deleteSelectedCookie:(id)sender; 

@end
