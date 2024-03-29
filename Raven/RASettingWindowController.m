//
//  SettingWindow.m
//  Raven
//
//  Created by thomasricouard on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASettingWindowController.h"

@implementation RASettingWindowController


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [toolbar release]; 
    [tabview release]; 
    [removeHistoryButton release]; 
    [fontlist release]; 
    [fontStandardButton release];
    [instapaperLogin release];
    [instapaperPassword release]; 
    [insta release];
    [isCheckingForInstapaperLogin release]; 

    [super dealloc];
}

-(void)windowWillClose:(NSNotification *)notification
{
    [self autorelease]; 
}

-(void)awakeFromNib
{
 
    //inctaciate the setting 
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [toolbar setDelegate:self]; 
    [tabview setDelegate:self]; 
    [toolbar setSelectedItemIdentifier:@"general"]; 
    //put the setting for preferred url in a var
    //Set the initial window setting
	if (standardUserDefaults) {
        [removeHistoryButton selectItemAtIndex:[standardUserDefaults integerForKey:REMOVE_HISTORY_BUTTON]];
        if ([standardUserDefaults objectForKey:LOGIN_INSTAPAPER] != nil)
        {
            [instapaperLogin setStringValue:[standardUserDefaults stringForKey:LOGIN_INSTAPAPER]];
            EMGenericKeychainItem *key = [EMGenericKeychainItem genericKeychainItemForService:@"raven.instapaper" withUsername:[instapaperLogin stringValue]];
            if (key.password != nil) {
                [instapaperPassword setStringValue:key.password];
            }
        }
        if ([standardUserDefaults objectForKey:FONTFAMILYSTANDARD_WEBVIEW] != nil) {
            fontlist = [[NSMutableArray alloc]
                        initWithArray:[[NSFontManager sharedFontManager]
                                       availableFontFamilies]];
            [fontlist sortUsingSelector:@selector(caseInsensitiveCompare:)];
            [fontStandardButton removeAllItems];
            [fontStandardButton addItemsWithTitles:fontlist];
            [fontlist release];
            [fontStandardButton selectItemWithTitle:[standardUserDefaults objectForKey:FONTFAMILYSTANDARD_WEBVIEW]];
            
        }
        if ([standardUserDefaults objectForKey:FONTFAMILYFIXED_WEBVIEW] != nil) {
            fontlist = [[NSMutableArray alloc]
                        initWithArray:[[NSFontManager sharedFontManager]
                                       availableFontFamilies]];
            [fontlist sortUsingSelector:@selector(caseInsensitiveCompare:)];
            [fontFixedButton removeAllItems];
            [fontFixedButton addItemsWithTitles:fontlist];
            [fontlist release];
            [fontFixedButton selectItemWithTitle:[standardUserDefaults objectForKey:FONTFAMILYFIXED_WEBVIEW]];
        }
    }
    
    //check the default browser
    CFStringRef defaultHandler = LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http");
    NSString *defaultHandlerString  = (NSString *)defaultHandler; 
    if ([defaultHandlerString isEqualToString:@"com.ravenco.raven"]) {
        [ravenAsDefault setStringValue:NSLocalizedString(@"Raven is your default browser", @"RavenIsDefaultBrowser")]; 
        [ravenAsDefault setTextColor:[NSColor blackColor]]; 
        
    }
    else{
        [ravenAsDefault setStringValue:
         NSLocalizedString(@"Raven is not your default browser", @"RavenIsNotDefaultBrowser")];
        [ravenAsDefault setTextColor:[NSColor blackColor]];
    }
    [defaultHandlerString release]; 

    //set the font list
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies];
    [numberOfCookies setStringValue:[NSString stringWithFormat:@"Total number of cookies stored: %d", [cookies count]]];
    
    cookiesWindow = [[RACookieWindowController alloc]init];
    
    
}

-(void)setFirstTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"general"]; 
    [tabview selectTabViewItemAtIndex:0]; 
}

-(void)setSecondTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"apperance"]; 
    [tabview selectTabViewItemAtIndex:1]; 
}

-(void)setThirdTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"Favorite"]; 
    [tabview selectTabViewItemAtIndex:2]; 
}

