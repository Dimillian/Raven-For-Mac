//
//  MainWindowController.m
//  Raven
//
//  Created by Thomas Ricouard on 24/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"
#import "RavenAppDelegate.h"


@implementation MainWindowController
@synthesize passedUrl, navigatorview, downloadButton, centeredView, myCurrentViewController, appList;

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
    
    [super dealloc];
}


-(void)windowWillClose:(NSNotification *)notification
{   
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


- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window]setDelegate:self]; 
    if (IS_RUNNING_LION) {
        static int NSWindowAnimationBehaviorDocumentWindow = 3;
        [[self window]setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    }
    
    appList = [[NSMutableArray alloc]init];
    //init view controller with appropriate nib
    navigatorview =
    [[NavigatorViewController alloc] init];
    
    [self raven:nil]; 
    
    historyviewcontroller =
    [[HistoryViewController alloc] initWithNibName:@"history" bundle:nil];
    
    bookmarkview =
    [[BookmarkViewController alloc] initWithNibName:@"Bookmark" bundle:nil];
    
    downloadview = 
    [[DownloadViewController alloc]initWithNibName:@"Download" bundle:nil]; 
    
    settingview = 
    [[SettingViewController alloc]initWithNibName:@"Settings" bundle:nil]; 
    
    
    [self initSmartBar]; 
    previousIndex = -1;
    
    [smartBarScrollView setDocumentView: rightView];
    [rightView setAutoresizingMask: NSViewWidthSizable|NSViewHeightSizable];
    
}

-(void)initSmartBar
{
    NSString *path = [@"~/Library/Application Support/RavenApp/app/app.plist" stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:@"app"] mutableCopy];
    NSInteger count  = [folders count];
    NSInteger x; 
    CGFloat position = 235;
    for (x=0; x<count; x++) {
        NSDictionary *item = [folders objectAtIndex:x];
        NSArray *URL = [[item objectForKey:@"URL"]mutableCopy];
        RASmartBarViewController *smartApp = [[RASmartBarViewController alloc]initWithDelegate:self];  
        smartApp.folderName = [item objectForKey:@"foldername"];
        smartApp.firstURL = [URL objectAtIndex:0];
        smartApp.secondURL = [URL objectAtIndex:1]; 
        smartApp.thirdURL = [URL objectAtIndex:2]; 
        smartApp.fourthURL = [URL objectAtIndex:3];
        [appList addObject:smartApp]; 
        [[appList objectAtIndex:x]view];
        [rightView addSubview:[[appList objectAtIndex:x]view]];
        [[smartApp view]setFrame:NSMakeRect(-7, position, 108, 278)];
        [smartApp retractApp:nil];
        position = position - 52;
        [URL release]; 
        [smartApp release]; 
    }
    [folders release];
}
 
//The method, actually make the sidebar works all together, took me time to find it out.
-(void)itemDidExpand:(RASmartBarViewController *)smartBarApp
{
    NSInteger x; 
    NSInteger index = [appList indexOfObject:smartBarApp]; 
    for (x=0; x<[appList count]; x++) {
        RASmartBarViewController *smartApp = [appList objectAtIndex:x]; 
        NSRect frame = [[smartApp view]frame];
        if (previousIndex == x ) {
            [smartApp retractApp:nil];
        }
        if (x<=index && [smartBarApp state] == 0 && x > previousIndex) {
            [[[smartApp view]animator]setFrame:NSMakeRect(-7, frame.origin.y + 200, 108, 278)]; 
        }
        if (x > index && index <= previousIndex && x <= previousIndex) {
           [[[smartApp view]animator]setFrame:NSMakeRect(-7, frame.origin.y - 200, 108, 278)];   
        }
            
    }
    

    [self hideall]; 
    [self animate:12]; 
    previousIndex = index;
    
}

-(void)updateSmartBarUi
{
    
    
}

-(void)resetSmartBarUi
{
    NSInteger count  = [appList count];
    NSInteger x; 
    CGFloat position = 235;
    for (x=0; x<count; x++) {
         RASmartBarViewController *smartApp = [appList objectAtIndex:x]; 
         [[[smartApp view]animator]setFrame:NSMakeRect(-7, position, 108, 278)];
         [smartApp retractApp:nil];
         position = position - 50;

     }
    previousIndex = -1;
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
        [[smartBarScrollView animator]setAlphaValue:1.0];
        [[rightView  animator]setAlphaValue:1.0];
        [[settingButton animator]setAlphaValue:1.0];
        [NSAnimationContext endGrouping];
        [rightView setToolTip:@""]; 
    
    }
    else{
        [[centeredView animator]setFrame:[mainView bounds]]; 
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.3];  ;
        [[rightView  animator]setAlphaValue:0.0];
        [[settingButton animator]setAlphaValue:0.0];
        if ([standardUserDefaults integerForKey:@"SidebarLikeDock"] == 0)
        {
            [settingButton setHidden:YES];
            [[settingButton animator]setHidden:YES];
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
    //Set the button position
    [self animate:13]; 
    //Set the alpha value
    [self SetMenuButton]; 
    //Select the button
    [self home:sender]; 
    //Set the alphe value of the current button
    [[ravenMenuButton animator]setAlphaValue:1.0]; 
    [self resetSmartBarUi];
}

#pragma mark raven button
//history view
-(IBAction)history:(id)sender
{
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
    [NSThread detachNewThreadSelector:@selector(check:) toTarget:historyviewcontroller withObject:nil];
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
    
            [[homeButton animator]setAlphaValue:0.0]; 
            [homeButton setEnabled:NO];
            [[historyButton animator]setAlphaValue:0.0]; 
            [historyButton setEnabled:NO];
            [[bookmarkButton animator]setAlphaValue:0.0]; 
            [bookmarkButton setEnabled:NO];
            [[downloadButton animator]setAlphaValue:0.0]; 
            [downloadButton setEnabled:NO];
            [[homeButton animator ]setFrame:NSMakeRect(16, 810, 32, 32)]; 
            [[historyButton animator ]setFrame:NSMakeRect(16, 810, 32, 32)];
            [[bookmarkButton animator ]setFrame:NSMakeRect(16, 810, 32, 32)];
            [[downloadButton animator ]setFrame:NSMakeRect(16, 810, 32, 32)];
            
            break;
        case 13:
            [[homeButton animator]setAlphaValue:1.0];
            [homeButton setEnabled:YES];
            [[historyButton animator]setAlphaValue:1.0];
            [historyButton setEnabled:YES];
            [[bookmarkButton animator]setAlphaValue:1.0];
            [bookmarkButton setEnabled:YES];
            [[downloadButton animator]setAlphaValue:1.0];
            [downloadButton setEnabled:YES];
            [[homeButton animator ]setFrame:NSMakeRect(16, 758, 32, 32)];
            [[historyButton animator ]setFrame:NSMakeRect(16, 708, 32, 32)];
            [[bookmarkButton animator ]setFrame:NSMakeRect(16, 658, 32, 32)];
            [[downloadButton animator ]setFrame:NSMakeRect(16, 608, 32, 32)]; 
            default:
            break;
    }
    
}
@end