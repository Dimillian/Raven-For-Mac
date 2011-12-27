//
//  RAShelfView.h
//  Raven
//
//  Created by Thomas Ricouard on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RAGridViewCell.h"

@class RAMainWindowController;
@interface RAGridView : NSViewController <NSCollectionViewDelegate, RAGridViewCellDelegate>
{
    IBOutlet NSScrollView *scrollView; 
    IBOutlet NSView *contentView; 
    NSMutableArray *cellArray; 
    RAMainWindowController *mainWindow; 
}
-(void)receiveNotification:(NSNotification *)notification;
-(void)reDrawView;
-(void)sizeContentView; 


@end
