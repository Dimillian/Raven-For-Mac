//
//  SettingViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASettingViewController.h"
#import <sqlite3.h>
#import "RavenAppDelegate.h"
#import "RAMainWindowController.h"

@implementation RASettingViewController

-(void)awakeFromNib
{
    
    [tableview setDataSource:self]; 
    [tableview setDelegate:self];
    [tableview setAllowsEmptySelection:NO];
    [self reloadDataSource];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:NEW_APP_INSTALLED 
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:SMART_BAR_UPDATE 
                                              object:nil];


    
}

-(void)receiveNotification:(NSNotification *)notification
{
    [self reloadDataSource];
}

//Smart reload, caching image
-(void)reloadDataSource
{
    [tableview reloadData]; 
}

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    WebView *tempview = [[WebView alloc]init]; 
    [tempview setFrameLoadDelegate:self]; 
    [[tempview mainFrame]loadRequest:request]; 
    return tempview; 
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    RAMainWindowController *windowController = [[NSApp mainWindow]windowController]; 
    return windowController.appList.count;
    
}

-(IBAction)setNextState:(id)sender
{
    RAlistManager *listManager = [RAlistManager sharedUser];
    [[stateColumn dataCell]setNextState];
    NSCell *cell = [stateColumn dataCell];
    [listManager changeStateOfAppAtIndex:[tableview selectedRow] withState:[cell state]];
    if (cell.state == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_SHOW object:tableview];   
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_HIDDEN object:tableview];   
    }
    [self refreshSmartBar];
}



- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{  
    RAMainWindowController *windowController = [[NSApp mainWindow]windowController]; 
    RASmartBarItem *item = [[windowController.appList objectAtIndex:row]smartBarItem]; 
    NSNumber *state = [NSNumber numberWithBool:item.isVisible];   
    if (tableColumn == iconColumn) {
        return item.mainIcon;
    }
    if (tableColumn == appNameColumn) {
        return item.appName;
    }
    if (tableColumn == stateColumn) {
        return state; 
    }
    if (tableColumn == appCategoryColumn) {
        return item.category; 
    }
    if (tableColumn == appCompanyColumn) {
        return item.makerName;
    }
    if (tableColumn == buttonUpColumn) {
        if (row == 0)
        {
        
        }
    }
    return nil;
    
}

-(void)moveItemUp:(id)sender
{
    if ([tableview selectedRow] == -1) {
        [self selectRowSheet];
    }
    else
    {
        if ([tableview selectedRow] != 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_UP object:tableview];
            RAlistManager *listManager = [RAlistManager sharedUser];
            [listManager swapObjectAtIndex:[tableview selectedRow] upOrDown:0];
            [self refreshSmartBar];
            if (IS_RUNNING_LION) {
                [tableview beginUpdates];
                [tableview moveRowAtIndex:[tableview selectedRow] toIndex:[tableview selectedRow]-1];
                [tableview endUpdates];
            }
            else
            {
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[tableview selectedRow]-1];
                [tableview selectRowIndexes:indexSet byExtendingSelection:NO];
            }
        }
    }
}

-(void)moveItemDown:(id)sender
{
    if ([tableview selectedRow] == -1) {
        [self selectRowSheet];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_DOWN object:tableview];

        RAlistManager *listManager = [RAlistManager sharedUser];
        [listManager swapObjectAtIndex:[tableview selectedRow] upOrDown:1];
        ;
        [self refreshSmartBar];
        if (IS_RUNNING_LION) {
            [tableview beginUpdates];
            [tableview moveRowAtIndex:[tableview selectedRow] toIndex:[tableview selectedRow]+1];
            [tableview endUpdates];
        }
        else
        {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[tableview selectedRow]+1];
            [tableview selectRowIndexes:indexSet byExtendingSelection:NO];
        }
    }
}

-(void)deleteApp:(id)sender
{
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setMessageText:@"Are you sure you want to remove this web app?"];
    [alert setIcon:[NSImage imageNamed:@"dialog_app.png"]];
    [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
    //call the alert and check the selected button
    [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    [alert release];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        NSInteger selectedRow = [tableview selectedRow];
        RAlistManager *listManager = [RAlistManager sharedUser];
        [listManager deleteAppAtIndex:selectedRow];
        [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE_ITEM_REMOVE object:tableview]; 
        [self refreshSmartBar];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:selectedRow-1];
        [tableview selectRowIndexes:indexSet byExtendingSelection:NO];
        
    }
}


-(void)selectRowSheet
{
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setMessageText:@"Please select a row"];
    [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [alert release];
}

-(void)refreshSmartBar
{
    [self reloadDataSource];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc];
}


@end
