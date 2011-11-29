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

#import "RANavigatorViewController.h"
#import "RavenAppDelegate.h"
#import <math.h>


//the size of a tab button
#define tabButtonSize 190
#define toolbarSize 26
#define tabHeight 22
@implementation RANavigatorViewController

@synthesize PassedUrl, tabsArray, fromOtherViews; 

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
    tabsArray = [[NSMutableArray alloc]init];
    //Value for the tabs button position and tag (y)
    
    istab = NO; 
    fromOtherViews = 2; 
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
    RAWebViewController *selectedTab = [tabsArray objectAtIndex:
                                        [tabController indexOfTabViewItem:
                                         [tabController selectedTabViewItem]]];
    [selectedTab setMenu];
}



#pragma mark -
#pragma mark tab management

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
    [self setImageOnSelectedTab];
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
    [self setImageOnSelectedTab];
    [self setMenu];
}

//redraw the tabs when one is added or deleted
//If it is from window does not animate it so on window resize it resize tabs instantantly
-(void)redrawTabs:(BOOL)fromWindow
{
    if (localWindow == nil) {
        localWindow = [NSApp keyWindow];
    }
    //If only 1 or 0 tabs then hide the webview tabbar, only do it when it does not come from window resize notification
    if ([tabsArray count] <= 1 && !fromWindow) {
        for (RAWebViewController *aTab in tabsArray) {
            [allTabsButton setHidden:YES];
            [[aTab tabHolder]setHidden:YES];
            [[aTab tabview]setHidden:YES]; 
            [[aTab webview]setFrame:NSMakeRect(aTab.webview.frame.origin.x, aTab.webview.frame.origin.y, aTab.webview.frame.size.width, aTab.webview.frame.size.height+tabHeight)];
        }
        
    }
    //show the tabbar and draw tabs
    else
    {
        CGFloat x = 0;
        float rest = 0; 
        for (int i =0; i<[tabsArray count]; i++) {
            RAWebViewController *aTab = [tabsArray objectAtIndex:i];
            [[aTab tabHolder]setHidden:NO];
            [allTabsButton setHidden:NO];
            //Calculate W according to the window width
            CGFloat w = (localWindow.frame.size.width-80)/[tabsArray count];
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
                    x = x + (localWindow.frame.size.width - 77)/[tabsArray count];
                    rest = fmodf((localWindow.frame.size.width - 77), [tabsArray count])/[tabsArray count];
                }
            }
            if (i == 0) {
                if ([[aTab tabview]isHidden] == YES && !fromWindow) {
                    [[aTab webview]setFrame:NSMakeRect(aTab.webview.frame.origin.x, aTab.webview.frame.origin.y, aTab.webview.frame.size.width, aTab.webview.frame.size.height - tabHeight)];
                }
            }
            //If it is not from window notification animate
            if (!fromWindow) {
                [[aTab tabview]setHidden:NO]; 
                [[aTab tabview]setAlphaValue:1.0]; 
                [NSAnimationContext beginGrouping];
                [[NSAnimationContext currentContext] setDuration:0.2];  
                [[[aTab tabview]animator]setFrame:NSMakeRect(x + rest, 0, w, tabHeight)];
                [NSAnimationContext endGrouping];
                [[aTab progressTab]setHidden:NO];
            }
            //just redraw without animation if from window
            else{
                [[aTab tabview]setFrame:NSMakeRect(x + rest, 0, w, tabHeight)];   
            }
        }
    }
    localWindow = nil; 
    
}

-(void)addtabs:(id)sender
{
    localWindow = [sender window];
    if (localWindow == nil) {
        localWindow = [NSApp keyWindow];
    }
    //Instanciate a new webviewcontroller and the button tab view with the view
    RAWebViewController *newtab = [[RAWebViewController alloc]initWithDelegate:self];
    //Add the button and webview instance in array.
    [tabsArray addObject:newtab]; 
    //force the newtab view to call awakefromNib
    [newtab view];
    
    //set the new webview delegate to this class method
    [[newtab webview]setUIDelegate:self]; 
    [[newtab webview]setPolicyDelegate:self]; 
    //Set the host window to the actual window for plugin 
    [[newtab webview]setHostWindow:localWindow];
        
    [tabPlaceHolder addSubview:[newtab tabview]];
    [[newtab tabview]setFrame:NSMakeRect([tabsArray indexOfObject:newtab]*tabButtonSize, tabHeight, tabButtonSize, tabHeight)];
    [[newtab address]selectText:self];
    
    //if the passed URL value is different of nil then load it in the webview 
    if (PassedUrl != nil) {
        [newtab setIsNewTab:NO]; 
        [newtab loadWithUrl:PassedUrl]; 

    }
    //if null then inti the webview with tthe welcom page
    else
    {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults) {
            if ([standardUserDefaults integerForKey:DO_HAVE_LAUNCHED] == 0) {
                [standardUserDefaults setInteger:1 forKey:DO_HAVE_LAUNCHED];
                [standardUserDefaults synchronize];
                [newtab loadWithFirstTimeLaunchPage];
            }
                else
                {
                    [newtab loadWithPreferredUrl]; 
                }
            }
        }
    //[buttonview release]; 
    NSTabViewItem *item = [[NSTabViewItem alloc]init]; 
    [item setView:[newtab switchView]];
    [tabController addTabViewItem:item];
    
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults]; 
    if (standardUserDefault) {
        if (([standardUserDefault integerForKey:OPEN_TAB_IN_BACKGROUND] == 0 
            && !inBackground)
            || [sender class] == [NSButton class]) {
                //reset all tabs button position
                [self resetAllTabsButon]; 
                [tabController selectTabViewItem:item]; 
                [newtab setMenu]; 
                if (newtab != nil)
                {
                    [newtab setWindowTitle:sender];
                }
        }
        else{
            inBackground = NO;
        }
    }
    
    [self resetAllTabsButon];
    [self setImageOnSelectedTab];
    [item release]; 
    [newtab release]; 
    [self redrawTabs:NO];
    PassedUrl = nil; 
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_TAB_NUMBER object:nil];
    
}



