//
//  NavigatorViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//*****BEFORE YOU READ*****
//THIS CLASS IS FAT, IT IS A MESS, YOU DON'T WANT TO READ IT, YOU SHOULD REWRITE IT NOW
//*****YOU CAN START READING THE CODE IF YOU WANT*****
//Ah also, it is full of ninja comment.... really

//This Class also Root new window and tab request from webview. It act as a WebUIDelegate

#import "RANavigatorViewController.h"
#import "RavenAppDelegate.h"
#import <math.h>


//the size of a tab button
#define tabButtonSize 190
#define toolbarSize 26
#define tabHeight 22
@implementation RANavigatorViewController

@synthesize PassedUrl = _PassedUrl, tabsArray = _tabsArray, fromOtherViews = _fromOtherViews, baseUrl = _baseURL;
@dynamic cmdKeyPressed; 

#pragma -
#pragma mark init

-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"Navigator" bundle:nil]; 
    }
    
    return self; 
}


//WAKE UP DRING DRING 
-(void)awakeFromNib
{ 
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
    [nc addObserver:self selector:@selector(windowResize:) name:NSWindowDidResizeNotification object:nil]; 
    //Initialize the array which contain tabs
    _tabsArray = [[NSMutableArray alloc]init];
    _popupWindowArray = [[NSMutableArray alloc]init]; 
    //Value for the tabs button position and tag (y)
    
    istab = NO; 
    _fromOtherViews = 2; 
    [allTabsButton setHidden:YES]; 
    [allTabsButton setAction:@selector(menutabs:)]; 
    [allTabsButton setTarget:self];
    inBackground = NO;
    isAdressBarHidden = NO;
    [tabPlaceHolder setDelegate:self];
}



-(void)windowResize:(id)sender
{
    if ([sender object] == [tabController window]){
        [self redrawTabs:YES];
    }
}

-(void)setMenu{
    NSMenu *topMenu = [NSApp mainMenu]; 
    [topMenu setSubmenu:navigatorMenu forItem:[topMenu itemAtIndex:8]];
    RATabItem *selectedTab = [_tabsArray objectAtIndex:
                                        [tabController indexOfTabViewItem:
                                         [tabController selectedTabViewItem]]];
    [selectedTab.webViewController setMenu];
}

#pragma mark - Utility 
-(BOOL)firstTimeLaunch
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults integerForKey:DO_HAVE_LAUNCHED] == 0) {
        [standardUserDefaults setInteger:1 forKey:DO_HAVE_LAUNCHED];
        [standardUserDefaults synchronize];
        return YES; 
    }
    else{
        return NO; 
    }
}

-(BOOL)shouldOpenBaseUrl
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return (self.baseUrl && [standardUserDefaults integerForKey:OPEN_NEW_TAB_BASE_URL] == 1);
}

-(BOOL)shouldOpenInBackground:(id)sender
{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults]; 
    return (([standardUserDefault integerForKey:OPEN_TAB_IN_BACKGROUND] == 0  
             && !inBackground) 
            || [sender class] == [NSButton class]);

}


-(BOOL)isCmdKeyPressed
{
    return (([[NSApp currentEvent]modifierFlags] & NSCommandKeyMask) == NSCommandKeyMask);
}

-(BOOL)isRATabItem:(id)sender
{
    return [sender isKindOfClass:[RATabItem class]]; 
}

-(BOOL)shouldOpenPopupInTab
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults integerForKey:OPEN_POPUP_IN_TAB];
}
#pragma mark -
#pragma mark Tab UI

