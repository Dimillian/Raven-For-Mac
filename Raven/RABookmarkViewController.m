//
//  BookmarkViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RABookmarkViewController.h"
#import "RABookmarkCell.h"
#import "RAMainWindowController.h"
#import "RAHistoryCell.h"


@implementation RABookmarkViewController
@synthesize selectorButton;


#define LISTVIEW_CELL_IDENTIFIER		@"RABookmarkCell"
#define LISTVIEW_CELL_IDENTIFIER_history		@"RAHistoryCell"
- (void)awakeFromNib
{
    //set the delegate of the tableview
    //[tableview setDelegate:self]; 
    //[tableview setDataSource:self];
    /*
    if (IS_RUNNING_LION) {
    [scrollview setDrawsBackground:YES];
    [scrollview setBackgroundColor:[NSColor clearColor]];
    LionClipView * clipView = [[[LionClipView alloc] initWithFrame:[[scrollview contentView] frame]] autorelease];
    [scrollview setContentView:clipView];
    [clipView setCopiesOnScroll:NO];
    [scrollview setDocumentView:listView];
    }
     */
    
    //set the delegate of the tableview
    newtab = [[RAWebViewController alloc] initWithNibName:@"NavigatorNoBottom" bundle:nil];
    //cal the view
    [newtab view]; 
    //set the view on the viewcontroller
    myCurrentViewController = newtab;	// keep track of the current view controller
    
    //set the view on the history view view
    [switchView addSubview: [myCurrentViewController view]];
    [[myCurrentViewController view] setFrame:[switchView bounds]];
    
    [listView setCellSpacing:0.0f];
    [listView setAllowsEmptySelection:NO];
    [listView registerForDraggedTypes:[NSArray arrayWithObjects: NSStringPboardType, nil]];
    [self check:nil];
    [selectorButton setSelectedSegment:1];
    [newtab initWithBookmarkPage];
    [[newtab webview]setFrame:NSMakeRect(newtab.webview.frame.origin.x, newtab.webview.frame.origin.y, newtab.webview.frame.size.width, newtab.webview.frame.size.height+22)];
    [[newtab webview]setUIDelegate:self];

}

-(void)check:(id)sender
{
    //NSInteger row = [listView selectedRow];
    RADatabaseController *controller = [RADatabaseController sharedUser];
    if ([selectorButton selectedSegment] == 0) {
        [controller readBookmarkFromDatabase:[selectorButton selectedSegment] order:1];
    }
    else
    {
        [controller readBookmarkFromDatabase:[selectorButton selectedSegment] order:2];
    }
    count = controller.bookmarks.count;
    if (count == 0) {
        [leftView addSubview:labelView];
        [labelView bounds];
        [newtab initWithBookmarkPage];
        if ([selectorButton selectedSegment] == 0) {
            [placeholder setImage:[NSImage imageNamed:@"favorites_empty.png"]];
        }
        else
        {
            [placeholder setImage:[NSImage imageNamed:@"bookmarks_empty.png"]];
        }
    }
    else
    {
        [labelView removeFromSuperview];
        
        /*
        if (row > 0) {
        [listView setSelectedRow:row]; 
        }
         */
    } 
    [listView reloadData]; 
    
}

-(void)changeSegment:(id)sender
{
    [self check:nil]; 
}
/*
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    DatabaseController *controller = [DatabaseController sharedUser];
    [controller readBookmarkFromDatabase]; 
    NSInteger count = [controller.bookmarks count]; 
    return count; 
}



- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{  
    
    DatabaseController *controller = [DatabaseController sharedUser];
    bookmarkObject *bookmark = (bookmarkObject*)[controller.bookmarks objectAtIndex:row]; 
    if (tableColumn == titleColumn) {
	return bookmark.title;
    }
    if (tableColumn == urlColumn) {
        return bookmark.url; 
    }
    if (tableColumn == faviconColumn)
    {
        return bookmark.favico; 
    }
    
    return nil; 
    
}
 */


- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView
{ 
    return count; 
}

