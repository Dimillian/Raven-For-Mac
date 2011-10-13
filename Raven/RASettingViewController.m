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
#import "RAlistManager.h"

@implementation RASettingViewController

-(void)awakeFromNib
{
    
    [tableview setDataSource:self]; 
    [tableview setDelegate:self];
    [tableview setAllowsEmptySelection:NO];
    [self reloadDataSource];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:@"newAppInstalled" 
                                              object:nil];;

    
}

-(void)receiveNotification:(NSNotification *)notification
{
    [self reloadDataSource];
}

//Smart reload
-(void)reloadDataSource
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if(folders) [folders release], folders = nil;
    
    folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY]mutableCopy];
    
    if(images)[images release], images = nil;
    
	images = [[NSMutableArray alloc]init];
    for (int i=0; i<[folders count]; i++) {
        NSDictionary *item = [folders objectAtIndex:i];
        NSString *folderNameTemp = [item objectForKey:PLIST_KEY_FOLDER];
        NSString *imagePath = [NSString stringWithFormat:application_support_path@"%@/main.png", folderNameTemp];
        NSImage *tempImage = [[[NSImage alloc]initWithContentsOfFile:[imagePath stringByExpandingTildeInPath]]autorelease];
        if(tempImage == nil)
        {
            tempImage = [NSImage imageNamed:@"app_shelf.png"];
        }
        [images addObject:tempImage];

    }
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
    NSUInteger count = [folders count]; 
    return count;
    
}

-(IBAction)setNextState:(id)sender
{
    RAlistManager *listManager = [[RAlistManager alloc]init];
    [[stateColumn dataCell]setNextState];
    NSCell *cell = [stateColumn dataCell];
    [listManager changeStateOfAppAtIndex:[tableview selectedRow] withState:[cell state]];
    [listManager release]; 
    [self refreshSmartBar];
}



- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{  
    
    NSDictionary *item = [folders objectAtIndex:row];
    NSString *appName = [item objectForKey:PLIST_KEY_APPNAME];
    NSNumber *buttonState = [item objectForKey:PLIST_KEY_ENABLE];
    NSString *categoryName = [NSString stringWithFormat:@"\n%@",[item objectForKey:PLIST_KEY_CATEGORY]];
    NSString *officialState = [NSString stringWithFormat:@"\n%@",[item objectForKey:PLIST_KEY_OFFICIAL]];
    if (tableColumn == iconColumn) {
        return [images objectAtIndex:row];
    }
    if (tableColumn == appNameColumn) {
        return [NSString stringWithFormat:@"\n%@",appName];
    }
    if (tableColumn == stateColumn) {
        return buttonState;
    }
    if (tableColumn == appCategoryColumn) {
        return categoryName;
    }
    if (tableColumn == appCompanyColumn) {
        return officialState;
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
        
        RAlistManager *listManager = [[RAlistManager alloc]init];
        [listManager swapObjectAtIndex:[tableview selectedRow] upOrDown:0];
        [listManager release];
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

-(void)moveItemDown:(id)sender
{
    if ([tableview selectedRow] == -1) {
        [self selectRowSheet];
    }
    else
    {
        RAlistManager *listManager = [[RAlistManager alloc]init];
        [listManager swapObjectAtIndex:[tableview selectedRow] upOrDown:1];
        [listManager release];
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
        RAlistManager *listManager = [[RAlistManager alloc]init];
        [listManager deleteAppAtIndex:selectedRow];

        [listManager release];
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"smartBarWasUpdated" object:nil];
}


- (void)dealloc
{
    [super dealloc];
}


@end