//redraw the tabs when one is added or deleted
//If it is from window does not animate it so on window resize it resize tabs instantantly
-(void)redrawTabs:(BOOL)fromWindow
{
    if (localWindow == nil) {
        localWindow = [NSApp keyWindow];
    }
    //If only 1 or 0 tabs then hide the webview tabbar, only do it when it does not come from window resize notification
    if ([_tabsArray count] <= 1 && !fromWindow) {
        [self hideTabHolder];    
    }
    //show the tabbar and draw tabs
    else if ([_tabsArray count] > 1){
        [tabPlaceHolder setHidden:NO];
        CGFloat x = 0;
        float rest = 0; 
        for (int i =0; i<[_tabsArray count]; i++) {
            RATabItem *aTab = [_tabsArray objectAtIndex:i];
            [[aTab.tabView tabHolder]setHidden:NO];
            [allTabsButton setHidden:NO];
            //Calculate W according to the window width
            CGFloat w = (localWindow.frame.size.width-80)/[_tabsArray count];
            if (w > tabButtonSize){
                w=tabButtonSize;
                if (i==0){
                    //X represent the tab x position, if it is the first tab then position is first at 0
                    x=0;
                }
                else{
                    //then x is incremented at each pass for the next tab to be next the previous one
                    x = x + tabButtonSize;   
                }
            }
            else {
                if (i==0){
                    x=0;
                }
                else{
                    //recalcuate x regarding the window size for the placement when window size is modified
                    x = x + (localWindow.frame.size.width - 77)/[_tabsArray count];
                    rest = fmodf((localWindow.frame.size.width - 77), [_tabsArray count])/[_tabsArray count];
                }
            }
            if (i == 0) {
                if ([[aTab.tabView view]isHidden] == YES && !fromWindow) {
                    [aTab.webViewController.webview setFrame:NSMakeRect(aTab.webViewController.webview.frame.origin.x, 
                                                                        aTab.webViewController.webview.frame.origin.y, 
                                                                        aTab.webViewController.webview.frame.size.width, 
                                                                        aTab.webViewController.webview.frame.size.height - tabHeight)];
                }
            }
            //If it is not from window notification animate
            if (!fromWindow) {
                [[aTab.tabView view]setHidden:NO]; 
                [[aTab.tabView view]setAlphaValue:1.0]; 
                [NSAnimationContext beginGrouping];
                [[NSAnimationContext currentContext] setDuration:0.2];  
                [[[aTab.tabView view]animator]setFrame:NSMakeRect(x + rest, 0, w, tabHeight)];
                [NSAnimationContext endGrouping];
                [[aTab.tabView progressTab]setHidden:NO];
            }
            //just redraw without animation if from window
            else{
                [[aTab.tabView view]setFrame:NSMakeRect(x + rest, 0, w, tabHeight)];   
            }
        }
    }
    localWindow = nil; 
    
}

-(void)hideTabHolder
{
    [tabPlaceHolder setHidden:YES];
    [allTabsButton setHidden:YES];
    for (RATabItem *aTab in _tabsArray) {
        [[aTab.tabView tabHolder]setHidden:YES];
        [[aTab.tabView view]setHidden:YES]; 
        [[aTab.webViewController webview]setFrame:NSMakeRect(aTab.webViewController.webview.frame.origin.x, 
                                                             aTab.webViewController.webview.frame.origin.y, 
                                                             aTab.webViewController.webview.frame.size.width, 
                                                             aTab.webViewController.webview.frame.size.height+tabHeight)];
    }
    
}


#pragma mark -
#pragma mark tab method
//Called once a tab button is clicked
-(void)previousTab:(id)sender
{
    [self resetAllTabsButon]; 
    if ([tabController indexOfTabViewItem:[tabController selectedTabViewItem]] == 0){
        [tabController selectLastTabViewItem:self];
    }
    else{
        [tabController selectPreviousTabViewItem:self]; 
    }
    [self setTabSelectedState];
    [self setMenu];
}
-(void)nextTab:(id)sender
{
    [self resetAllTabsButon];
    if ([tabController indexOfTabViewItem:[tabController selectedTabViewItem]] == [tabController numberOfTabViewItems] -1) {
        [tabController selectFirstTabViewItem:self];
    }
    else{
        [tabController selectNextTabViewItem:self];
    }
    [self setTabSelectedState];
    [self setMenu];
}

