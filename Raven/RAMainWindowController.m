//
//  MainWindowController.m
//  Raven
//
//  Created by Thomas Ricouard on 24/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAMainWindowController.h"
#import "RavenAppDelegate.h"



//smart bar app positioning
#define retracted_app_height 55
#define app_expanded_height 200
#define initial_position 228
#define app_position_x -7
#define app_view_w 108
#define app_view_h 278
#define initial_app_space 514
#define bottom_bar_size 40
#define number_h 21

#define button_x 16
#define button_w 32
#define button_h 32

#define badge_x 37
#define badge_y 238
#define badge_w 30
#define badge_h 30

#define toolbarSize 26




@implementation RAMainWindowController
@synthesize passedUrl, navigatorview, downloadButton, centeredView, myCurrentViewController, appList, delegate;
#pragma mark -
#pragma mark init and close
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

    }
    
    return self;
}


- (void)dealloc
{
    NSMenu *topMenu = [NSApp menu]; 
    NSMenu *smartBarMenu = [[topMenu itemAtIndex:4]submenu];
    NSInteger count = smartBarMenu.itemArray.count;
    for (NSInteger sb=13; sb < count; sb++) {
        [smartBarMenu removeItemAtIndex:13];
    }
    for (NSMenuItem *item in [[[topMenu itemAtIndex:3]submenu]itemArray]) {
        [[[topMenu itemAtIndex:3]submenu]removeItem:item];
    }
    for (NSMenuItem *item in [[[topMenu itemAtIndex:6]submenu]itemArray]) {
        [[[topMenu itemAtIndex:6]submenu]removeItem:item];
    }
    for (NSMenuItem *item in [[[topMenu itemAtIndex:3]submenu]itemArray]) {
        [[[topMenu itemAtIndex:3]submenu]removeItem:item];
    }
    for (NSMenuItem *item in [[[topMenu itemAtIndex:6]submenu]itemArray]) {
        [[[topMenu itemAtIndex:6]submenu]removeItem:item];
    }
    NSMenu *windowMenu = [[topMenu itemAtIndex:8]submenu];
    for (NSMenuItem *item in windowMenu.itemArray) {
        [windowMenu removeItem:item];
    }
    
    [navigatorview release];
    //Raven view
    [historyviewcontroller release];
    [bookmarkview release]; 
    [downloadview release]; 
    [settingview release]; 
    [appList release], appList = nil; 
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [delegate closeButtonClicked:self];
    [super dealloc];
}


-(void)windowWillClose:(NSNotification *)notification
{   
    [[RAlistManager sharedUser]writeNewAppListInMemory:nil writeToFile:YES];
    [[RAlistManager sharedUser]forceReadApplist];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self autorelease]; 
}

- (BOOL)windowShouldClose:(id)sender
{
    NSAlert *alert = [[NSAlert alloc] init];
    NSString *exampleAlertSuppress = @"WindowWillClose";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:exampleAlertSuppress] == YES) {
        [alert release];
        return YES; 
    }
    else
    {
        [alert setMessageText:NSLocalizedString(@"Are you sure you want to close this window?", @"CloseWindowPrompt")];
        [alert setInformativeText:NSLocalizedString(@"All of your apps and tabs will be closed.", @"WindowContinu")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        [alert setShowsSuppressionButton:YES];
        [alert setIcon:[NSImage imageNamed:@"tab-close-warning.png"]];
        //call the alert and check the selected button
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        [alert release];
        return NO; 
    }

}


-(NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect
{
    rect.origin.y = rect.origin.y + 27; 
    return rect;
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        if ([[alert suppressionButton] state] == NSOnState) {
            // Suppress this alert from now on.
            NSString *exampleAlertSuppress = @"WindowWillClose";
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:exampleAlertSuppress];
            [defaults synchronize];
        }
        
        [self close]; 
    }
}


