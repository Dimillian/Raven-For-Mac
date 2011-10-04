//
//  MainWindowController.m
//  Raven
//
//  Created by Thomas Ricouard on 24/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"
#import "RavenAppDelegate.h"
#import "SettingViewController.h"

//smart bar app positioning constante
#define retracted_app_height 54
#define app_expanded_height 200
#define initial_position 228
#define app_position_x -7
#define app_view_w 108
#define app_view_h 278
#define initial_app_space 516
#define bottom_bar_size 40



@implementation MainWindowController
@synthesize passedUrl, navigatorview, downloadButton, centeredView, myCurrentViewController, appList;
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
    
    [navigatorview release];
    
    //Raven view
    [historyviewcontroller release];
    [bookmarkview release]; 
    [downloadview release]; 
    [settingview release]; 
    [appList release], appList = nil; 
    
    [super dealloc];
}


-(void)windowWillClose:(NSNotification *)notification
{   
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
        [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        [alert release];
        return NO; 
    }

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
    
    //Listen to interesting notifications about GUI refresh
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:@"smartBarWasUpdated" 
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:@"newAppInstalled" 
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:@"downloadDidBegin" 
                                              object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:@"downloadDidFinish" 
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(windowWillClose:) 
                                                 name:NSWindowWillCloseNotification 
                                               object:self.window];
    
    
    //init view controller with appropriate nib
    navigatorview =
    [[NavigatorViewController alloc] init];
    
    historyviewcontroller =
    [[HistoryViewController alloc] initWithNibName:@"history" bundle:nil];
    
    bookmarkview =
    [[BookmarkViewController alloc] initWithNibName:@"Bookmark" bundle:nil];
    
    downloadview = 
    [[DownloadViewController alloc]initWithNibName:@"Download" bundle:nil]; 
    
    settingview = 
    [[SettingViewController alloc]initWithNibName:@"Settings" bundle:nil]; 
    
    previousIndex = -1;
    [self launchRuntime];
    
}

-(void)receiveNotification:(NSNotification *)notification
{   
    if ([[notification name]isEqualToString:@"smartBarWasUpdated"]) {
        [self initSmartBar];
        [self updateSmartBarUi];
        [self resetSmartBarUiWithoutAnimation];
        [self animate:13];
    }
    if ([[notification name]isEqualToString:@"newAppInstalled"]) {
        [self newAppInstalled];
    }
    if ([[notification name]isEqualToString:@"downloadDidBegin"])
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
}

#pragma mark -
#pragma mark smart Bar UI

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
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folder = [[dict objectForKey:PLIST_KEY_DICTIONNARY]copy];
    NSMutableArray *folders = [[NSMutableArray alloc]init]; 
    for (NSDictionary *item in folder) {
        if ([[item objectForKey:PLIST_KEY_ENABLE]intValue] == 1) {
            [folders addObject:item];
        }
    }
    [folder release];
    int x = 0;
    for (NSDictionary *item in folders) {
        NSArray *URL = [[item objectForKey:PLIST_KEY_URL]copy];
        RASmartBarViewController *smartApp = [[RASmartBarViewController alloc]initWithDelegate:self];
        smartApp.folderName = [item objectForKey:PLIST_KEY_FOLDER];
        smartApp.state = [[item objectForKey:PLIST_KEY_ENABLE]intValue];
        smartApp.firstURL = [URL objectAtIndex:0];
        smartApp.secondURL = [URL objectAtIndex:1]; 
        smartApp.thirdURL = [URL objectAtIndex:2]; 
        smartApp.fourthURL = [URL objectAtIndex:3];
        [appList addObject:smartApp]; 
        [[appList objectAtIndex:x]view];
        [rightView addSubview:[[appList objectAtIndex:x]view]];
        [smartApp retractApp:nil];
        [URL release]; 
        [smartApp release];
        x+=1;
    }
    [folders release];
}
 
