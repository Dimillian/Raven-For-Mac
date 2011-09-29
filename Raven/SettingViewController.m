//
//  SettingViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import <sqlite3.h>
#import "RavenAppDelegate.h"
#import "MainWindowController.h"
#import "RAlistManager.h"

@implementation SettingViewController

-(void)awakeFromNib
{
    [webview setUIDelegate:self];
    [webview setPolicyDelegate:self];
    [[webview mainFrame]loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://raven.io/demo/apps/"]]];
    
    [tableview setDataSource:self]; 
    [tableview setDelegate:self];
    [tableview setAllowsEmptySelection:NO];
    
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
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSUInteger count = [folders count];
    [folders release]; 
    return count;
    
}

-(IBAction)setNextState:(id)sender
{
    RAlistManager *listManager = [[RAlistManager alloc]init];
    [[stateColumn dataCell]setNextState];
    NSCell *cell = [stateColumn dataCell];
    [listManager changeStateOfAppAtIndex:[tableview selectedRow] withState:[cell state]];
    [listManager release]; 
    [tableview reloadData]; 
    [self refreshSmartBar];
}



- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{  
    
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSDictionary *item = [folders objectAtIndex:row];
    NSString *appName = [item objectForKey:PLIST_KEY_APPNAME];
    NSString *folderNameTemp = [item objectForKey:PLIST_KEY_FOLDER];
    NSNumber *buttonState = [item objectForKey:PLIST_KEY_ENABLE];
    NSString *imagePath = [NSString stringWithFormat:application_support_path@"%@/main.png", folderNameTemp];
    NSImage *tempImage = [[[NSImage alloc]initWithContentsOfFile:[imagePath stringByExpandingTildeInPath]]autorelease];
    [folders release]; 
    if (tableColumn == iconColumn) {
        return tempImage;
    }
    if (tableColumn == appNameColumn) {
        return appName;
    }
    if (tableColumn == stateColumn) {
        return buttonState;
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
        [tableview reloadData]; 
        [listManager release];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[tableview selectedRow]-1];
        [tableview selectRowIndexes:indexSet byExtendingSelection:NO];
    }
    [self refreshSmartBar];
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
        [tableview reloadData]; 
        [listManager release];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[tableview selectedRow]+1];
        [tableview selectRowIndexes:indexSet byExtendingSelection:NO];
    }
    [self refreshSmartBar];
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
     RavenAppDelegate *delegate =  (RavenAppDelegate *)[[NSApplication sharedApplication] delegate];
    [delegate resetSmartBarUI];
}

//Little hack to intercept URL, the webview start provisiosing with the previous request. Only way to catch the URL
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]){
        if ([[sender mainFrameURL]isEqualToString:@""]) {
        }
        else
        {
            MainWindowController *controller = [[webview window]windowController];
            controller.navigatorview.PassedUrl = [sender mainFrameURL]; 
            [controller setting:nil];
            [controller raven:nil];
            [controller.navigatorview addtabs:nil];
            [sender stopLoading:sender];   
        }
    }
}


- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    MainWindowController *controller = [[webView window]windowController];
    controller.navigatorview.PassedUrl = [[request URL]absoluteString]; 
    [controller setting:nil];
    [controller raven:nil];
    [controller.navigatorview addtabs:nil];

}

- (void)dealloc
{
    [webview setUIDelegate:nil]; 
    [webview setPolicyDelegate:nil]; 
    [webview close]; 
    [super dealloc];
}


@end