-(void)addtabs:(id)sender
{
    localWindow = [NSApp keyWindow]; 
    RATabItem *newtab = nil;
    if ([self isRATabItem:sender]) {
        newtab = [_tabsArray lastObject]; 
    }
    else{
        newtab = [[RATabItem alloc]init];
        [_tabsArray addObject:newtab]; 
    }
    
    [newtab setDelegate:self]; 
    [newtab callView];
    
    //Set the host window to the actual window for plugins support
    [[newtab.webViewController webview]setHostWindow:localWindow];
    [newtab setWebViewDelegate:self]; 
    [tabPlaceHolder addSubview:[newtab.tabView view]];
    
    [[newtab.tabView view]setFrame:NSMakeRect([_tabsArray indexOfObject:newtab]*tabButtonSize, tabHeight, tabButtonSize, tabHeight)];
    
    [[newtab.webViewController address]selectText:self];
    
    //if the passed URL value is different of nil then load it in the webview 
    if (self.PassedUrl != nil) {
        [newtab.webViewController setNewTab:NO]; 
        [newtab.webViewController loadWithUrl:self.PassedUrl]; 
    }
    else if ([self isRATabItem:sender]) {
        
    }
    //if null then inti the webview with tthe welcome page
    else
    {
        if ([self firstTimeLaunch]) {
            [newtab.webViewController loadInternalPage:@"Start"];
        }
        else
        {
            if ([self shouldOpenBaseUrl]) {
                [newtab.webViewController loadWithUrl:self.baseUrl];  
            }
            else{
                [newtab.webViewController loadWithPreferredUrl]; 
            }
        }
    }
    //[buttonview release]; 
    NSTabViewItem *item = [[NSTabViewItem alloc]init]; 
    [item setView:[newtab.webViewController switchView]];
    [tabController addTabViewItem:item];
    
    if ([self shouldOpenInBackground:sender]) {
        //reset all tabs button position
        [self resetAllTabsButon]; 
        [tabController selectTabViewItem:item]; 
        [newtab.webViewController setMenu]; 
    }
    else{
        inBackground = NO;
    }
    
    [self resetAllTabsButon];
    [self setTabSelectedState];
    [item release]; 
    if (![self isRATabItem:sender]){
        [newtab release]; 
    }
    [self redrawTabs:NO];
    self.PassedUrl = nil; 
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_TAB_NUMBER object:nil];
    
}



-(void)closeSelectedTab:(id)sender
{
    RATabItem *close = [_tabsArray objectAtIndex:
                                  [tabController indexOfTabViewItem:
                                   [tabController selectedTabViewItem]]];
    [close.tabView closeButtonTabClicked:close];
}

-(void)closeFirtTab
{
    RATabItem *close = [_tabsArray objectAtIndex:0]; 
    [close.tabView closeButtonTabClicked:close]; 
}


//THe action when the tab menu button is clicked
-(void)menutabs:(id)sender
{
    NSMenu *menu = [self getTabsMenu];
    
    //Draw the menu on a frame 
    NSRect frame = [(NSButton *)sender frame];
    NSPoint menuOrigin = [[(NSButton *)sender superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y+frame.size.height-25)
                                                               toView:nil];
    
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:menuOrigin
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:0
                                     windowNumber:[[(NSButton *)sender window] windowNumber]
                                          context:[[(NSButton *)sender window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1]; 
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:(NSButton *)sender];

}

-(NSMenu *)getTabsMenu
{
    NSMenu *menu = [[NSMenu alloc]init]; 
    for (int i=0;i<[_tabsArray count];i++)
    {
        RATabItem *button =  [_tabsArray objectAtIndex:i];
        //Create a menu and set the different items of the menu
        NSMenuItem *item = [[NSMenuItem alloc]init];
        NSString *tempTitle = [button.tabView.pageTitleTab stringValue];
        tempTitle = [tempTitle stringByPaddingToLength:35 withString:@" " startingAtIndex:0];
        [item setTitle:tempTitle]; 
        [[button.tabView.faviconTab image]setSize:NSMakeSize(16, 16)];
        [item setImage:[button.tabView.faviconTab image]];
        [item setAction:@selector(tabsButtonClicked:)];
        [item setEnabled:YES];
        [item setTarget:button.tabView];
        [menu addItem:item];
        [item release]; 
    }
    
    return [menu autorelease];
    
}


//Reset all tabs button state
-(void)resetAllTabsButon
{
    for (RATabItem *tpsbutton in _tabsArray) {
        [tpsbutton.tabView setNormalState]; 
    }

}
-(void)setTabSelectedState
{
    RATabItem *clickedtab = [_tabsArray objectAtIndex:
                                       [tabController indexOfTabViewItem:
                                        [tabController selectedTabViewItem]]];
    [clickedtab.tabView setSelectedState]; 
}