- (PXListViewCell*)listView:(PXListView*)aListView cellForRow:(NSUInteger)row
{
    if ([selectorButton selectedSegment] == 0) {
	RABookmarkCell *cell = (RABookmarkCell*)[aListView dequeueCellWithReusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	
        if(!cell) {
            cell = [RABookmarkCell cellLoadedFromNibNamed:LISTVIEW_CELL_IDENTIFIER reusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
        }
	
        RADatabaseController *controller = [RADatabaseController sharedUser];
        RAItemObject *bookmark = (RAItemObject*)[controller.bookmarks objectAtIndex:row]; 
    
        [[cell titleLabel] setStringValue:[bookmark title]];
        [[cell url]setStringValue:[bookmark url]];
        [[cell favicon]setImage:[bookmark favico]];
        return cell;
    }
    else
    {
        RAHistoryCell *cell = (RAHistoryCell*)[aListView dequeueCellWithReusableIdentifier:LISTVIEW_CELL_IDENTIFIER_history];
        
        if(!cell) {
            cell = [RAHistoryCell cellLoadedFromNibNamed:LISTVIEW_CELL_IDENTIFIER_history reusableIdentifier:LISTVIEW_CELL_IDENTIFIER_history];
        }
        
        // Set up the new cell:
        RADatabaseController *controler = [RADatabaseController sharedUser];
        //Get the bookmark at the index from the selected row
        RAItemObject *bookmark = (RAItemObject *)[controler.bookmarks objectAtIndex:row]; 
        
        [[cell titleLabel] setStringValue:[bookmark title]];
        [[cell url]setStringValue:[bookmark url]];
        NSString *strDate = [formater stringFromDate:[bookmark date]];
        [[cell date]setStringValue:strDate];
        [[cell favicon]setImage:[bookmark favico]];
        
        return cell;

    }
    

}

- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row
{
	return 50;
}

/*
- (void)listViewSelectionDidChange:(NSNotification*)aNotification
{
    NSInteger row = [listView selectedRow]; 
    DatabaseController *controller = [DatabaseController sharedUser];
    bookmarkObject *history = (bookmarkObject *)[controller.history objectAtIndex:row];
    //send the url to the class instancied webview
    [newtab initWithUrl:history.url];
}
 */

- (void)listViewSelectionDidChange:(NSNotification*)aNotification
{
    NSInteger row = [listView selectedRow]; 
    NSString *URL = [[newtab webview]mainFrameURL];
    RADatabaseController *controller = [RADatabaseController sharedUser];  
    RAItemObject *bookmark = (RAItemObject *)[controller.bookmarks objectAtIndex:row];
    if (![URL isEqualToString:bookmark.url])
    {
        [newtab initWithUrl:bookmark.url];
 
    }
    
    [readButton setState:0];
    [self noCustomCSS];
    [parsingRead stopAnimation:self];
    [[readButton animator]setAlphaValue:1.0];

    
}

-(void)readabilityButton:(id)sender
{
    if ([readButton state] == 1) {
        [parsingRead startAnimation:nil];
        [[readButton animator]setAlphaValue:0.0];
        GGReadability *read = [[GGReadability alloc]initWithURL:[NSURL URLWithString:[[newtab webview]mainFrameURL]] delegate:self]; 
        [read render];
        [read release]; 
    }
    else
    {
        [self noCustomCSS];
        NSInteger row = [listView selectedRow]; 
        RADatabaseController *controller = [RADatabaseController sharedUser];  
        RAItemObject *bookmark = (RAItemObject *)[controller.bookmarks objectAtIndex:row];
        [newtab initWithUrl:bookmark.url];
        
    }
}

-(void)applyCustomCSS
{
    WebPreferences *preference = [[WebPreferences alloc]initWithIdentifier:@"tempWeb"];
    [preference setUserStyleSheetLocation:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"typography"
                                                                                                 ofType:@"css"]]];
    [preference setUserStyleSheetEnabled:YES]; 
    [[newtab webview]setPreferences:preference];
    [preference release]; 
}

-(void)noCustomCSS
{
    WebPreferences *preference = [[WebPreferences alloc]initWithIdentifier:@"tempWeb"];
    [preference setUserStyleSheetEnabled:NO]; 
    [[newtab webview]setPreferences:preference];
    [preference release]; 
}

-(void)readability:(GGReadability *)readability didReceiveContents:(NSString *)contents
{
    if ([contents isEqualToString:@""]) {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setInformativeText:@"Please try on another page"]; 
        [alert setMessageText:@"The page can not be parsed"]; 
        [alert beginSheetModalForWindow:[readButton window] modalDelegate:self didEndSelector:nil contextInfo:nil];
        [alert release]; 
        [readButton setState:0];
    }
    else
    {
        [self applyCustomCSS];
        [[[newtab webview]mainFrame]loadHTMLString:contents baseURL:nil];  
    }
    [parsingRead stopAnimation:self];
    [[readButton animator]setAlphaValue:1.0];


    
    
}