- (void)awakeFromNib
{
    [super windowDidLoad];
    [[self window]setDelegate:self]; 
    if (IS_RUNNING_LION) {
        static int NSWindowAnimationBehaviorDocumentWindow = 3;
        [[self window]setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    }
    isAdressBarHidden = NO; 
    //Listen to interesting notifications about GUI refresh
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:SMART_BAR_UPDATE 
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:NEW_APP_INSTALLED 
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:DOWNLOAD_BEGIN 
                                              object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:DOWNLOAD_FINISH 
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(windowWillClose:) 
                                                 name:NSWindowWillCloseNotification 
                                               object:self.window];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:UPDATE_TAB_NUMBER 
                                              object:nil];
    
    //init view controller with appropriate nib
    navigatorview =
    [[RANavigatorViewController alloc] init];
    
    historyviewcontroller =
    [[RAHistoryViewController alloc] initWithNibName:@"history" bundle:nil];
    
    bookmarkview =
    [[RABookmarkViewController alloc] initWithNibName:@"Bookmark" bundle:nil];
    
    downloadview = 
    [[RADownloadViewController alloc]initWithNibName:@"Download" bundle:nil]; 
    
    settingview = 
    [[RASettingViewController alloc]initWithNibName:@"Settings" bundle:nil]; 
    
    previousIndex = -1;
    previousAppNumber = 4; 
    [self launchRuntime];
    [[self window]display];
    //[self replaceTitleBarViewWith:titleBar];
    
}

-(void)receiveNotification:(NSNotification *)notification
{   
    if ([[notification name]isEqualToString:SMART_BAR_UPDATE]) {
        [self initSmartBar];
        [self updateSmartBarUi];
        [self resetSmartBarUi];
        [self animate:13];
    }
    if ([[notification name]isEqualToString:NEW_APP_INSTALLED]) {
        [self newAppInstalled];
    }
    if ([[notification name]isEqualToString:DOWNLOAD_BEGIN])
    {
        [downloadButton setHidden:NO];
        [downloadButton setAlphaValue:1.0];
        [downloadButton setImage:[NSImage imageNamed:@"download_on.png"]];
    }
    if ([[notification name]isEqualToString:@"downloadDidFinish"]){
        [downloadButton setHidden:NO];
        [downloadButton setAlphaValue:1.0];
        [downloadButton setImage:[NSImage imageNamed:@"download_on.png"]];
    }
    if ([[notification name]isEqualToString:UPDATE_TAB_NUMBER]){
        [firstButtonNumber setStringValue:[self numberOfDotToDisplay:[navigatorview.tabsArray count]]];
    }
}

#pragma mark -
#pragma mark smart Bar UI

-(NSString *)numberOfDotToDisplay:(NSUInteger)numberOfTabs
{
    switch (numberOfTabs) {
        case 0:
            return @"";
            break;
        case 1:
            return @"•";
            break; 
        case 2:
            return @"••";
            break;
        case 3:
            return @"•••";
            break; 
        case 4:
            return @"••••";
            break; 
        default:
            return @"•••••";
            break;
    }
    
}
//take care of the Smart Bar init once window is awake
-(void)launchRuntime
{  
    [self initSmartBar]; 
    [self updateSmartBarUi];
    [self raven:nil];
}

//Called each time window is resized
-(void)windowDidResize:(NSNotification *)notification
{
    [self updateSmartBarUi];
}

