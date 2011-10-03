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

#import "NavigatorViewController.h"
#import "RavenAppDelegate.h"
#import "DownloadDelegate.h"

//the size of a tab button
#define tabButtonSize 110
@implementation NavigatorViewController

@synthesize PassedUrl, tabsArray, fromOtherViews; 

#pragma -
#pragma mark action



-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"Navigator" bundle:nil]; 
    }
    
    return self; 
}


//WAKE UP
-(void)awakeFromNib
{ 
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
    [nc addObserver:self selector:@selector(windowResize:) name:NSWindowDidResizeNotification object:nil]; 
    //Initialize the array which contain tabs
    tabsArray = [[NSMutableArray alloc]init];
    //Value for the tabs button position and tag (y)
     buttonId = 0;
    
    istab = NO; 
    fromOtherViews = 2; 
}
//check the ua to see if it is mobile or desktop, initially the goal is to resize the window each time the view change
-(void)checkua
{
    //Check if the UA and change the windows size
    if ([UA isEqualToString:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543 Safari/419.3"]) {
        
    }
    else
    {
    
    }
}


//Later, it should really do something useful
-(void)windowResize:(id)sender
{
    NSRect windowSize = [[allTabsButton window]frame];
    int size = windowSize.size.width;  
    //WebViewController *button = [tabsArray lastObject];
    if ([tabController numberOfTabViewItems]*tabButtonSize > size - 120)
    {
        //[button.tabview setHidden:YES]; 
        [allTabsButton setHidden:NO]; 
        [allTabsButton setAction:@selector(menutabs:)]; 
        [allTabsButton setTarget:self];
    }
    else
    {
        //[button.tabview setHidden:NO]; 
        [allTabsButton setHidden:YES];   
    }
    
}





#pragma mark -
#pragma mark tab management

//Called once a tab button is clicked
-(void)tabs:(id)sender
{
    [tabController selectTabViewItemAtIndex:[sender tag]]; 
    
    //Instansiate the webviewcontroller with the object in the array at the button tag index
    WebViewController *clickedtab = [tabsArray objectAtIndex:[sender tag]];
    curentSelectedTab = [sender tag];
    //load the clicked button
    //TabButtonControlle *clickedbutton = [buttonTabsArray objectAtIndex:[sender tag]];
    [[clickedtab backgroundTab]setAlphaValue:0.0]; 
    
    //reset all button state
    [self resetAllTabsButon]; 
    
    if (clickedtab != nil)
    {
            //Set the title of the windows
        [clickedtab setWindowTitle:allTabsButton];
        [self setImageOnSelectedTab]; 
        
    }
    
    //make the selected button appear to make an animation
    [[[clickedtab backgroundTab]animator]setAlphaValue:1.0];
}

//Add a new tabs
//Maybe a big piece of shit but it works. Need rewrite

-(void)setImageOnSelectedTab
{
    WebViewController *clickedtab = [tabsArray objectAtIndex:[tabController indexOfTabViewItem:[tabController selectedTabViewItem]]];
    [[clickedtab backgroundTab]setImage:[NSImage imageNamed:@"gradient_on.png"]];
}

-(void)addtabs:(id)sender
{

    
    //Instanciate a new webviewcontroller and the button tab view with the view
    WebViewController *newtab = [[WebViewController alloc]init];
    //Set the Button view
    //force the view to init
    [newtab view]; 
    [[newtab tabview]setAlphaValue:0.0]; 
    [[newtab tabview]setFrame:NSMakeRect([tabController numberOfTabViewItems]*tabButtonSize, 0, tabButtonSize, 20)]; 
    [[newtab tabButtonTab]setAction:@selector(tabs:)]; 
    [[newtab tabButtonTab]setTarget:self]; 
    [[newtab tabButtonTab]setTag:buttonId]; 
        curentSelectedTab = buttonId; 
    [[newtab tabButtonTab]setEnabled:YES]; 
    [[newtab pageTitleTab]setStringValue:NSLocalizedString(@"New tab", @"NewTab")];
    [[newtab closeButtonTab]setTag:buttonId]; 
    [[newtab closeButtonTab]setAction:@selector(closeSelectedTab:)]; 
    [[newtab closeButtonTab]setTarget:self];
    [[newtab closeButtonTab]setEnabled:YES]; 
    //Bind the addtabd button to the current object action
    [[newtab tabsButton]setAction:@selector(addtabs:)];
    [[newtab tabsButton]setTarget:self]; 
    //set the new webview delegate to this class method
    [[newtab webview]setUIDelegate:self]; 
    [[newtab webview]setPolicyDelegate:self]; 
    //Set the host window to the actual window for plugin 
    [[newtab webview]setHostWindow:[tabController window]];
    
    NSRect windowSize = [[sender window]frame];
    CGFloat size = windowSize.size.width;  
    
    //If the buttposition is over 900 then display a button which will list tabs
    if ([tabController numberOfTabViewItems]*tabButtonSize > size - 250)
    {
        [allTabsButton setHidden:NO]; 
        [allTabsButton setAction:@selector(menutabs:)]; 
        [allTabsButton setTarget:self];
    }
    else
    {
        [allTabsButton setHidden:YES];   
    }

    
    //Add the button and webview instance in array.
    [tabsArray addObject:newtab]; 

    //Add created elements to the view
    [tabPlaceHolder addSubview:[newtab tabview]];
    [[newtab tabview]setAlphaValue:1.0]; 
    
    //increment the position and the tag value for the next button placement
    buttonId = buttonId +1;
    
    //Pre select the address for faster typing
    [[newtab address]selectText:self];
    
    //if the passed URL value is different of nil then load it in the webview 
    if (PassedUrl != nil) {
        [newtab setIsNewTab:NO]; 
        [newtab initWithUrl:PassedUrl]; 

    }
    //if null then inti the webview with tthe welcom page
    else
    {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults) {
            if ([standardUserDefaults integerForKey:@"doHaveLaunched"] == 0) {
                [standardUserDefaults setInteger:1 forKey:@"doHaveLaunched"];
                [standardUserDefaults synchronize];
                [newtab initWithFirstTimeLaunchPage];
            }
                else
                {
                    [newtab initWithPreferredUrl]; 
                }
            }
        }
    //[buttonview release]; 
    NSTabViewItem *item = [[NSTabViewItem alloc]init]; 
    [item setView:[newtab switchView]];
    [tabController addTabViewItem:item]; 
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults]; 
    if (standardUserDefault) {
        if ([standardUserDefault integerForKey:@"OpenTabInBackground"] == 0) {
                //reset all tabs button position
                [self resetAllTabsButon]; 
                [tabController selectTabViewItem:item]; 
                //If the new tab object is diffrent of null then show it (it should be alway different of null)
                if (newtab != nil)
                {
                
                    [newtab setWindowTitle:sender];
                    //[newtab setCurrentButtonClicked:buttonview]; 
                    //Set the clicked button alpha value to show it activated
                
                }
        }
    }
    [self setImageOnSelectedTab];
    [item release]; 
    [newtab release]; 
    
    //reset the value
    PassedUrl = nil; 
    
    
}

