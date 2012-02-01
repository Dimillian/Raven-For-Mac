//
//  RAShelfView.m
//  Raven
//
//  Created by Thomas Ricouard on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RALibraryScreen.h"
#import "RAMainWindowController.h"
#import "RASmartBarItem.h"
#import "RASmartBarItemViewController.h"
#import "RAMainWindowController.h"
#import "RAlistManager.h"
#import "RavenAppDelegate.h"

@implementation RALibraryScreen
@synthesize gridView; 
#pragma mark - init
-(void)awakeFromNib
{
    mainWindow = [[NSApp keyWindow]windowController]; 
    [self.view setFrameSize:mainWindow.window.frame.size]; 
    [gridView setDataSource:self]; 
    [gridView setDelegate:self]; 
    [selectorButton setSelectedSegment:1]; 
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:SMART_BAR_UPDATE 
                                              object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:gridView 
                                            selector:@selector(redraw) 
                                                name:NSWindowDidResizeNotification 
                                              object:nil];
    [self resetView]; 
    [gridView redraw]; 
}


-(void)dealloc{
    [gridView setDataSource:nil]; 
    [gridView setDelegate:nil]; 
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [cellArray release]; 
    [super dealloc]; 
}

-(void)receiveNotification:(NSNotification *)notification
{
    [self resetView];
    [gridView redraw]; 
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
        [cell setDelegate:gridView]; 
        if (selectorButton.selectedSegment == 0) {
            if (item.smartBarItem.isVisible) {
                [cellArray addObject:cell];
            }
        }
        else{
            [cellArray addObject:cell];
        }
        [cell release]; 
    }
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
    [gridView redraw]; 
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

#pragma mark - RAGridViewDataSource
-(NSInteger)numberOfCell
{
    return cellArray.count; 
}

-(NSInteger)numberofCellPerRow
{
    return 5; 
}

-(RAGridViewCell *)cellForIndex:(NSInteger)index
{
    return [cellArray objectAtIndex:index]; 
}

#pragma mark - RAGridViewDelegate

-(void)didClickOnCellCloseButton:(RAGridViewCell *)cell
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_HIDDEN object:cell.data];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

-(void)didClickOnCellRemoveButton:(RAGridViewCell *)cell
{
    [self deleteItem:cell.data]; 
}

-(void)didClickOnCellAddButton:(RAGridViewCell *)cell
{
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_SHOW object:cell.data];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
    [self performSelector:@selector(didMouseDownOnCell:) withObject:cell afterDelay:0.5f];
    

}

-(void)didMouseDownOnCell:(RAGridViewCell *)cell
{
    RASmartBarItemViewController *itemView = [mainWindow.appList objectAtIndex:cell.data.index]; 
    [itemView onMainButtonClick:nil]; 
}


@end