//close all tabs
-(void)closeAllTabs:(id)sender
{
    int i = 0;
    for (RATabItem *clickedtab in _tabsArray) {
        [clickedtab prepareTabClose]; 
        [tabController removeTabViewItem:[tabController tabViewItemAtIndex:i]]; 
    }
    [_tabsArray removeAllObjects];
    [self redrawTabs:NO];
    @synchronized(self){
        [self addtabs:tabsButton]; 
    }
}

-(void)openTabInBackgroundWithUrl:(id)sender
{
    if ([sender isKindOfClass:[NSMenuItem class]]) {
        self.PassedUrl = [[sender representedObject]absoluteString];
    }
    else if([sender isKindOfClass:[NSString class]]) {
        self.PassedUrl = sender; 
    }
    inBackground = YES; 
    [self addtabs:tabsButton]; 
}

-(void)openNewTab:(id)sender
{
    self.PassedUrl = [[sender representedObject]absoluteString];
    inBackground = NO;
    [self addtabs:tabsButton]; 
}

#pragma mark -
#pragma mark RATabPlaceholderDelegate

-(void)didReceiveDoubleClick:(RATabPlaceholderView *)view
{
    [self addtabs:nil];
}

#pragma mark - Handle tab swape

-(void)tabItemDidStartDragging:(RATabItem *)tab
{
    [self.view.window.contentView addSubview:tab.tabView.view]; 
}

-(void)tabItemDidMoveLeft:(RATabItem *)tab
{
    if ([_tabsArray indexOfObject:tab] > 0) {
        [self moveIndexOfTabControllerFromIndex:[_tabsArray indexOfObject:tab] 
                                        toIndex:[_tabsArray indexOfObject:tab]-1]; 
        [_tabsArray moveObjectFromIndex:[_tabsArray indexOfObject:tab] 
                                toIndex:[_tabsArray indexOfObject:tab]-1];
        [tab.tabView tabsButtonClicked:tab.webViewController.tabsButton]; 
        [self redrawTabs:YES]; 

    }
}

-(void)tabItemDidMoveRight:(RATabItem *)tab
{
    if ([_tabsArray indexOfObject:tab] < [_tabsArray count] - 1) {
        [self moveIndexOfTabControllerFromIndex:[_tabsArray indexOfObject:tab] 
                                        toIndex:[_tabsArray indexOfObject:tab]+1]; 
        [_tabsArray moveObjectFromIndex:[_tabsArray indexOfObject:tab] 
                                toIndex:[_tabsArray indexOfObject:tab]+1];
        [tab.tabView tabsButtonClicked:tab.webViewController.tabsButton]; 
        [self redrawTabs:YES]; 
    }
}

-(void)moveIndexOfTabControllerFromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    NSTabViewItem *tabItem = [tabController tabViewItemAtIndex:from];
    [tabController removeTabViewItem:tabItem]; 
    [tabController insertTabViewItem:tabItem atIndex:to]; 
}

-(void)tabItemDidStopDragging:(RATabItem *)tab
{
    [self redrawTabs:YES];
    [tabPlaceHolder addSubview:tab.tabView.view]; 
}


#pragma mark - RAPopupWindowDelegate

-(void)onCloseButton:(RAPopupWindowController *)windowController
{
    [_popupWindowArray removeObject:windowController]; 
}

#pragma mark -
#pragma mark RATabItelDelegate

-(void)tabItemDidSelect:(RATabItem *)tab{
    NSInteger tag = [_tabsArray indexOfObject:tab];
    [tabController selectTabViewItemAtIndex:tag]; 
    RATabItem *clickedtab = [_tabsArray objectAtIndex:tag];
    [clickedtab.webViewController setMenu]; 
    [clickedtab.webViewController setWindowTitle:allTabsButton];
    
    [self resetAllTabsButon]; 
    [self setTabSelectedState]; 
}