-(void)setFourTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"smartbar"]; 
   [tabview selectTabViewItemAtIndex:3];  
}

-(void)setFiveTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"security"]; 
    [tabview selectTabViewItemAtIndex:4]; 
}

-(void)setSixTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"privacy"]; 
    [tabview selectTabViewItemAtIndex:5]; 
}

-(void)setSevenTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"advanced"]; 
    [tabview selectTabViewItemAtIndex:6]; 
}

-(void)setEightTab:(id)sender
{
    [toolbar setSelectedItemIdentifier:@"Instapaper"]; 
    [tabview selectTabViewItemAtIndex:7]; 
}

//set raven as default browser
-(void)setAsDefaultBrowser:(id)sender
{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    LSSetDefaultHandlerForURLScheme((CFStringRef)@"http", (CFStringRef)bundleID);
    LSSetDefaultHandlerForURLScheme((CFStringRef)@"https", (CFStringRef)bundleID);
    CFStringRef defaultHandler = LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http");
    NSString *defaultHandlerString  = (NSString *)defaultHandler; 
    if ([defaultHandlerString isEqualToString:@"com.ravenco.raven"]) {
        [ravenAsDefault setStringValue:NSLocalizedString(@"Raven is your default browser", @"RavenIsDefaultBrowser")]; 
        [ravenAsDefault setTextColor:[NSColor blackColor]]; 
        
    }
    else
    {
        [ravenAsDefault setStringValue:
         NSLocalizedString(@"Raven is not your default browser", @"RavenIsNotDefaultBrowser")]; 
        [ravenAsDefault setTextColor:[NSColor blackColor]];
    }
    [defaultHandlerString release]; 
}


-(void)removeHistoryButtonAction:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setInteger:[removeHistoryButton indexOfSelectedItem] forKey:REMOVE_HISTORY_BUTTON];
		[standardUserDefaults synchronize];
	}
}

-(void)deleteAllHistory:(id)sender
{
    RADatabaseController *controller = [RADatabaseController sharedUser]; 
    [controller deleteAllHistory]; 
}

-(void)purgeHistory:(id)sender
{
    RADatabaseController *controller = [RADatabaseController sharedUser]; 
    [controller purgeHistory];  
}

-(void)openCookiesManager:(id)sender
{
    [cookiesWindow showWindow:self];
    [cookiesWindow fetchCookie];
}

-(void)importBookmarkFromSafari:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults integerForKey:HAVE_IMPORTED_FROM_SAFARI] == 1) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:NSLocalizedString(@"It seems that you already have imported your favorites from Safari", @"ImportBookmarkError")];
            [alert setInformativeText:NSLocalizedString(@"You can do it again but you may have duplicate favorites as it will import it again", @"ImportBookmarkDetailError")];
            [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
            [alert addButtonWithTitle:NSLocalizedString(@"No", @"No")];
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                RADatabaseController *controller = [RADatabaseController sharedUser]; 
                [controller importBookmarkFromSafari]; 
                [standardUserDefaults setInteger:1 forKey:HAVE_IMPORTED_FROM_SAFARI];
                [standardUserDefaults synchronize];
            }
            [alert release];

        }
        else
        {
            RADatabaseController *controller = [RADatabaseController sharedUser]; 
            [controller importBookmarkFromSafari]; 
            [standardUserDefaults setInteger:1 forKey:HAVE_IMPORTED_FROM_SAFARI];
            [standardUserDefaults synchronize];
        }
    }
}

-(void)deleteAllBookmarks:(id)sender
{
    RADatabaseController *controller = [RADatabaseController sharedUser]; 
    [controller deleteAllBookmarks]; 
}

-(void)deleteAllFavorites:(id)sender
{
    RADatabaseController *controller = [RADatabaseController sharedUser]; 
    [controller deleteAllFavorites]; 
}

-(void)factorySettings:(id)sender
{
     NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDict allKeys])
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupport = [[NSString stringWithString:@"~/Library/Application Support/RavenApp/app"] stringByExpandingTildeInPath];
    [fileManager removeItemAtPath:applicationSupport error:nil];
    
}