-(void)closeSelectedTab:(id)sender
{
    RAWebViewController *close = [tabsArray objectAtIndex:
                                  [tabController indexOfTabViewItem:
                                   [tabController selectedTabViewItem]]];
    [close closeButtonTabClicked:close];
}

-(void)closeFirtTab
{
    RAWebViewController *close = [tabsArray objectAtIndex:0]; 
    [close closeButtonTabClicked:close]; 
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
    for (int i=0;i<[tabsArray count];i++)
    {
        RAWebViewController *button =  [tabsArray objectAtIndex:i];
        //Create a menu and set the different items of the menu
        NSMenuItem *item = [[NSMenuItem alloc]init];
        NSString *tempTitle = [button.pageTitleTab stringValue];
        tempTitle = [tempTitle stringByPaddingToLength:35 withString:@" " startingAtIndex:0];
        [item setTitle:tempTitle]; 
        [[button.faviconTab image]setSize:NSMakeSize(16, 16)];
        [item setImage:[button.faviconTab image]];
        [item setAction:@selector(tabsButtonClicked:)];
        [item setEnabled:YES];
        [item setTarget:button];
        [menu addItem:item];
        [item release]; 
    }
    
    return [menu autorelease];
    
}


//Reset all tabs button state
-(void)resetAllTabsButon
{
    for (RAWebViewController *tpsbutton in tabsArray) {
        [[tpsbutton boxTab]setFillColor:[NSColor scrollBarColor]];
        [[tpsbutton boxTab]setBorderWidth:1.0]; 
        [[tpsbutton boxTab]setBorderColor:[NSColor darkGrayColor]];
    }

}
-(void)setImageOnSelectedTab
{
    RAWebViewController *clickedtab = [tabsArray objectAtIndex:
                                       [tabController indexOfTabViewItem:
                                        [tabController selectedTabViewItem]]];
    [[clickedtab boxTab]setBorderWidth:0.0]; 
    [[clickedtab boxTab]setBorderColor:[NSColor blackColor]];
    [[clickedtab boxTab]setFillColor:[NSColor windowBackgroundColor]];
}



//close all tabs
-(void)closeAllTabs:(id)sender
{
    int i = 0;
    for (RAWebViewController *clickedtab in tabsArray) {
        [clickedtab view];
        [clickedtab setDelegate:nil];
        [[clickedtab webview]setHostWindow:nil];
        [[clickedtab webview]setUIDelegate:nil]; 
        [[clickedtab webview]setPolicyDelegate:nil];
        [[clickedtab webview]stopLoading:[clickedtab webview]];
        [[[clickedtab view]animator]setAlphaValue:0.0]; 
        [[clickedtab view]removeFromSuperview];
        [[[clickedtab tabview]animator]setAlphaValue:0.0]; 
        [[clickedtab tabview]removeFromSuperview];
        [[clickedtab webview]removeFromSuperview];
        [tabController removeTabViewItem:[tabController tabViewItemAtIndex:i]]; 
    }
    [tabsArray removeAllObjects];
    [self redrawTabs:NO];
    @synchronized(self){
        [self addtabs:tabsButton]; 
    }
}

-(void)openTabInBackgroundWithUrl:(id)sender
{
    PassedUrl = [[sender representedObject]absoluteString];
    inBackground = YES;
    [self addtabs:tabsButton];
}

#pragma mark -
#pragma mark RATabViewDelegate

-(void)didReceiveDoubleClick:(RATabPlaceholderView *)view
{
    [self addtabs:nil];
}

#pragma mark -
#pragma mark RAWebviewControllerDelegate

-(void)tabDidSelect:(RAWebViewController *)RAWebView{
    NSInteger tag = [tabsArray indexOfObject:RAWebView];
    [tabController selectTabViewItemAtIndex:tag]; 
    RAWebViewController *clickedtab = [tabsArray objectAtIndex:tag];
    [clickedtab setMenu]; 
    [clickedtab setWindowTitle:allTabsButton];
    
    [self resetAllTabsButon]; 
    [self setImageOnSelectedTab]; 
}