-(void)readability:(GGReadability *)readability didReceiveError:(NSError *)error
{
    [readButton setState:0];
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setInformativeText:@"Please try on another page"]; 
    [alert setMessageText:@"The page can not be parsed"]; 
    [alert beginSheetModalForWindow:[readButton window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    [alert release]; 
    
}
-(void)listView:(PXListView *)aListView rowDoubleClicked:(NSUInteger)rowIndex
{
    /*
    MainWindowController *mainController = [[listView window]windowController];
    NSInteger row = rowIndex; 
    DatabaseController *controller = [DatabaseController sharedUser];  
    bookmarkObject *bookmark = (bookmarkObject *)[controller.bookmarks objectAtIndex:row];
    mainController.navigatorview.PassedUrl = bookmark.url;
    [mainController.navigatorview addtabs:nil];
    [mainController home:nil]; 
     */
    RADatabaseController *controller = [RADatabaseController sharedUser];
    RAItemObject *bookmark = (RAItemObject *)[controller.bookmarks objectAtIndex:rowIndex]; 
    RAFavoritePanelWController *favoritePanel = [[RAFavoritePanelWController alloc]init];
    selectedDefaultRow = rowIndex; 
    [favoritePanel setTempURL:bookmark.url]; 
    [favoritePanel setTempTitle:bookmark.title]; 
    [favoritePanel setTempFavico:bookmark.favico]; 
    [favoritePanel setIndex:bookmark.udid];
    [favoritePanel setType:bookmark.type];
    [favoritePanel setState:2];
    [NSApp beginSheet:[favoritePanel window] modalForWindow:[listView window] modalDelegate:self didEndSelector:@selector(reselectRow:) contextInfo:nil];
}

-(IBAction)addFavorite:(id)sender;
{
    RAFavoritePanelWController *favoritePanel = [[RAFavoritePanelWController alloc]init];
    [favoritePanel setTempURL:@""]; 
    [favoritePanel setTempTitle:@""]; 
    [favoritePanel setTempFavico:[NSImage imageNamed:@"MediumSiteIcon.png"]]; 
    [favoritePanel setState:1];
    [favoritePanel setType:0];
    [NSApp beginSheet:[favoritePanel window] modalForWindow:[listView window] modalDelegate:self didEndSelector:@selector(check:) contextInfo:nil];
}


- (IBAction)DeleteSelectedRow:(id)sender
{    
    NSInteger row = [listView selectedRow]; 
    NSAlert *alert = [[NSAlert alloc] init];
    RADatabaseController *controller = [RADatabaseController sharedUser];
    if (row > controller.bookmarks.count) {
        [alert setMessageText:NSLocalizedString(@"Please select a bookmark", @"bookmarkPromptError")];
        [alert setInformativeText:NSLocalizedString(@"To view, delete or edit an item you first need to select an item in the list.", @"BookmarkPromptErrorMessage")];
        [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Ok")];
        [alert beginSheetModalForWindow:[sender window] modalDelegate:self didEndSelector:nil contextInfo:nil];
        [alert release];
    }
    else
    {
        NSString *exampleAlertSuppress = @"BookmarkAlertSupress";
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
            NSString *exampleAlertSuppress = @"BookmarkAlertSupress";
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
    RADatabaseController *controller = [RADatabaseController sharedUser];
    RAItemObject *bookmark = (RAItemObject *)[controller.bookmarks objectAtIndex:row]; 
    [controller deletefromDatabase:bookmark.udid];
    [self check:nil];
    [titleField setStringValue:@""]; 
    [urlField setStringValue:@""]; 
    [favicon setImage:nil]; 
    row =  row -1;
    if (count !=0)
    {
    if (row >= 0) {
        [listView setSelectedRow:row];
    }
    else
    {
        row = row + 1;
        [listView setSelectedRow:row];
    }
    }

}

-(void)reselectRow:(id)sender
{
    NSInteger row = [listView selectedRow]; 
    [self check:nil];
    if (row >= 0) {
        [listView setSelectedRow:row];
    }
}


- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    WebView *tempview = [[WebView alloc]init]; 
    [tempview setFrameLoadDelegate:self]; 
    [[tempview mainFrame]loadRequest:request]; 
    return tempview; 
}

//Little hack to intercept URL, the webview start provisiosing with the previous request. Only way to catch the URL
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]){
        if ([[sender mainFrameURL]isEqualToString:@""]) {
        }
        else
        {
            RAMainWindowController *controller = [[[newtab webview] window]windowController];
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
    RAMainWindowController *controller = [[webView window]windowController];
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
