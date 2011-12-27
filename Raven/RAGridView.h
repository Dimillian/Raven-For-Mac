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
    NSMutableArray *cellArray; 
    RAMainWindowController *mainWindow; 
}
-(void)resetView; 
-(void)receiveNotification:(NSNotification *)notification;
-(void)reDrawView;
-(void)sizeContentView; 
-(void)deleteItem:(RASmartBarItem *)item; 


@end
