//
//  RAShelfView.m
//  Raven
//
//  Created by Thomas Ricouard on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAGridView.h"
#import "RAMainWindowController.h"
#import "RASmartBarItem.h"
#import "RASmartBarItemViewController.h"
#import "RAMainWindowController.h"
#import "RAlistManager.h"


#define left_margin 50; 
#define x_space 200; 
#define y_space 150; 
#define content_view_width 1200
#define icon_per_row 5

@implementation RAGridView

#pragma mark - init
-(void)awakeFromNib
{
    mainWindow = [[NSApp keyWindow]windowController];
    
    [self resetView];
    [self sizeContentView];
    [self reDrawView]; 

    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:SMART_BAR_UPDATE 
                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(sizeContentView) 
                                                name:NSWindowDidResizeNotification 
                                              object:nil];
    
}

-(void)receiveNotification:(NSNotification *)notification
{
    [self resetView];
    [self reDrawView];
}

-(void)resetView
{
    if (cellArray) {
        for (RAGridViewCell *cell in cellArray) {
            if (cell) {
                [cell removeFromSuperview];
            }
        }
        [cellArray release];
    }
    cellArray = [[NSMutableArray alloc]init]; 
    for (RASmartBarItemViewController *item in mainWindow.appList) {
        RAGridViewCell *cell = [[RAGridViewCell alloc]initWithItem:item.smartBarItem]; 
        [cellArray addObject:cell];
        [cell setDelegate:self];
        [cell release]; 
    }

}

#pragma mark - drawing
-(void)reDrawView
{
    CGFloat x_iconView = left_margin;
    CGFloat y_iconView = 0;
    NSInteger row = 0; 
    for (RAGridViewCell *cell in cellArray) {
        x_iconView = x_iconView + x_space; 
        [cell setFrameOrigin:NSMakePoint(x_iconView, y_iconView)];
        row = row +1;
        if (row == icon_per_row) {
            row = 0; 
            y_iconView = y_iconView + y_space;
            x_iconView = left_margin; 
        }
        [contentView addSubview:cell];
    }
}

-(void)sizeContentView
{
    NSInteger row = 0; 
    CGFloat h = 0; 
    for (RAGridViewCell *cell in cellArray) {
        row = row +1;
        if (row == icon_per_row) {
            h = h + y_space; 
            row = 0; 
        }
    }
    h = h + y_space; 
    if (scrollView.frame.size.height < h) {
        [contentView setFrameSize:NSMakeSize(content_view_width, h)];
    }
    else{
        [contentView setFrameSize:NSMakeSize(content_view_width, scrollView.frame.size.height)];
    }
}


-(void)deleteItem:(RASmartBarItem *)item
{
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setMessageText:@"Are you sure you want to remove this web app?"];
    [alert setIcon:[NSImage imageNamed:@"dialog_app.png"]];
    [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
    //call the alert and check the selected button
    [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:item];
    [alert release];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        RAlistManager *listManager = [RAlistManager sharedUser];
        RASmartBarItem *item = contextInfo; 
        [listManager deleteAppAtIndex:item.index];
        RAGridViewCell *cell = [cellArray objectAtIndex:item.index]; 
        [[cell animator]removeFromSuperview]; 
        [cellArray removeObjectAtIndex:item.index]; 
        [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_REMOVE object:item];
        [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
    }
}


#pragma mark - RAGridViewCellDelegate

-(void)onCloseButtonClick:(RASmartBarItem *)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_HIDDEN object:item];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

-(void)onRemoveButtonClick:(RASmartBarItem *)item
{
    [self deleteItem:item]; 
}

-(void)onAddButtonClick:(RASmartBarItem *)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_SHOW object:item];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

-(void)onMoveDownClick:(RASmartBarItem *)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_UP object:item]; 
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

-(void)onMoveUpClick:(RASmartBarItem *)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_DOWN object:item]; 
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

@end
