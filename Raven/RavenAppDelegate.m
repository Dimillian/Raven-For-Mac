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
#define store_url @"http://start.raven.io"
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    RADatabaseController *controler = [RADatabaseController sharedUser];
    [controler checkAndCreateDatabase];
    [controler vacuum];
    RADownloadController *downloadCenter = [[RADownloadController alloc]init]; 
    [downloadCenter checkAndCreatePlist];
    [downloadCenter release];
    growlDispatcher = [[RAGrowlDispatcher alloc]init];
    mainWindowArray = [[NSMutableArray alloc]init]; 
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
                [standardUserDefaults setObject:store_url forKey:PREFERRED_URL];
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
            if ([standardUserDefaults objectForKey:OPPENED_TABS_BADGE] == nil) {
                [standardUserDefaults setInteger:1 forKey:OPPENED_TABS_BADGE]; 
            }
            if ([standardUserDefaults objectForKey:SHOW_FAVICON_TAB] == nil) {
                [standardUserDefaults setInteger:1 forKey:SHOW_FAVICON_TAB]; 
            }
            if ([standardUserDefaults objectForKey:ADBLOCK_CSS] == nil) {
                [standardUserDefaults setInteger:0 forKey:ADBLOCK_CSS]; 
            }
            //We use this key to define default webpreference setting
            if ([standardUserDefaults objectForKey:JAVA_WEBVIEW] == nil) {
                [standardUserDefaults setInteger:1 forKey:JAVA_WEBVIEW]; 
                WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
                [myPreference setDefaultFontSize:16];
                [myPreference setDefaultFixedFontSize:13];
                [myPreference setSerifFontFamily:@"Times"];
                [myPreference setSansSerifFontFamily:@"Helvetica"];
                [myPreference setStandardFontFamily:@"Times"]; 
                [myPreference setFixedFontFamily:@"Courier"];
                [myPreference setUserStyleSheetEnabled:NO];
                [myPreference setJavaEnabled:YES];
                [myPreference setJavaScriptEnabled:YES];
                [myPreference setPlugInsEnabled:YES];
                [myPreference setUsesPageCache:NO];
                [myPreference setJavaScriptCanOpenWindowsAutomatically:NO];
                [myPreference setAutosaves:YES];
                [myPreference release];

            }
            if ([standardUserDefaults objectForKey:JAVASCRIPT_WEBVIEW] == nil) {
                [standardUserDefaults setInteger:1 forKey:JAVASCRIPT_WEBVIEW]; 
            }
            if ([standardUserDefaults objectForKey:PLUGIN_WEBVIEW] == nil) {
                [standardUserDefaults setInteger:1 forKey:PLUGIN_WEBVIEW]; 
            }
            if ([standardUserDefaults objectForKey:BLOCKPOPUP_WEBVIEW] == nil) {
                [standardUserDefaults setInteger:1 forKey:BLOCKPOPUP_WEBVIEW]; 
            }
            if ([standardUserDefaults objectForKey:FONTSIZESTANDARD_WEBVIEW] == nil) {
                [standardUserDefaults setInteger:3 forKey:FONTSIZESTANDARD_WEBVIEW]; 
            }
            if ([standardUserDefaults objectForKey:FONTFAMILYSTANDARD_WEBVIEW] == nil) {
                [standardUserDefaults setObject:@"Times" forKey:FONTFAMILYSTANDARD_WEBVIEW]; 
            }
            if ([standardUserDefaults objectForKey:FONTSIZEFIXED_WEBVIEW] == nil) {
                [standardUserDefaults setInteger:0 forKey:FONTSIZEFIXED_WEBVIEW]; 
            }
            if ([standardUserDefaults objectForKey:FONTFAMILYFIXED_WEBVIEW] == nil) {
                [standardUserDefaults setObject:@"Courier" forKey:FONTFAMILYFIXED_WEBVIEW]; 
            }
            //enable web inspector for webview, we are a browser afterall
            if  ([standardUserDefaults objectForKey:@"WebKitDeveloperExtras"] == nil){
                [standardUserDefaults setInteger:1 forKey:@"WebKitDeveloperExtras"];
            }
            
                
            [standardUserDefaults synchronize];
            
            //maintenance stuff for database
            [controler removehistorySinceDate:[standardUserDefaults integerForKey:REMOVE_HISTORY_BUTTON]];
            
            //update process, might create a standard default after beta period
            RAlistManager *listManager = [RAlistManager sharedUser]; 
            [listManager updateProcess]; 
        }
    GreaseKit = [[CMController alloc]init];
    [self openAndShowANewWindow];   
    //init the event that will intercept external URL
    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    [em 
     setEventHandler:self
     andSelector:@selector(getUrl:withReplyEvent:) 
     forEventClass:kInternetEventClass 
     andEventID:kAEGetURL];
    
    //instanciate about and setting window
    setting = [[RASettingWindowController alloc]initWithWindowNibName:@"PreferenceWindow"];
    about = [[RAAboutPanelWindowController alloc]initWithWindowNibName:@"RAAboutPanelWindowController"]; 
   
        
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    RAlistManager *listManager = [RAlistManager sharedUser]; 
    [listManager writeNewAppListInMemory:nil writeToFile:YES]; 
}

