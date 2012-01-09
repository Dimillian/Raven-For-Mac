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
#import "RavenAppDelegate.h"

#define top_margin 50
#define left_margin 0; 
#define x_space 200; 
#define y_space 150; 
#define content_view_width 925
#define icon_per_row 5
#define scroller_size 10

@implementation RAGridView

#pragma mark - init
-(void)awakeFromNib
{
    mainWindow = [[NSApp keyWindow]windowController]; 
    [self.view setFrameSize:mainWindow.window.frame.size]; 
    [selectorButton setSelectedSegment:1]; 
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:SMART_BAR_UPDATE 
                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(reDrawView) 
                                                name:NSWindowDidResizeNotification 
                                              object:nil];
    [self resetView];
    [self reDrawView]; 
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [cellArray release]; 
    [super dealloc]; 
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
        if (selectorButton.selectedSegment == 0) {
            if (item.smartBarItem.isVisible) {
                [cellArray addObject:cell];
                [contentView addSubview:cell]; 
            }
        }
        else{
            [cellArray addObject:cell];
            [contentView addSubview:cell]; 
        }
        [cell setDelegate:self];
        [cell release]; 
    }
}

#pragma mark - drawing
-(void)reDrawView
{
    NSInteger row = 0;  
    CGFloat h = top_margin; 
    CGFloat x_iconView = [self getXbase]; 
    for (RAGridViewCell *cell in cellArray) {
        [cell setFrameOrigin:NSMakePoint(x_iconView, h)];
        x_iconView = x_iconView + x_space; 
        row = row +1;
        if (row == icon_per_row) {
            h = h + y_space;
            x_iconView = [self getXbase]; 
            row = 0; 
        }
    }
    h = h + y_space;
    CGFloat final_h = 0; 
    CGFloat final_w = 0; 
    
    (scrollView.frame.size.height < h) ? (final_h = h + top_margin) : (final_h = scrollView.frame.size.height - scroller_size); 
    (scrollView.frame.size.width < content_view_width) ? (final_w = content_view_width) : (final_w = scrollView.frame.size.width - scroller_size);
    
    [contentView setFrameSize:NSMakeSize(final_w, final_h)]; 
}

-(CGFloat)getXbase
{
    CGFloat x_base_iconview; 
    if (scrollView.frame.size.width > content_view_width) {
        x_base_iconview = (scrollView.frame.size.width - content_view_width)/2;
    }
    else{
        x_base_iconview = 0; 
    }
    return x_base_iconview; 
}

#pragma mark - IB action

-(IBAction)toggleEditPressed:(id)sender
{
    for (RAGridViewCell *cell in cellArray) {
        if (toggleEditButton.state == 1) {
            [cell toggleEditMod:YES];  
        }
        else{
            [cell toggleEditMod:NO]; 
        }
    }
}

-(IBAction)selectorButtonPressed:(id)sender
{
    [self resetView]; 
    [self reDrawView];
    [self toggleEditPressed:toggleEditButton]; 
}

-(IBAction)openAppStore:(id)sender
{
    RavenAppDelegate *delegate  = (RavenAppDelegate *)[[NSApplication sharedApplication]delegate]; 
    [delegate webAppShop:sender]; 
}

#pragma mark - alert sheet
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
        [self toggleEditPressed:toggleEditButton]; 
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
    [self performSelector:@selector(onMouseDown:) withObject:item afterDelay:0.5f];
    

}

-(void)onMouseDown:(RASmartBarItem *)item
{
    RASmartBarItemViewController *itemView = [mainWindow.appList objectAtIndex:item.index]; 
    [itemView onMainButtonClick:nil]; 
}


@end