//Read app.plist and instanciate each item and add them in array, all app are in memory
//Also reset it totally
-(void)initSmartBar
{
    if( appList )
    { 
        for (NSInteger g=0; g<[appList count]; g++) {
            [[[appList objectAtIndex:g]view]removeFromSuperview];
        }
        [appList release], appList = nil;
    }
	appList = [[NSMutableArray alloc]init];
    RAlistManager *listManager = [RAlistManager sharedUser];
    NSArray *folder = [listManager readAppList];
    NSMutableArray *folders = [[NSMutableArray alloc]init]; 
    for (NSDictionary *item in folder) {
        [folders addObject:item];
        
    }
    NSMenu *topMenu = [NSApp menu]; 
    NSMenu *smartBarMenu = [[topMenu itemAtIndex:4]submenu];
    NSInteger count = smartBarMenu.itemArray.count;
    for (NSInteger sb=13; sb < count; sb++) {
        [smartBarMenu removeItemAtIndex:13];
    }
    
    //local array index
    int x = 0;
    //global plist index
    int b = 0; 
    for (NSDictionary *item in folders) {
        RASmartBarViewController *smartApp = [[RASmartBarViewController alloc]initWithDelegate:self 
                                                                               withDictionnary:item 
                                                                                withArrayIndex:x 
                                                                             andWithPlistIndex:b];                          

        if (smartApp.state == 1) {
            //dirty menu part
            NSString *homeButtonPath = [NSString stringWithFormat:application_support_path@"%@/main.png", [item objectForKey:PLIST_KEY_FOLDER]];
            NSImage *homeButtonImage = [[NSImage alloc]initWithContentsOfFile:[homeButtonPath stringByExpandingTildeInPath]];
            [homeButtonImage setSize:NSMakeSize(20, 20)];
            NSMenuItem *appMenu = [[NSMenuItem alloc]initWithTitle:[item objectForKey:PLIST_KEY_APPNAME] action:@selector(expandApp:) keyEquivalent:[NSString stringWithFormat:@"%d", x+1]]; 
            [appMenu setTarget:smartApp];
            [appMenu setImage:homeButtonImage];
            [smartBarMenu addItem:appMenu];
            [appMenu release];
            [homeButtonImage release];
            //
            [appList addObject:smartApp]; 
            [[appList objectAtIndex:x]view];
            [rightView addSubview:[[appList objectAtIndex:x]view]];
            [smartApp retractApp:nil];
            x+=1;
        }
        [smartApp release];
        b+=1; 
    }
    [topMenu setSubmenu:smartBarMenu forItem:[topMenu itemAtIndex:4]];
    //[NSApp setMenu:topMenu];
    [folders release];
    

}
 
//update UI when an app expand, Delegate sent from RASmartBarViewController
-(void)itemDidExpand:(RASmartBarViewController *)smartBarApp
{
    int currentNumber  = smartBarApp.smartBarItem.URLArray.count;
    NSInteger index = [appList indexOfObject:smartBarApp]; 
    for (NSInteger x=0; x<[appList count]; x++) {
        RASmartBarViewController *smartApp = [appList objectAtIndex:x]; 
        NSRect frame = [[smartApp view]frame];
        
        if (previousIndex == x ) {
            [smartApp retractApp:nil];
        }
        if (x<=index && [smartBarApp state] == 0 && x > previousIndex) {
            [[[smartApp view]animator]setFrame:NSMakeRect(app_position_x, frame.origin.y + app_expanded_height, app_view_w, app_view_h)]; 
        }
        if (x > index && index <= previousIndex && x <= previousIndex) {
            [[[smartApp view]animator]setFrame:NSMakeRect(app_position_x, frame.origin.y - app_expanded_height, app_view_w, app_view_h)];
        }
    }
    [self hideall]; 
    [self animate:12]; 
    previousIndex = index;
    previousAppNumber = currentNumber; 
     
}

//Update the smart bar scrollview height to get the right scroll
-(void)updateSmartBarUi
{
    NSInteger totalSize = initial_position + ([appList count] * retracted_app_height);
    if ((totalSize + 60) < self.window.frame.size.height) {
        [rightView setFrameSize:NSMakeSize(rightView.frame.size.width, self.window.frame.size.height - bottom_bar_size)];
    }
    else
    {
        [rightView setFrameSize:NSMakeSize(rightView.frame.size.width, 
        bottom_bar_size + self.window.frame.size.height + (totalSize - self.window.frame.size.height))];
    }
    
}

//Read the latest app installed and place it on the view
-(void)newAppInstalled
{
    RAlistManager *listManager = [RAlistManager sharedUser];
    NSArray *folders = [listManager readAppList];
    NSDictionary *item = [folders lastObject];
    RASmartBarViewController *smartApp = [[RASmartBarViewController alloc]initWithDelegate:self 
                                                                           withDictionnary:item 
                                                                            withArrayIndex:[folders count]+1 andWithPlistIndex:[folders count]];
    [appList addObject:smartApp]; 
    [[appList lastObject]view];
    [rightView addSubview:[[appList lastObject]view]];
    [smartApp retractApp:nil];
    [smartApp release]; 
    [self updateSmartBarUi];
    [self raven:nil];

}

