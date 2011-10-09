//
//  DownloadViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "url.h"
#import "PXListView.h"
#import "RADownloadController.h"

@interface RADownloadViewController : NSViewController <PXListViewDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet PXListView	*listView;
    IBOutlet NSTextField *downloadPath; 
    IBOutlet NSTextField *size; 
    IBOutlet NSTextField *source; 
    IBOutlet NSTextField *name; 
    IBOutlet NSImageView *iconFile; 
    IBOutlet NSTextField *typeOfFile; 
    IBOutlet NSTextField *date;
    IBOutlet NSDateFormatter *formatter; 
    NSUInteger selectedRowSave; 
    NSInteger count; 
}
-(NSString *)humanReadableFileType:(NSString *)path;
-(IBAction)check:(id)sender; 
-(IBAction)openFile:(id)sender;
-(IBAction)moveToTrash:(id)sender;
-(IBAction)resetList:(id)sender;
-(NSString *)stringFromFileSize:(int)theSize;
-(void)receiveNotification:(NSNotification *)notification;
@end
