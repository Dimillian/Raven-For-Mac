//
//  SettingViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RADatabaseController.h"
#import "RAlistManager.h"

@class RAMainWindowController; 
@interface RASettingViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
    
    IBOutlet NSTableView *tableview; 
    IBOutlet NSTableColumn *iconColumn; 
    IBOutlet NSTableColumn *appNameColumn; 
    IBOutlet NSTableColumn *stateColumn; 
    IBOutlet NSTableColumn *appCategoryColumn; 
    IBOutlet NSTableColumn *appCompanyColumn; 
    IBOutlet NSTableColumn *buttonUpColumn; 
    IBOutlet NSTableColumn *buttonDownColumn; 
    NSArray *folders;
    NSMutableArray *images; 
    
    
    
}
-(void)receiveNotification:(NSNotification *)notification;
-(IBAction)moveItemDown:(id)sender;
-(IBAction)moveItemUp:(id)sender;
-(IBAction)setNextState:(id)sender;
-(void)selectRowSheet;
-(void)refreshSmartBar; 
-(void)reloadDataSource;
-(IBAction)deleteApp:(id)sender;

@end