//THe action when the tab menu button is clicked
-(void)menutabs:(id)sender
{
    int i=0; 
    NSUInteger b; 
    NSMenu *menu = [[NSMenu alloc]init]; 
    
    //get the number of object in the buttontab array
    b = [tabsArray count]; 
    for (i=0;i<b;i++)
    {
        WebViewController *button =  [tabsArray objectAtIndex:i];
        
        //Create a menu and set the different items of the menu
        NSMenuItem *item = [[NSMenuItem alloc]init];
        [item setTarget:self]; 
        [item setTitle:[button.pageTitleTab stringValue]]; 
        [item setImage:[button.faviconTab image]];
        [item setTag:i]; 
        [item setAction:@selector(tabs:)];
        [item setEnabled:YES];
        [menu addItem:item];
        [item release]; 
    }
    
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
    
    [menu release]; 

}


//Reset all tabs button state
-(void)resetAllTabsButon
{
    NSInteger result = [tabsArray count]; 
    int i; 
    for (i=0; i<result; i++) {
        //reset all button stored into the array
        WebViewController *tpsbutton = [tabsArray objectAtIndex:i]; 
    [[tpsbutton backgroundTab]setImage:[NSImage imageNamed:@"gradient_normal.png"]];
        
    }

}


//called when click on the home tab button, bring back the first view

