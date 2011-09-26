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

#define default_url @"http://go.raven.io"
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
            if ([standardUserDefaults objectForKey:SUGGESTION_BAR] == nil) {
                [standardUserDefaults setInteger:1 forKey:SUGGESTION_BAR];
            }  
            //Auto select URL on mouse hover
            if ([standardUserDefaults objectForKey:SELECT_URL_MOUSE_HOVER] == nil) {
                [standardUserDefaults setInteger:1 forKey:SELECT_URL_MOUSE_HOVER];
            }  
            //Button tool tip for sidebar
            if ([standardUserDefaults objectForKey:BUTTON_TOOLTIP] == nil) {
                [standardUserDefaults setInteger:0 forKey:BUTTON_TOOLTIP];
            }
            //Auto hide sidebar key
            if ([standardUserDefaults objectForKey:SIDEBAR_LIKE_DOCK] == nil) {
                [standardUserDefaults setInteger:1 forKey:SIDEBAR_LIKE_DOCK];
            }
            //Set the prefered URL to local page if nil
            if ([standardUserDefaults objectForKey:PREFERRED_URL] == nil) {
                [standardUserDefaults setObject:default_url forKey:PREFERRED_URL];
            }
            //if nil set the new tab URL to local page
            if ([standardUserDefaults objectForKey:NEW_TAB_URL] == nil) {
                [standardUserDefaults setObject:default_url forKey:NEW_TAB_URL];
            }
            //Clear history setting
            if ([standardUserDefaults objectForKey:REMOVE_HISTORY_BUTTON] == nil) {
                [standardUserDefaults setInteger:3 forKey:REMOVE_HISTORY_BUTTON];
            }
            //First Time launch
            if ([standardUserDefaults objectForKey:DO_HAVE_LAUNCHED] == nil) {
                [standardUserDefaults setInteger:0 forKey:DO_HAVE_LAUNCHED];
            }
            if ([standardUserDefaults objectForKey:AUTO_SAVE_INSTAPAPER] == nil){
                [standardUserDefaults setInteger:0 forKey:AUTO_SAVE_INSTAPAPER];
            }
            if ([standardUserDefaults objectForKey:OPEN_TAB_IN_BACKGROUND] == nil) {
                [standardUserDefaults setInteger:0 forKey:OPEN_TAB_IN_BACKGROUND]; 
            }
            [standardUserDefaults synchronize];
            
            //maintenance stuff
            [controler removehistorySinceDate:[standardUserDefaults integerForKey:REMOVE_HISTORY_BUTTON]];
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

-(void)importSelectedApp:(id)sender
{
    NSOpenPanel *tvarNSOpenPanelObj	= [NSOpenPanel openPanel];
    [tvarNSOpenPanelObj setTitle:@"Please select an application bundle file that have been exported with rSDK"];
    [tvarNSOpenPanelObj setAllowedFileTypes:[NSArray arrayWithObject:@"rpa"]];
    NSInteger tvarNSInteger	= [tvarNSOpenPanelObj runModal];
    if(tvarNSInteger == NSOKButton){
        NSString * tvarDirectory = [[tvarNSOpenPanelObj URL]absoluteString];
        tvarDirectory = [tvarDirectory stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
        [self importAppAthPath:tvarDirectory];
    } else if(tvarNSInteger == NSCancelButton) {
     	
     	return;
    } else {
     	return;
    }  
    

}

-(void)importAppAthPath:(NSString *)path
{
    NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    if (dict == nil) {
        NSAlert *alert  = [[NSAlert alloc]init];
        [alert setInformativeText:NSLocalizedString(@"Please use an application bundle made with this SDK", @"InvalideAppBundleInformative")];
        [alert setMessageText:NSLocalizedString(@"This application bundle is invalide", @"InvalideAppBundleMessage")];
        [alert runModal]; 
        [alert release]; 
    }
    else {
        NSString *appFolder = [dict objectForKey:PLIST_KEY_FOLDER];
        NSString *appPlist = [PLIST_PATH stringByExpandingTildeInPath];
        NSMutableDictionary *dictToEdit = [NSMutableDictionary dictionaryWithContentsOfFile:appPlist];
        NSMutableArray *folders = [[dictToEdit objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
        [folders addObject:dict];
        [dictToEdit setObject:folders forKey:PLIST_KEY_DICTIONNARY];
        [dictToEdit writeToFile:appPlist atomically:YES];
        
        [folders release];
        NSString *applicationSupportPath = [[NSString stringWithFormat:application_support_path@"%@", appFolder]stringByExpandingTildeInPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:path toPath:applicationSupportPath error:nil];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/app.plist", applicationSupportPath] error:nil];
        NSAlert *alert  = [[NSAlert alloc]init];
        [alert setInformativeText:NSLocalizedString(@"You need to create a new window to see it", @"appImportedWithSuccess")];
        [alert setMessageText:NSLocalizedString(@"Application imported with success", @"appImportedWithSuccessMessage")];
        [alert runModal]; 
        [alert release]; 
    }
    
}


-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    opennedDocumentPath = filename;
    [opennedDocumentPath retain];
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setMessageText:NSLocalizedString(@"Do you want to import this application ?", @"prompt")];
    [alert setInformativeText:NSLocalizedString(@"Maybe you already have this application, it can create a duplicate", @"Continue")];
    [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
    //call the alert and check the selected button
    [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    [alert release];
    return YES;
}


- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        [self importAppAthPath:opennedDocumentPath];
        [opennedDocumentPath retain]; 
    }
}


- (void)dealloc
{
 
    
    [super dealloc];
}


@end