-(void)saveInstapaperCredential:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults){
        [isCheckingForInstapaperLogin startAnimation:self];
        [standardUserDefaults setObject:[instapaperLogin stringValue] forKey:LOGIN_INSTAPAPER]; 
        //[standardUserDefaults setObject:[instapaperPassword stringValue] forKey:@"PasswordInstapaper"];
       EMGenericKeychainItem *item =  [EMGenericKeychainItem addGenericKeychainItemForService:@"raven.instapaper" withUsername:[instapaperLogin stringValue] password:[instapaperPassword stringValue]];
        if (item == nil) {
            EMGenericKeychainItem *item = [EMGenericKeychainItem genericKeychainItemForService:@"raven.instapaper" withUsername:[instapaperLogin stringValue]];
                                           item.username = [instapaperLogin stringValue]; 
                                           item.password = [instapaperPassword stringValue]; 
                                           
        }
            LTInstapaperAPI *instaApi = [[LTInstapaperAPI alloc]initWithUsername:[instapaperLogin stringValue] password:[instapaperPassword stringValue] delegate:self]; 
            insta = instaApi;
            [insta authenticate]; 
            [instaApi release]; 

    }
}

- (void)instapaper:(LTInstapaperAPI *)ip authDidFinishWithCode:(NSUInteger)code {
    // http://www.instapaper.com/api
    if (code == 200) {
        [isCheckingForInstapaperLogin stopAnimation:self];
    } else {
       
            NSAlert *alert = [[NSAlert alloc]init]; 
            [alert setMessageText:NSLocalizedString(@"Wrong username or password", @"instapaperError")];
            [alert setInformativeText:NSLocalizedString(@"Please review your instapaper credentials.", @"InstapaperDetailError")];
            [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Ok")];
            [alert setIcon:[NSImage imageNamed:@"instapaper-big.png"]]; 
            [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
            [alert release];
            [isCheckingForInstapaperLogin stopAnimation:self];
        
    }
}

-(void)createInstapaperAccount:(id)sender
{
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace]; 
    [workspace openURL:[NSURL URLWithString:@"http://instapaper.com"]]; 
    
}

-(void)adblock:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    if (adblockButton.state == 1) {
        [myPreference setUserStyleSheetLocation:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"userContent"
                                                                                                       ofType:@"css"]]];
        [myPreference setUserStyleSheetEnabled:YES]; 
    }
    else{
        [myPreference setUserStyleSheetEnabled:NO];
    }
    [myPreference release]; 
}


-(void)java:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    if (javaButton.state == 1) {
        [myPreference setJavaEnabled:YES];
    }
    else{
        [myPreference setJavaEnabled:NO];
    }
    [myPreference release]; 
}

-(void)javascript:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    if (javascriptButton.state == 1) {
        [myPreference setJavaScriptEnabled:YES];
    }
    else{
        [myPreference setJavaScriptEnabled:NO];
    }
    [myPreference release]; 
}

-(void)plugin:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    if (pluginButton.state == 1) {
        [myPreference setPlugInsEnabled:YES];
    }
    else{
        [myPreference setPlugInsEnabled:NO];
    }
    [myPreference release]; 
}

-(void)popup:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    if (popupButton.state == 1) {
        [myPreference setJavaScriptCanOpenWindowsAutomatically:NO];
    }
    else{
        [myPreference setJavaScriptCanOpenWindowsAutomatically:YES];
    }
    [myPreference release]; 
}

-(void)setFontStandardSize:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    [myPreference setDefaultFontSize:[fontStandardSizeButton selectedTag]];
    [myPreference release];  
}

-(void)setFontStandardStyle:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    [myPreference setStandardFontFamily:fontStandardButton.selectedItem.title];
    [myPreference release]; 
}

-(void)setFontFixedSize:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    [myPreference setDefaultFixedFontSize:[fontFixedSizeButton selectedTag]];
    [myPreference release];  
}

-(void)setFontFixedStyle:(id)sender
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"];
    [myPreference setAutosaves:YES];
    [myPreference setFixedFontFamily:fontFixedButton.selectedItem.title];
    [myPreference release]; 
}
    


@end
