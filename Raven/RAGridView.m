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



#define left_margin 50; 
#define x_space 200; 
#define y_space 150; 

@implementation RAGridView

#pragma mark - init
-(void)awakeFromNib
{
    mainWindow = [[NSApp keyWindow]windowController];
    cellArray = [[NSMutableArray alloc]init]; 
    for (RASmartBarItemViewController *item in mainWindow.appList) {
        RAGridViewCell *cell = [[RAGridViewCell alloc]initWithItem:item.smartBarItem]; 
        [cellArray addObject:cell];
        [cell setDelegate:self];
        [cell release]; 
    }
    [scrollView setDocumentView:contentView];
    [self sizeContentView];
    [self reDrawView]; 
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:SMART_BAR_UPDATE 
                                              object:nil];

}

-(void)receiveNotification:(NSNotification *)notification
{
    //[self reDrawView];
}


#pragma mark - drawing
-(void)reDrawView
{
    CGFloat x_iconView = left_margin;
    CGFloat y_iconView = contentView.frame.size.height;
    
    NSInteger row = 0; 
    for (RAGridViewCell *cell in cellArray) {
        x_iconView = x_iconView + x_space; 
        [cell setFrameOrigin:NSMakePoint(x_iconView, y_iconView)];
        row = row +1;
        if (row == 5) {
            row = 0; 
            y_iconView = y_iconView - y_space;
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
        if (row == 5) {
            h = h + y_space; 
            row = 0; 
        }
    }
    [contentView setFrameSize:NSMakeSize(scrollView.bounds.size.width, h)];
}

#pragma mark - RAGridViewCellDelegate

-(void)onCloseButtonClick:(RASmartBarItem *)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_HIDDEN object:item];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

-(void)onRemoveButtonClick:(RASmartBarItem *)item
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_REMOVE object:item];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

-(void)onAddButtonClick:(RASmartBarItem *)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_SHOW object:item];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
    
}

@end