-(NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    return sender.menu; 
}
//Fired when external URL is clicked
- (void)getUrl:(NSAppleEventDescriptor *)event 
withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{ 

    [self openAnInternalWindowWithUrl:[[event paramDescriptorForKeyword:keyDirectObject] 
                                       stringValue]];
}



-(void)showSettingsWindow:(id)sender
{
    [setting showWindow:self]; 
    
}

-(void)showAboutPanel:(id)sender
{
    [about showWindow:self]; 
}

-(void)webAppShop:(id)sender
{
    [self openAnInternalWindowWithUrl:@"http://start.raven.io"];
}

-(void)twitterProfile:(id)sender
{
    [self openAnInternalWindowWithUrl:@"http://twitter.com/ravenbrowser"];
}

-(void)officialWebsite:(id)sender
{
    [self openAnInternalWindowWithUrl:@"http://raven.io"];
}

-(void)websiteSupport:(id)sender
{
    [self openAnInternalWindowWithUrl:@"http://raven.io/support.html"];   
}

-(void)openAnInternalWindowWithUrl:(NSString *)URL
{
    
    NSApplication *app = [NSApplication sharedApplication];  
    NSArray *windowsArray = [app windows];
    int i;
    int count = [windowsArray count]; 
    for (i = 0; i<count; i++) {
        if ([[[windowsArray objectAtIndex:i]windowController]isKindOfClass:[RAMainWindowController class]]) {
            RAMainWindowController *Mainwindow = [[windowsArray objectAtIndex:i]windowController]; 
            [Mainwindow showWindow:self]; 
            [Mainwindow raven:nil]; 
            [[Mainwindow navigatorview]setPassedUrl:URL]; 
            [[Mainwindow navigatorview]addtabs:Mainwindow]; 
            break; 
        }
    }
    if (i>=count) {
        RAMainWindowController *MainWindow =  [self openAndShowANewWindow];        
        [MainWindow raven:nil]; 
        [[MainWindow navigatorview]setPassedUrl:URL]; 
        [[MainWindow navigatorview]addtabs:MainWindow]; 
        [MainWindow.navigatorview closeFirtTab]; 
    }

}



//Fired when clicked the on the dock icon
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
					hasVisibleWindows:(BOOL)flag
{
    if (flag == NO) {
        [self openAndShowANewWindow];   
    }
    
    return YES; 
}


#pragma mark -
#pragma mark windowAction
//Open a new window
-(void)newWindow:(id)sender
{
    [self openAndShowANewWindow];
}
//
-(void)newWindowsFromOther:(NSString *)url
{
    [self openAndShowANewWindow];
}


-(RAMainWindowController *)openAndShowANewWindow
{
    RAMainWindowController *MainWindow = [[RAMainWindowController alloc]initWithWindowNibName:@"MainWindow"];
    [MainWindow setDelegate:self];
    [MainWindow showWindow:self];
    [mainWindowArray addObject:MainWindow];
    int x = [mainWindowArray indexOfObject:MainWindow];
    [MainWindow release]; 
    return [mainWindowArray objectAtIndex:x]; 
}

-(void)closeButtonClicked:(RAMainWindowController *)thisWindow
{
    [mainWindowArray removeObject:thisWindow];
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
    RAlistManager *listManager = [RAlistManager sharedUser];
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
    if([filename hasPrefix:@".html"]){
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
        RAlistManager *listManager = [RAlistManager sharedUser];
        [listManager importAppAthPath:opennedDocumentPath];
    
        
    }
}





- (void)dealloc
{
 
    
    [super dealloc];
}


@end