//update UI when an app expand, Delegate sent from RASmartBarViewController
-(void)itemDidExpand:(RASmartBarViewController *)smartBarApp
{
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
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSDictionary *item = [folders lastObject];
    NSArray *URL = [[item objectForKey:PLIST_KEY_URL]mutableCopy];
    RASmartBarViewController *smartApp = [[RASmartBarViewController alloc]initWithDelegate:self];
    smartApp.folderName = [item objectForKey:PLIST_KEY_FOLDER];
    smartApp.firstURL = [URL objectAtIndex:0];
    smartApp.secondURL = [URL objectAtIndex:1]; 
    smartApp.thirdURL = [URL objectAtIndex:2]; 
    smartApp.fourthURL = [URL objectAtIndex:3];
    [appList addObject:smartApp]; 
    [[appList lastObject]view];
    [rightView addSubview:[[appList lastObject]view]];
    [smartApp retractApp:nil];
    [URL release]; 
    [smartApp release]; 
    [folders release];
    [self updateSmartBarUi];
    [self raven:nil];

}

//reset the smartbar UI, place item at their initial state
-(void)resetSmartBarUi
{
    for (NSInteger x=0; x<[appList count]; x++) {
         RASmartBarViewController *smartApp = [appList objectAtIndex:x]; 
         [[[smartApp view]animator]setFrame:NSMakeRect(app_position_x, rightView.frame.size.height - initial_app_space - (retracted_app_height*x), app_view_w, app_view_h)];
         [smartApp retractApp:nil];
     }
    previousIndex = -1;
    NSPoint pt = NSMakePoint(0.0, [[smartBarScrollView documentView]
                                   bounds].size.height);
    [[smartBarScrollView documentView] scrollPoint:pt];
    [smartBarScrollView reflectScrolledClipView: [smartBarScrollView contentView]]; 
}

-(void)resetSmartBarUiWithoutAnimation
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
        [rightView setHidden:NO];
        [settingButton setHidden:NO];
        [[centeredView animator]setFrame:[backupView frame]]; 
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];
        [[rightView  animator]setAlphaValue:1.0];
        [[smartBarScrollView animator]setAlphaValue:1.0];
        [[settingButton animator]setAlphaValue:1.0];
        [NSAnimationContext endGrouping];
        [rightView setToolTip:@""]; 
        [smartBarScrollView setHidden:NO];
    
    }
    else{
        [[centeredView animator]setFrame:[mainView bounds]]; 
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];
        [[smartBarScrollView  animator]setAlphaValue:0.0];
        [[rightView  animator]setAlphaValue:0.0];
        [[settingButton animator]setAlphaValue:0.0];
        if ([standardUserDefaults integerForKey:@"SidebarLikeDock"] == 0)
        {
            [settingButton setHidden:YES];
            [[settingButton animator]setHidden:YES];
            [smartBarScrollView setHidden:YES];
        }
        [NSAnimationContext endGrouping];
        [rightView setToolTip:@"isHidden"];
        
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
        [navigatorview addtabs:nil]; 
    }    
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
        /*
        [rightView setHidden:NO];
        [[centeredView animator]setFrame:[backupView frame]]; 
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];
        [[rightView animator]setAlphaValue:1.0];
        [NSAnimationContext endGrouping];
         */

    }
    else{
        
    if ([myCurrentViewController view] != nil)
		[[myCurrentViewController view] removeFromSuperview];
    
    if (settingview != nil)
    {
        /*
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];  
        [[centeredView animator]setFrame:[mainView bounds]]; 
        [[rightView animator]setAlphaValue:0.0];
        [NSAnimationContext endGrouping];
         */
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
            [[historyButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -165, 32, 32)];
            [[bookmarkButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -215, 32, 32)];
            [[downloadButton animator ]setFrame:NSMakeRect(16, rightView.frame.size.height -265, 32, 32)]; 
            default:
            break;
    }
    
}
@end