//reset the smartbar UI, place item at their initial state
-(void)resetSmartBarUi
{
    for (NSInteger x=0; x<[appList count]; x++) {
        RASmartBarViewController *smartApp = [appList objectAtIndex:x]; 
        [[smartApp view]setFrame:NSMakeRect(app_position_x, rightView.frame.size.height - initial_app_space - (retracted_app_height*x), app_view_w, app_view_h)];
        [smartApp retractApp:nil];
        
        
    }
    previousIndex = -1;
    NSPoint pt = NSMakePoint(0.0, [[smartBarScrollView documentView]
                                   bounds].size.height);
    [[smartBarScrollView documentView] scrollPoint:pt];
    [smartBarScrollView reflectScrolledClipView: [smartBarScrollView contentView]]; 
 
}


-(IBAction)hideSideBar:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([settingButton alphaValue] == 0.0) {
        [settingButton setHidden:NO];
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];
        [[centeredView animator]setFrame:[backupView frame]]; 
        [[smartBarScrollView animator]setFrame:NSMakeRect(-17, smartBarScrollView.frame.origin.y, smartBarScrollView.frame.size.width, smartBarScrollView.frame.size.height)];
        [[cornerBox animator]setFrame:NSMakeRect(-17, cornerBox.frame.origin.y, cornerBox.frame.size.width, cornerBox.frame.size.height)];
        [[settingButton animator]setAlphaValue:1.0];
        [NSAnimationContext endGrouping];
        isHidden = NO;
        
    }
    else{
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];
        [[centeredView animator]setFrame:[mainView bounds]]; 
        [[smartBarScrollView animator]setFrame:NSMakeRect(smartBarScrollView.frame.origin.x - 76, smartBarScrollView.frame.origin.y, smartBarScrollView.frame.size.width, smartBarScrollView.frame.size.height)];
        [[cornerBox animator]setFrame:NSMakeRect(cornerBox.frame.origin.x - 76, cornerBox.frame.origin.y, cornerBox.frame.size.width, cornerBox.frame.size.height)];
        [[settingButton animator]setAlphaValue:0.0];
        if ([standardUserDefaults integerForKey:SIDEBAR_LIKE_DOCK] == 0)
        {
            [settingButton setHidden:YES];
            [[settingButton animator]setHidden:YES];
        }
        [NSAnimationContext endGrouping];
        isHidden = YES;
        
    }
    
}

-(void)showSideBar{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults integerForKey:SIDEBAR_LIKE_DOCK] == 1 && isHidden == YES) {
            [settingButton setHidden:NO];
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0.3];
            [[settingButton animator]setAlphaValue:1.0];
            [[cornerBox animator]setFrame:NSMakeRect(-17, cornerBox.frame.origin.y, cornerBox.frame.size.width, cornerBox.frame.size.height)];
            [[smartBarScrollView animator]setFrame:NSMakeRect(-17, smartBarScrollView.frame.origin.y, smartBarScrollView.frame.size.width, smartBarScrollView.frame.size.height)];
            [NSAnimationContext endGrouping];
        }
    }
    
}

-(void)hideSideBar{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults integerForKey:SIDEBAR_LIKE_DOCK] == 1 && isHidden == YES) {
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0.3];
            [[smartBarScrollView animator]setFrame:NSMakeRect(smartBarScrollView.frame.origin.x - 76, smartBarScrollView.frame.origin.y, smartBarScrollView.frame.size.width, smartBarScrollView.frame.size.height)];
            [[cornerBox animator]setFrame:NSMakeRect(cornerBox.frame.origin.x - 76, cornerBox.frame.origin.y, cornerBox.frame.size.width, cornerBox.frame.size.height)];
            [[settingButton animator]setAlphaValue:0.0];
            [NSAnimationContext endGrouping];
        }
    }
}

-(void)nextApp:(id)sender
{
   
}