-(void)tabItemWillClose:(RATabItem *)tab{
    NSInteger tag = [_tabsArray indexOfObject:tab];
    //The current webview remove
    RATabItem *clickedtab = [_tabsArray objectAtIndex:tag];
    [clickedtab prepareTabClose]; 
    if (tag == 0 && tag == [tabController indexOfTabViewItem:
                            [tabController selectedTabViewItem]]) {
        if ([_tabsArray count] == 1) {
            @synchronized(self){
                [self addtabs:tabsButton]; 
            }
        }
        NSInteger nb = 0;
        [tabController selectTabViewItemAtIndex:nb];
    }
    else if (tag == [tabController indexOfTabViewItem:
                     [tabController selectedTabViewItem]]) {
        NSInteger nb = tag; 
        nb = nb -1; 
        [tabController selectTabViewItemAtIndex:nb];
    }
    [tabController removeTabViewItem:[tabController tabViewItemAtIndex:tag]]; 
    [_tabsArray removeObjectAtIndex:tag];
    [self resetAllTabsButon];
    [self redrawTabs:NO];
    [self setTabSelectedState];
    [self setMenu];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_TAB_NUMBER object:nil];
}

-(void)tabItemRequestANewTab:(RATabItem *)tab
{
    [self addtabs:[tab.webViewController tabsButton]];
}

#pragma mark -
#pragma mark webview Delegate

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{   
    if ([element objectForKey:WebElementLinkURLKey] != nil) {
        NSMutableArray *newItem = [[defaultMenuItems mutableCopy]autorelease];
        NSMenuItem *item = [defaultMenuItems objectAtIndex:1]; 
        [item setTitle:@"Open in a new tab"];
        [item setTarget:self];
        [item setAction:@selector(openNewTab:)]; 
        [item setRepresentedObject:[element objectForKey:@"WebElementLinkURL"]]; 
        [newItem replaceObjectAtIndex:1 withObject:item]; 
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults]; 
        if (standardUserDefault) {
            if ([standardUserDefault integerForKey:@"OpenTabInBackground"] == 0){
                NSMenuItem *backGroundTab = [[NSMenuItem alloc]initWithTitle:@"Open in a new tab in background" 
                                                                      action:@selector(openTabInBackgroundWithUrl:) 
                                                               keyEquivalent:@""];
                [backGroundTab setTarget:self];
                [backGroundTab setRepresentedObject:[element objectForKey:@"WebElementLinkURL"]];
                [newItem insertObject:backGroundTab atIndex:2];
                [backGroundTab release];
            }
        }
        return newItem; 
    }
    else
    {
        return defaultMenuItems;
    }
}

- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags
{
    if (self.isCmdKeyPressed && [[NSApp currentEvent] type] == NSLeftMouseDownMask)  {
        if ([elementInformation objectForKey:@"WebElementLinkURL"] 
            && [elementInformation objectForKey:@"WebElementTargetFrame"]) {
            RATabItem *tempController = [_tabsArray objectAtIndex:
                                         [tabController indexOfTabViewItem:
                                         [tabController selectedTabViewItem]]];
            [tempController.webViewController.webview stopLoading:tempController.webViewController.webview];
            [tempController.webViewController webView:tempController.webViewController.webview didFinishLoadForFrame:[tempController.webViewController.webview mainFrame]];

            [self openTabInBackgroundWithUrl:[[elementInformation objectForKey:@"WebElementLinkURL"]absoluteString]]; 
        }
    }
}


- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    if (!self.isCmdKeyPressed) {
        self.PassedUrl = [[request URL]absoluteString]; 
        [self addtabs:tabsButton];
    }
    else{
        [self openTabInBackgroundWithUrl:[[request URL]absoluteString]]; 
    }
    [webView stopLoading:webView];
    askForNewWindow = YES;
}


- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    if ([type hasPrefix:@"application"] && 
        ![type isEqualToString:@"application/x-javascript"] &&
        ![type isEqualToString:@"application/xml"]) {
        RANSURLDownloadDelegate *dlDelegate = [[RANSURLDownloadDelegate alloc]init];
        NSURLDownload  *theDownload = [[NSURLDownload alloc] initWithRequest:request
                                                                delegate:dlDelegate];
        [theDownload release]; 
        [dlDelegate release]; 
        if (![type isEqualToString:@"application/pdf"]) {
            [webView stopLoading:webView];
            for (RATabItem *tempController in _tabsArray) {
                if (tempController.webViewController.webview == webView) {
                    [tempController.webViewController webView:tempController.webViewController.webview didFinishLoadForFrame:
                     [tempController.webViewController.webview mainFrame]];
                }
            }
        }
    }
    else{
        [listener use];
    }
}

