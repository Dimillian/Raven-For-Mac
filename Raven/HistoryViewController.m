//
//  HistoryViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "NavigatorViewController.h"
#import "RavenAppDelegate.h"
#import "MyListViewCell.h"
#import "MainWindowController.h"

@implementation HistoryViewController

#define LISTVIEW_CELL_IDENTIFIER		@"MyListViewCell"
- (void)awakeFromNib
{
    //set the delegate of the tableview
    newtab = [[WebViewController alloc] initWithNibName:@"NavigatorNoBottom" bundle:nil];
    //cal the view
    [newtab view]; 
    [newtab setDoRegisterHistory:1];
    //set the view on the viewcontroller
    myCurrentViewController = newtab;	// keep track of the current view controller
    
    //set the view on the history view view
    [switchView addSubview: [myCurrentViewController view]];
    [[myCurrentViewController view] setFrame:[switchView bounds]];
    [listView setCellSpacing:0.0f];
	[listView setAllowsEmptySelection:NO];
	[listView registerForDraggedTypes:[NSArray arrayWithObjects: NSStringPboardType, nil]];
	//[self check:nil];

    [search setDelegate:self]; 
    isSearching = NO; 
    [newtab initWithHistoryPage];
    [[newtab webview]setUIDelegate:self];
}



//Reload the tableview list from the database
-(void)check:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self performSelectorOnMainThread:@selector(beginUpdateUi:) withObject:nil waitUntilDone:YES];
    DatabaseController *controler = [DatabaseController sharedUser];
    if (isSearching) {
        [controler historyForString:[search stringValue]];   
    }
    else
    {
        [controler readHistoryFromDatabase];
    }
    count = [controler.history count]; 
    [pool release];
    [self performSelectorOnMainThread:@selector(reloadListView:) withObject:nil waitUntilDone:YES];
}

-(void)reloadListView:(id)sender
{
    NSInteger row = [listView selectedRow]; 
    [loadingView removeFromSuperview];
    [progressIndicator stopAnimation:self];
    [listView setHidden:NO];
    [listView reloadData]; 
    if (isSearching) {
    }
    else
    {
        if (count == 0) {
            [leftView addSubview:labelView];
            [labelView setFrame:[tempview bounds]];
            [search setEnabled:NO];
            [newtab initWithHistoryPage];
        }
        else
        {
            [labelView removeFromSuperview];
            [search setEnabled:YES];
            if (row >= 0) {
                [listView setSelectedRow:row];
            }
        }
    }

}

-(void)beginUpdateUi:(id)sender
{
    [leftView addSubview:loadingView];
    [loadingView bounds];
    [loadingView setFrame:[tempview bounds]];
    [listView setHidden:YES];
    [progressIndicator startAnimation:self];
}


- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView
{
    DatabaseController *controler = [DatabaseController sharedUser];
    return controler.history.count;
}

- (PXListViewCell*)listView:(PXListView*)aListView cellForRow:(NSUInteger)row
{
	MyListViewCell *cell = (MyListViewCell*)[aListView dequeueCellWithReusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	
	if(!cell) {
		cell = [MyListViewCell cellLoadedFromNibNamed:LISTVIEW_CELL_IDENTIFIER reusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	}
	
	// Set up the new cell:
    DatabaseController *controler = [DatabaseController sharedUser];
    //Get the bookmark at the index from the selected row
    bookmarkObject *history = (bookmarkObject *)[controler.history objectAtIndex:row]; 

	[[cell titleLabel] setStringValue:[history title]];
    [[cell url]setStringValue:[history url]];
    NSString *strDate = [formater stringFromDate:[history date]];
    [[cell date]setStringValue:strDate];
    [[cell favicon]setImage:[history favico]];
    
	return cell;
}

- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row
{
	return 50;
}

- (void)listViewSelectionDidChange:(NSNotification*)aNotification
{
    NSInteger row = [listView selectedRow]; 
    NSString *URL = [[newtab webview]mainFrameURL];
    DatabaseController *controller = [DatabaseController sharedUser];
    bookmarkObject *history = (bookmarkObject *)[controller.history objectAtIndex:row];
    //send the url to the class instancied webview
    if (![URL isEqualToString:history.url])
    {
        [newtab initWithUrl:history.url];
    }
}

-(void)listView:(PXListView *)aListView rowDoubleClicked:(NSUInteger)rowIndex
{
    MainWindowController *mainController = [[listView window]windowController];
    NSInteger row = rowIndex; 
    DatabaseController *controller = [DatabaseController sharedUser];
    bookmarkObject *history = (bookmarkObject *)[controller.history objectAtIndex:row];
    mainController.navigatorview.PassedUrl = history.url;
    [mainController.navigatorview addtabs:nil];
    [mainController home:nil]; 
    
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    if ([[search stringValue]isEqualToString:@""])
    {
        isSearching = NO; 
    }
    else
    {
        isSearching = YES; 
    }
    
    [self check:nil];
}
-(IBAction)deleteAnHistoryItem:(id)sender
{
    NSAlert *alert = [[NSAlert alloc] init];
    NSInteger row = [listView selectedRow];
    DatabaseController *controller = [DatabaseController sharedUser];
    if (row > controller.history.count) {
        [alert setMessageText:NSLocalizedString(@"Please select an history item", @"historyPromptError")];
        [alert setInformativeText:NSLocalizedString(@"To delete an item you first need to select an item in the list.", @"HistoryPromptErrorMessage")];
        [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Ok")];
        [alert runModal];
        [alert release];
    }
    else
    {
        NSString *exampleAlertSuppress = @"HistoryAlertSupress";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:exampleAlertSuppress] == YES) {
            [self DeleteAction]; 
            [alert release];
        }
        else
        {
            [alert setMessageText:NSLocalizedString(@"Are you sure you want to delete?", @"bookmarkPrompt")];
            [alert setInformativeText:NSLocalizedString(@"You can not undo this.", @"Continue")];
            [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
            [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
            [alert setShowsSuppressionButton:YES];
            [alert setIcon:[NSImage imageNamed:@"delete_big.png"]];
            //call the alert and check the selected button
            [alert beginSheetModalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
            [alert release];
        }

       
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        if ([[alert suppressionButton] state] == NSOnState) {
            // Suppress this alert from now on.
            NSString *exampleAlertSuppress = @"HistoryAlertSupress";
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:exampleAlertSuppress];
            [defaults synchronize];
        }
        
        [self DeleteAction];        
    }
}

-(void)DeleteAction
{
    NSInteger row = [listView selectedRow]; 
    DatabaseController *controller = [DatabaseController sharedUser];
    bookmarkObject *history = (bookmarkObject *)[controller.history objectAtIndex:row];
    [controller deleteHistoryItem:history.udid]; 
    [self check:nil];
    row =  row -1;
    if (row >= 0) {
        [listView setSelectedRow:row];
    }
    else
    {
        row = row + 1;
        [listView setSelectedRow:row];
    }
}

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    WebView *tempWebview = [[WebView alloc]init]; 
    [tempWebview setFrameLoadDelegate:self]; 
    [[tempWebview mainFrame]loadRequest:request]; 
    return tempWebview; 
}

//Little hack to intercept URL, the webview start provisiosing with the previous request. Only way to catch the URL
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]){
        if ([[sender mainFrameURL]isEqualToString:@""]) {
        }
        else
        {
            MainWindowController *controller = [[[newtab webview]window]windowController];
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
	[super dealloc];
}




@end