-(void)closeSelectedTab:(id)sender
{
   
    //Two temporary array that will store temp object
    NSMutableArray *tpstabarray = [[NSMutableArray alloc]init];

    //The current webview remove
    WebViewController *clickedtab = [tabsArray objectAtIndex:[sender tag]];
    [clickedtab view];
    [[clickedtab webview]setHostWindow:nil];
    [[clickedtab webview]setUIDelegate:nil]; 
    [[clickedtab webview]setPolicyDelegate:nil];
    [[clickedtab webview]stopLoading:[clickedtab webview]];
    [[[clickedtab view]animator]setAlphaValue:0.0]; 
    [[clickedtab view]removeFromSuperview];
    [[[clickedtab tabview]animator]setAlphaValue:0.0]; 
    [[clickedtab tabview]removeFromSuperview];
    [[clickedtab webview]removeFromSuperview];
                            
    [tabsArray removeObjectAtIndex:[sender tag]];
    NSTabViewItem *item = [tabController tabViewItemAtIndex:[sender tag]];
    [tabController removeTabViewItem:item]; 
    


    //reset the buttonid and position in preparation of reorg of tabs
    buttonId = 0; 
    
    //Transfert all the tabs from the real array to the tempsarray
    int v; 
    NSInteger resulttabs = [tabsArray count]; 
    for (v=0; v<resulttabs; v++) {
        WebViewController *tpstab = [tabsArray objectAtIndex:v]; 
        [[tpstab tabButtonTab]setTag:buttonId]; 
        [[tpstab closeButtonTab]setTag:buttonId]; 
        [[[tpstab tabview]animator]setFrame:NSMakeRect(tabButtonSize*v, 0, tabButtonSize, 20)]; 
        buttonId = buttonId +1; 
        [tpstabarray addObject:tpstab]; 
    }
    
    //remove all object from tabs and button array
    [tabsArray removeAllObjects]; 
    
    //pass the object from tps array in the originale array
    
    for (v=0; v<resulttabs; v++) {
        [tabsArray addObject:[tpstabarray objectAtIndex:v]]; 
    }
    
    [tpstabarray release]; 
    
    if ([tabsArray count] == 0) {
        [self addtabs:nil]; 
    }
    
    
    if (curentSelectedTab == [sender tag]) {
        if (curentSelectedTab == 0) {
            NSButton *button = [[NSButton alloc]init]; 
            NSInteger nb = 0;
            [button setTag:nb]; 
            [self tabs:button]; 
            [button release]; 
            [tabController selectTabViewItemAtIndex:nb]; 
        }
        else {
            NSButton *button = [[NSButton alloc]init]; 
            NSInteger nb = [sender tag]; 
            nb = nb -1; 
            [button setTag:nb]; 
            [self tabs:button]; 
            [button release]; 
            [tabController selectTabViewItemAtIndex:nb]; 
        }
    }
    [self setImageOnSelectedTab];
    
    
    
}
//close all tabs
-(void)closeAllTabs:(id)sender
{
    
    //Get the nimber of object in the array
    NSInteger result = [tabsArray count]; 
    int i; 
    
    //reset the buttonid and position in preparation of reorg of tabs
    buttonId = 0; 
    
    //Get all the buton,reset their position and id and, pass it in a temps array
    for (i=0; i<result; i++) {
        //reset all button stored into the array
        WebViewController *tpsbutton = [tabsArray objectAtIndex:i];
        [[[tpsbutton tabview]animator]setAlphaValue:0.0]; 
        [[tpsbutton tabview]removeFromSuperview]; 
    }

    //remove the targeged object from collection/array
    [tabsArray removeAllObjects]; 
    buttonId = 0; 
    
    if ([tabsArray count] == 0) {
        [self addtabs:nil]; 
    }
  

    
}
#pragma mark -
#pragma mark webview Delegate

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    if ([type hasPrefix:@"application"]) {
        DownloadDelegate *dlDelegate = [[DownloadDelegate alloc]init];
        NSURLDownload  *theDownload = [[NSURLDownload alloc] initWithRequest:request
                                                                delegate:dlDelegate];
        [theDownload release]; 
        [dlDelegate release]; 
        if (![type isEqualToString:@"application/pdf"]) {
            [webView stopLoading:nil];
        }
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

//Little hack to intercept URL, the webview start provisiosing with the previous request. Only way to catch the URL
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
if (frame == [sender mainFrame]){
    if ([[sender mainFrameURL]isEqualToString:@""]) {
    }
        else
        {
            PassedUrl = [sender mainFrameURL]; 
            [self addtabs:nil];
            [sender stopLoading:sender];   
        }
    }
}


- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    //PassedUrl = [[request URL]absoluteString]; 
    //[self addtabs:nil]; 
    [listener use];
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
/*
//UPload window
- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener
{       
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:YES];
    
    [openDlg setCanChooseDirectories:NO];
    
    // process the files.
    if ( [openDlg runModal] == NSOKButton )
    {
        NSString* fileString = [[openDlg URL]absoluteString];
        [resultListener chooseFilename:fileString]; 
    }
    
}
 */

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
        NSArray* URLs = [openDlg URLs];
        NSMutableArray *files = [[NSMutableArray alloc]init];
        for (int i = 0; i <[URLs count]; i++) {
            NSString *filename = [[URLs objectAtIndex:i]relativePath];
            [files addObject:filename];
        }
        
        for(int i = 0; i < [files count]; i++ )
        {
            NSString* fileName = [files objectAtIndex:i];
            [resultListener chooseFilename:fileName]; 
        }
        [files release];
    }
    
}
/*
- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener allowMultipleFiles:(BOOL)allowMultipleFiles
{
        // Create the File Open Dialog class.
        NSOpenPanel* openDlg = [NSOpenPanel openPanel];
        
        // Enable the selection of files in the dialog.
        [openDlg setCanChooseFiles:YES];
        
        // Enable the selection of directories in the dialog.
        [openDlg setCanChooseDirectories:NO];
        
        // Display the dialog.  If the OK button was pressed,
        // process the files.
        if ( [openDlg runModal] == NSOKButton )
        {
            // Get an array containing the full filenames of all
            // files and directories selected.
            NSArray* files = [openDlg URLs];
            NSArray* finalFiles = [[NSArray alloc]init];
            // Loop through all the files and process them.
            for(int i = 0; i < [files count]; i++ )
            {
                NSString* fileName = [files objectAtIndex:i]; //i]; 
                [finalFiles arrayByAddingObject:fileName];
                // Do something with the filename.
                [resultListener chooseFilenames:finalFiles]; 
            }
            [finalFiles release]; 
        }
        
}
 */

/*
- (BOOL)webViewIsStatusBarVisible:(WebView *)sender
{
    return YES; 
}
 */

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{
    return defaultMenuItems;
}


#pragma -
#pragma mark memory management

//Bad memory maanagement for now ! 
- (void)dealloc
{   
    int v;
    for (v=0; v<[tabsArray count]; v++) {
        WebViewController *newtab = [tabsArray objectAtIndex:v];
        [[newtab webview]setUIDelegate:nil]; 
        [[newtab webview]setPolicyDelegate:nil];
        [[newtab webview]removeFromSuperview];
    }
    [tabsArray removeAllObjects];
    [tabsArray release], tabsArray = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc];
}
@end