-(void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    [listener use]; 
}


- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{    
    if ([self shouldOpenPopupInTab]) {
        RATabItem *item = [[RATabItem alloc]init]; 
        [item callView]; 
        [item.webViewController.webview.mainFrame loadRequest:request];
        [item.webViewController.webview setUIDelegate:self]; 
        [_tabsArray addObject:item]; 
        [item release]; 
        RATabItem *returnItem = [_tabsArray lastObject]; 
        return returnItem.webViewController.webview; 
    }
    else{
        WebView *tempview = [[WebView alloc]init]; 
        [tempview setUIDelegate:self];
        [[tempview mainFrame]loadRequest:request];
        return tempview; 
    }
}


- (void)webViewShow:(WebView *)sender
{
    if (!self.isCmdKeyPressed) {
        if ([self shouldOpenPopupInTab]) {
            [self addtabs:[_tabsArray lastObject]]; 
        }
        else{
            RAPopupWindowController *popupWindow = [[RAPopupWindowController alloc]initWithWindowNibName:@"RAPopupWindow"];
            [popupWindow.window makeKeyAndOrderFront:popupWindow.window];
            [popupWindow replaceWebView:sender]; 
            [popupWindow setDelegate:self]; 
            [_popupWindowArray addObject:popupWindow]; 
            if(IS_RUNNING_LION){
                [popupWindow release]; 
            } 
        }
    }
    [sender stopLoading:sender];  
    askForNewWindow = NO; 
}

-(void)webViewClose:(WebView *)sender
{
    [self closeSelectedTab:sender]; 
}

- (WebView *)webView:(WebView *)sender createWebViewModalDialogWithRequest:(NSURLRequest *)request
{
    RATabItem *item = [[RATabItem alloc]init]; 
    [item callView]; 
    [item.webViewController.webview.mainFrame loadRequest:request];
    [item.webViewController.webview setUIDelegate:self]; 
    [_tabsArray addObject:item]; 
    [item release]; 
    RATabItem *returnItem = [_tabsArray lastObject]; 
    return returnItem.webViewController.webview; 
}


//Manage javascript altert message
- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Alert"];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal]; 
    [alert release]; 
    
}

//Manage Javascript confirmation message
-(BOOL)webView:(WebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    BOOL result; 
    //prepare the alert
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Confirmation Alert"];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    
    //call the alert and check the selected button
    if ([alert runModal] == NSAlertFirstButtonReturn)
    {
        result = YES; 
    }
     else
     {
         result = NO; 
     }
    
    [alert release];

    
    return result; 
    
}

//Mange Javascript string return prompt
- (NSString *)webView:(WebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WebFrame *)frame
{
    
    //Create a view
    NSView *alterView = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, 300, 60)]; 
    //Creating the différents element for the view
    NSTextField *titleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,300,23)];
    [titleField setStringValue:defaultText]; 
    [titleField setEditable:YES];
    [titleField setDrawsBackground:NO];
    //Add created elements to the view
    [alterView addSubview:titleField]; 
    //prepare the alert
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Prompt"];
    [alert setAccessoryView:alterView];
    [alterView release]; 
    [alert setInformativeText:prompt];
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    
    //call the alert and check the selected button
    if ([alert runModal] == NSAlertFirstButtonReturn)
    {
        NSString *result = [titleField stringValue]; 
        [alert release];
        [titleField release]; 
        return result; 
        
    }
    else
    {
        [alert release];
        [titleField release]; 
        return nil;
    }
    
}

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener
{       
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:NO];
    
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [[openDlg URLs]valueForKey:@"relativePath"];
        [resultListener chooseFilenames:files];
    }
    
}

#pragma -
#pragma mark memory management

- (void)dealloc
{   
    for (RATabItem *newtab in _tabsArray) {
        [newtab prepareTabClose]; 
    } 
    [_tabsArray removeAllObjects];
    [_tabsArray release], _tabsArray = nil;
    for (RAPopupWindowController *popupWindow in _popupWindowArray) {
        [popupWindow setDelegate:nil]; 
        [popupWindow.window setDelegate:nil]; 
        [popupWindow.window close]; 
    }
    [_popupWindowArray release], _popupWindowArray = nil; 
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc];
}
@end