-(void)previousApp:(id)sender
{
    
}

-(void)addAppAtIndex:(int)index
{
    [self resetSmartBarUi];
}

-(void)hideAppAtIndex:(int)index
{
    id tps;
    for (RASmartBarViewController *app in appList) {
        if (app.smartBarItem.index == index) {
             tps = app; 
        }
    }
    if (tps != nil) {
        [[[appList objectAtIndex:[appList indexOfObject:tps]]view]removeFromSuperview];
        [appList removeObject:tps];
    }
    [self resetSmartBarUi];
}

-(void)moveAppFromIndex:(int)from toIndex:(int)to
{
    [self resetSmartBarUi];
}

#pragma mark -
#pragma mark window UI
-(void)hideShowAddressBar:(id)sender
{
    if (isAdressBarHidden) {
        [[centeredView animator]setFrame:NSMakeRect(centeredView.frame.origin.x, centeredView.frame.origin.y, centeredView.frame.size.width, centeredView.frame.size.height - toolbarSize)];
        isAdressBarHidden = NO; 
    }
    else{
        [[centeredView animator]setFrame:NSMakeRect(centeredView.frame.origin.x, centeredView.frame.origin.y, centeredView.frame.size.width, centeredView.frame.size.height + toolbarSize)];
        isAdressBarHidden = YES;
    }

}


#pragma mark -
#pragma mark viewswitch
#pragma mark app menu button 
//Method for big button
-(IBAction)raven:(id)sender
{
    [self SetMenuButton]; 
    //Select the button
    [self home:sender]; 
    //Set the alphe value of the current button
    [[ravenMenuButton animator]setAlphaValue:1.0]; 
    [self resetSmartBarUi];
    [self animate:13]; 
}

#pragma mark raven button
//history view
-(IBAction)history:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(check:) toTarget:historyviewcontroller withObject:nil];
    if ([myCurrentViewController view] != nil)
		[[myCurrentViewController view] removeFromSuperview];	// remove the current view
    //Check if the view is nil (to see if it correctly initialized or instanciated
    
    if (historyviewcontroller != nil)
    {
        //Put the view on the view controller
        myCurrentViewController = historyviewcontroller;
        
    }
    
    //Adjust the size of the view
    [centeredView addSubview: [myCurrentViewController view]];
    [[myCurrentViewController view] setFrame:[centeredView bounds]];
    [[self window]setTitle:NSLocalizedString(@"History",@"HistoryView")]; 
    //Method for the smartbar
    [self hideall]; 
    [self animate:2];
}




//Navigator view
-(IBAction)home:(id)sender
{
    
    
    if ([myCurrentViewController view] != nil)
		[[myCurrentViewController view] removeFromSuperview];
    
    if (navigatorview != nil)
    {
        myCurrentViewController = navigatorview;
        //[navigatorview setWindowTitle:self]; 
        
    }
    if ([[navigatorview tabsArray]count] == 0) {
        [navigatorview view];
        [navigatorview addtabs:self];
    } 
    [navigatorview setMenu];
    [centeredView addSubview: [myCurrentViewController view]];
    [[myCurrentViewController view]setFrame:[centeredView bounds]];
    [self hideall]; 
    [self animate:1];  
}
//Bookmark view
-(IBAction)bookmark:(id)sender
{
    if ([myCurrentViewController view] != nil)
		[[myCurrentViewController view] removeFromSuperview];
    
    if (bookmarkview != nil)
    {
        
        myCurrentViewController = bookmarkview;	
        
    }
    
    [bookmarkview reselectRow:nil];
    [centeredView addSubview: [myCurrentViewController view]];
    [[myCurrentViewController view] setFrame:[centeredView bounds]];
    [[self window]setTitle:NSLocalizedString(@"Bookmarks", @"BookmarksView")]; 
    [self hideall]; 
    [self animate:3]; 
    
    
    
}


