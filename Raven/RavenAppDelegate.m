//
//  RavenAppDelegate.m
//  Raven
//
//  Created by Thomas Ricouard on 25/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RavenAppDelegate.h"
#import "RAlistManager.h"

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
    //[downloadCenter writeDownloadInplist]; 
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
            //enable web inspector for webview, we are a browser afterall
            if  ([standardUserDefaults objectForKey:@"WebKitDeveloperExtras"] == nil){
                [standardUserDefaults setInteger:1 forKey:@"WebKitDeveloperExtras"];
            }
                
            [standardUserDefaults synchronize];
            
            //maintenance stuff for database
            [controler removehistorySinceDate:[standardUserDefaults integerForKey:REMOVE_HISTORY_BUTTON]];
            
            //update process, might create a standard default after beta period
            RAlistManager *listManager = [[RAlistManager alloc]init]; 
            [listManager updateProcess]; 
            [listManager release]; 
        }
    
    MainWindowController *MainWindow = [[MainWindowController alloc]initWithWindowNibName:@"MainWindow"]; 
    [MainWindow showWindow:self]; 
    
    //init the event that will intercept external URL
    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    [em 
     setEventHandler:self
     andSelector:@selector(getUrl:withReplyEvent:) 
     forEventClass:kInternetEventClass 
     andEventID:kAEGetURL];
    
    //instanciate about and setting window
    setting = [[SettingWindow alloc]initWithWindowNibName:@"PreferenceWindow"];
    about = [[AboutPanel alloc]initWithWindowNibName:@"AboutPanel"]; 
   
        
}

//Fired when external URL is clicked
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


//Fired when clicked the on the dock icon
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

//Later, to be used for a top menu favorite menu
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
//Method that fire the file browser to select an app to import
-(void)importSelectedApp:(id)sender
{
    NSOpenPanel *tvarNSOpenPanelObj	= [NSOpenPanel openPanel];
    [tvarNSOpenPanelObj setTitle:@"Please select a Raven Smart Bar Application .sba file"];
    [tvarNSOpenPanelObj setAllowedFileTypes:[NSArray arrayWithObjects:@"rpa", @"sba", nil]];
    NSInteger tvarNSInteger	= [tvarNSOpenPanelObj runModal];
    if(tvarNSInteger == NSOKButton){
        NSString * tvarDirectory = [[tvarNSOpenPanelObj URL]absoluteString];
        tvarDirectory = [tvarDirectory stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
        opennedDocumentPath = tvarDirectory;
        [opennedDocumentPath retain];
        [self importAppAction];
    } else if(tvarNSInteger == NSCancelButton) {
     	
     	return;
    } else {
     	return;
    }  
    

}

//Import an if user agree
-(void)importAppAction
{
    RAlistManager *listManager = [[RAlistManager alloc]init];
    BOOL success =  [listManager checkifAppIsValide:opennedDocumentPath];
    if (success) {
        NSAlert *alert = [[NSAlert alloc]init];
        NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", opennedDocumentPath];
        NSDictionary*dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
        NSString *appname = [NSString stringWithFormat:@"Would you like to install this web app? \n       %@",[dict objectForKey:PLIST_KEY_APPNAME]];
        [alert setMessageText:appname];
        [alert setInformativeText:NSLocalizedString(@"If you already have this installed both will display in Smart Bar.", @"importPromptContinue")];
        NSImage *icon = [[NSImage alloc]initWithContentsOfFile:
                         [NSString stringWithFormat:@"%@/main.png", opennedDocumentPath]];
        [alert setIcon:icon];
        [icon release];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        //call the alert and check the selected button
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        [alert release];
    }
    [listManager release]; 
 
}


//fired when double clicked on .rpa file
-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    if ([filename hasSuffix:@".rpa"] || [filename hasSuffix:@".sba"]) {
        opennedDocumentPath = filename;
        [opennedDocumentPath retain];
        [self importAppAction];
           return YES;
    }
    else
    {
        return NO;
    }
}

//if sheet is ok and app is valid then install
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        RAlistManager *listManager = [[RAlistManager alloc]init]; 
        [listManager importAppAthPath:opennedDocumentPath]; 
        [listManager release]; 
    
        
    }
}





- (void)dealloc
{
 
    
    [super dealloc];
}


@end
