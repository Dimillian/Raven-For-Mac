//
//  RavenAppDelegate.m
//  Raven
//
//  Created by Thomas Ricouard on 25/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RavenAppDelegate.h"

@implementation RavenAppDelegate
@synthesize setting, mainWindowArray; 
#pragma mark -
#pragma mark launch
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    
   // NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
   // for (NSString *key in [defaultsDict allKeys])
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
    DatabaseController *controler = [DatabaseController sharedUser];
    [controler checkAndCreateDatabase];
    [controler vacuum];
    DownloadController *downloadCenter = [DownloadController sharedUser]; 
    [downloadCenter checkAndCreatePlist];
    [downloadCenter writeDownloadInplist]; 
    mainWindowArray = [[NSMutableArray alloc]init]; 
     //NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    //Take care of the default setting
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) 
        {
            //Suggestion address bar
            if ([standardUserDefaults objectForKey:@"SuggestionBar"] == nil) {
                [standardUserDefaults setInteger:1 forKey:@"SuggestionBar"];
            }  
            //Auto select URL on mouse hover
            if ([standardUserDefaults objectForKey:@"AutoSelectUrl"] == nil) {
                [standardUserDefaults setInteger:1 forKey:@"AutoSelectUrl"];
            }  
            //Button tool tip for sidebar
            if ([standardUserDefaults objectForKey:@"ButtonTooltip"] == nil) {
                [standardUserDefaults setInteger:0 forKey:@"ButtonTooltip"];
            }
            //Auto hide sidebar key
            if ([standardUserDefaults objectForKey:@"SidebarLikeDock"] == nil) {
                [standardUserDefaults setInteger:1 forKey:@"SidebarLikeDock"];
            }
            //Set the prefered URL to local page if nil
            if ([standardUserDefaults objectForKey:@"PreferredUrl"] == nil) {
                [standardUserDefaults setObject:@"http://go.raven.io" forKey:@"PreferredUrl"];
            }
            //if nil set the new tab URL to local page
            if ([standardUserDefaults objectForKey:@"NewTabUrl"] == nil) {
                [standardUserDefaults setObject:@"http://go.raven.io" forKey:@"NewTabUrl"];
            }
            //Clear history setting
            if ([standardUserDefaults objectForKey:@"removeHistoryButton"] == nil) {
                [standardUserDefaults setInteger:3 forKey:@"removeHistoryButton"];
            }
            //First Time launch
            if ([standardUserDefaults objectForKey:@"doHaveLaunched"] == nil) {
                [standardUserDefaults setInteger:0 forKey:@"doHaveLaunched"];
            }
            if ([standardUserDefaults objectForKey:@"AutoSaveInstapaper"] == nil){
                [standardUserDefaults setInteger:0 forKey:@"AutoSaveInstapaper"];
            }
            if ([standardUserDefaults objectForKey:@"OpenTabInBackground"] == nil) {
                [standardUserDefaults setInteger:0 forKey:@"OpenTabInBackground"]; 
            }
            [standardUserDefaults synchronize];
            
            //maintenance stuff
            [controler removehistorySinceDate:[standardUserDefaults integerForKey:@"removeHistoryButton"]];
        }
    
    MainWindowController *MainWindow = [[MainWindowController alloc]initWithWindowNibName:@"MainWindow"]; 
    [MainWindow showWindow:self]; 
    
    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    [em 
     setEventHandler:self
     andSelector:@selector(getUrl:withReplyEvent:) 
     forEventClass:kInternetEventClass 
     andEventID:kAEGetURL];
    
    setting = [[SettingWindow alloc]initWithWindowNibName:@"PreferenceWindow"];
    about = [[AboutPanel alloc]initWithWindowNibName:@"AboutPanel"]; 
    appManager = [[RAppManagerWindow alloc]initWithWindowNibName:@"RAappManagerWindow"];
   
        
}


- (void)getUrl:(NSAppleEventDescriptor *)event 
withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{ 
    NSApplication *app = [NSApplication sharedApplication];  
    NSArray *windowsArray = [app windows];
    NSString *urlStr = [[event paramDescriptorForKeyword:keyDirectObject] 
                        stringValue];
    int i;
    int count = [windowsArray count]; 
    for (i = 0; i<count; i++) {
        if ([[[windowsArray objectAtIndex:i]windowController]isKindOfClass:[MainWindowController class]]) {
            MainWindowController *Mainwindow = [[windowsArray objectAtIndex:i]windowController]; 
            [Mainwindow showWindow:self]; 
            [Mainwindow raven:nil]; 
            [[Mainwindow navigatorview]setPassedUrl:urlStr]; 
            [[Mainwindow navigatorview]addtabs:nil]; 
            break; 
        }
    }
    if (i>=count) {
        MainWindowController *MainWindow = [[MainWindowController alloc]initWithWindowNibName:@"MainWindow"]; 
        [MainWindow showWindow:self];  
        [MainWindow raven:nil]; 
        [[MainWindow navigatorview]setPassedUrl:urlStr]; 
        [[MainWindow navigatorview]addtabs:nil]; 
    }
}


-(void)showSettingsWindow:(id)sender
{
    [setting showWindow:self]; 
    
}

-(void)showAboutPanel:(id)sender
{
    [about showWindow:self]; 
}

-(void)showAppManager:(id)sender
{
    [appManager showWindow:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
					hasVisibleWindows:(BOOL)flag
{
    if (flag == NO) {
        MainWindowController *MainWindow = [[MainWindowController alloc]initWithWindowNibName:@"MainWindow"]; 
        [MainWindow showWindow:self];  
    }
    
    return YES; 
}


#pragma mark -
#pragma mark windowAction
//Open a new window
-(void)newWindow:(id)sender
{
    MainWindowController *MainWindow = [[MainWindowController alloc]initWithWindowNibName:@"MainWindow"]; 
    [MainWindow showWindow:self]; 
}
//
-(void)newWindowsFromOther:(NSString *)url
{
    MainWindowController *MainWindow = [[MainWindowController alloc]initWithWindowNibName:@"MainWindow"]; 
    [MainWindow showWindow:self]; 
}

-(void)favoriteMenu:(id)sender
{
    
    int i=0; 
    NSUInteger b; 
    //instancie l'app delegate
    DatabaseController *controller = [DatabaseController sharedUser];
    [controller readBookmarkFromDatabase:0 order:1]; 
    b = controller.bookmarks.count; 
    for (i=0;i<b;i++)
    {
        bookmarkObject *bookmark = (bookmarkObject *)[controller.bookmarks objectAtIndex:i];
        
        
        NSMenuItem *item = [[NSMenuItem alloc]init];
        [item setTarget:self]; 
        [item setTitle:bookmark.title]; 
        [item setRepresentedObject:bookmark.url]; 
        [item setImage:bookmark.favico];
        [item setAction:@selector(gotopage:)];
        [item setEnabled:YES];
        [favoriteMenu addItem:item]; 
        [item release]; 
    }
    MainWindowController *mainWindow = [[sender window]windowController]; 
    [favoriteMenu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *item = [[NSMenuItem alloc]init];
    [item setTarget:mainWindow];
    [item setTitle:@"Edit Favorites"];
    [item setAction:@selector(bookmark:)];
    [item setEnabled:YES]; 
    [favoriteMenu addItem:item]; 
    [item release]; 
    
    
}

- (void)dealloc
{
 
    
    [super dealloc];
}


@end