-(void)download:(id)sender
{
    if ([myCurrentViewController view] != nil)
		[[myCurrentViewController view] removeFromSuperview];
    
    if (bookmarkview != nil)
    {
        
        myCurrentViewController = downloadview;
        
    }
    
    [centeredView addSubview: [myCurrentViewController view]];
    [[myCurrentViewController view] setFrame:[centeredView bounds]];
    [[self window]setTitle:NSLocalizedString(@"Downloads", @"DownloadView")]; 
    [self hideall]; 
    [self animate:4];   
    
}

-(void)setting:(id)sender
{
    if (myCurrentViewController == settingview) {
        [self raven:nil]; 

    }
    else{
        
    if ([myCurrentViewController view] != nil)
		[[myCurrentViewController view] removeFromSuperview];
    
    if (settingview != nil)
    {

        myCurrentViewController = settingview;
        
        
    }
    [[self window]setTitle:NSLocalizedString(@"Home", @"HomeScreen")]; 
    [centeredView addSubview:[myCurrentViewController view]];
    [[myCurrentViewController view] setFrame:[centeredView bounds]];
    [self hideall]; 
    [self animate:11]; 
    }
    
}


#pragma mark -
#pragma mark switch method
-(void)SetMenuButton
{
    [[ravenMenuButton animator]setAlphaValue:0.5]; 
}
-(void)hideall
{
    [homeButton setImage:[NSImage imageNamed:@"home_off.png"]];
    [historyButton setImage:[NSImage imageNamed:@"history_off.png"]]; 
    [bookmarkButton setImage:[NSImage imageNamed:@"favorite_off.png"]]; 
    [downloadButton setImage:[NSImage imageNamed:@"downloads_off.png"]]; 
    [settingButton setImage:[NSImage imageNamed:@"btn_settings_off.png"]]; 

}


-(void)animate:(NSUInteger)setMode
{
    NSImage *settingButtonOn = [NSImage imageNamed:@"btn_settings_on.png"]; 
    
    switch (setMode) {
        case 1:
            [homeButton setImage:[homeButton alternateImage]];
            break;
        case 2:
            [historyButton setImage:[historyButton alternateImage]]; 
            break;
            //bookmark mode //                          bookmark
        case 3:
            [bookmarkButton setImage:[bookmarkButton alternateImage]];
            break; 
            //download mode  //                          download
        case 4:
            [downloadButton setImage:[downloadButton alternateImage]]; 
            break;
        //setting
        case 11:
            [settingButton setImage:settingButtonOn]; 
            break;
        case 12:
            [[ravenMenuButton animator]setAlphaValue:0.5];
            [[homeButton animator]setAlphaValue:0.0];
            [homeButton setEnabled:NO];
            [[historyButton animator]setAlphaValue:0.0]; 
            [historyButton setEnabled:NO];
            [[bookmarkButton animator]setAlphaValue:0.0]; 
            [bookmarkButton setEnabled:NO];
            [[downloadButton animator]setAlphaValue:0.0]; 
            [downloadButton setEnabled:NO];
            [[homeButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -65, 32, 32)];
            [[firstButtonNumber animator]setAlphaValue:0.0];
            [[historyButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -65, 32, 32)];
            [[bookmarkButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -65, 32, 32)];
            [[downloadButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -65, 32, 32)];
            
            break;
        case 13:
            [[ravenMenuButton animator]setAlphaValue:1.0];
            [[homeButton animator]setAlphaValue:1.0];
            [homeButton setEnabled:YES];
            [[historyButton animator]setAlphaValue:1.0];
            [historyButton setEnabled:YES];
            [[bookmarkButton animator]setAlphaValue:1.0];
            [bookmarkButton setEnabled:YES];
            [[downloadButton animator]setAlphaValue:1.0];
            [downloadButton setEnabled:YES];
            [[homeButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -115, 32, 32)];
            [[firstButtonNumber animator]setFrame:NSMakeRect(16, rightView.frame.size.height -131, button_w, number_h)];
            [[firstButtonNumber animator]setAlphaValue:1.0];
            [[historyButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -165, 32, 32)];
            [[bookmarkButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -215, 32, 32)];
            [[downloadButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -265, 32, 32)]; 
            default:
            break;
    }
    
}
@end