//do all the memory clean up stuff here, it might be better to switch it within the RAWebview itself
-(void)tabWillClose:(RAWebViewController *)RAWebView{
    NSInteger tag = [tabsArray indexOfObject:RAWebView];
    //The current webview remove
    RAWebViewController *clickedtab = [tabsArray objectAtIndex:tag];
    [clickedtab view];
    [clickedtab setDelegate:nil];
    [[clickedtab webview]setHostWindow:nil];
    [[clickedtab webview]setUIDelegate:nil]; 
    [[clickedtab webview]setPolicyDelegate:nil];
    [[clickedtab webview]stopLoading:[clickedtab webview]];
    [[[clickedtab view]animator]setAlphaValue:0.0]; 
    [[clickedtab view]removeFromSuperview];
    [[[clickedtab tabview]animator]setAlphaValue:0.0]; 
    [[clickedtab tabview]removeFromSuperview];
    [[clickedtab webview]removeFromSuperview];
    if (tag == 0 && tag == [tabController indexOfTabViewItem:
                            [tabController selectedTabViewItem]]) {
        if ([tabsArray count] == 1) {
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
    [tabsArray removeObjectAtIndex:tag];
    [self resetAllTabsButon];
    [self redrawTabs:NO];
    [self setImageOnSelectedTab];
    [self setMenu];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_TAB_NUMBER object:nil];
}

-(void)shouldCreateNewTab:(RAWebViewController *)RAWebView
{
    [self addtabs:[RAWebView tabsButton]];
}

#pragma mark -
#pragma mark webview Delegate

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{   
    if ([element objectForKey:WebElementLinkURLKey] != nil) {
        NSMutableArray *newItem = [[defaultMenuItems mutableCopy]autorelease];
        NSMenuItem *item = [defaultMenuItems objectAtIndex:1]; 
        [item setTitle:@"Open in a new tab"];
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
    if (modifierFlags & NSCommandKeyMask && [[NSApp currentEvent] type] == NSLeftMouseDownMask)  {
        if ([elementInformation objectForKey:@"WebElementLinkURL"] 
            && [elementInformation objectForKey:@"WebElementTargetFrame"]) {
            RAWebViewController *tempController = [tabsArray objectAtIndex:
                                                   [tabController indexOfTabViewItem:
                                                    [tabController selectedTabViewItem]]];
            [tempController.webview stopLoading:tempController.webview];
            [tempController webView:tempController.webview didFinishLoadForFrame:[tempController.webview mainFrame]];
            NSMenuItem *tempItem = [[NSMenuItem alloc]init];
            [tempItem setRepresentedObject:[elementInformation objectForKey:@"WebElementLinkURL"]]; 
            [self openTabInBackgroundWithUrl:tempItem]; 
            [tempItem release]; 
        }
    }
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    if ([type hasPrefix:@"application"]) {
        RANSURLDownloadDelegate *dlDelegate = [[RANSURLDownloadDelegate alloc]init];
        NSURLDownload  *theDownload = [[NSURLDownload alloc] initWithRequest:request
                                                                delegate:dlDelegate];
        [theDownload release]; 
        [dlDelegate release]; 
        if (![type isEqualToString:@"application/pdf"]) {
            [webView stopLoading:webView];
            for (RAWebViewController *tempController in tabsArray) {
                if (tempController.webview == webView) {
                    [tempController webView:tempController.webview didFinishLoadForFrame:
                     [tempController.webview mainFrame]];
                }
            }
        }
    }
    else{
        [listener use];
    }
}
//create a new tab with the clicked URL
//it create a temp webview, totally useless but necessary because webview API are broken in this part
- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    WebView *tempview = [[WebView alloc]init]; 
    [tempview setFrameLoadDelegate:self]; 
    [[tempview mainFrame]loadRequest:request]; 
    return tempview; 
}

- (WebView *)webView:(WebView *)sender createWebViewModalDialogWithRequest:(NSURLRequest *)request
{
    WebView *tempview = [[WebView alloc]init]; 
    [tempview setFrameLoadDelegate:self]; 
    [[tempview mainFrame]loadRequest:request]; 
    NSLog(@"test");
    return tempview; 
}

//Little hack to intercept URL, the webview start provisiosing with the previous request. Only way to catch the URL
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]){
        if (![[sender mainFrameURL]isEqualToString:@""]) {
            PassedUrl = [sender mainFrameURL]; 
            [self addtabs:tabsButton];
            [sender stopLoading:sender]; 
        }
    }
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

//Bad memory maanagement for now ! 
- (void)dealloc
{   
    for (RAWebViewController *newtab in tabsArray) {
        [[newtab webview]setUIDelegate:nil]; 
        [newtab setDelegate:nil];
        [[newtab webview]setPolicyDelegate:nil];
        [[newtab webview]removeFromSuperview];
    } 
    [tabsArray removeAllObjects];
    [tabsArray release], tabsArray = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc];
}
@end