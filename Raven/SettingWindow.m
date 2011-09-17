//
//  SettingWindow.m
//  Raven
//
//  Created by thomasricouard on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingWindow.h"

@implementation SettingWindow


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
    [fontButton release];
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
	if (standardUserDefaults) 
        {
        [removeHistoryButton selectItemAtIndex:[standardUserDefaults integerForKey:@"removeHistoryButton"]];
            if ([standardUserDefaults objectForKey:@"LoginInstapaper"] != nil)
            {
                [instapaperLogin setStringValue:[standardUserDefaults stringForKey:@"LoginInstapaper"]];
                EMGenericKeychainItem *key = [EMGenericKeychainItem genericKeychainItemForService:@"raven.instapaper" withUsername:[instapaperLogin stringValue]];
            if (key.password != nil) {
                [instapaperPassword setStringValue:key.password];
            }
            }
        }
    
    //check the default browser
    CFStringRef defaultHandler = LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http");
    NSString *defaultHandlerString  = (NSString *)defaultHandler; 
    if ([defaultHandlerString isEqualToString:@"com.ravenco.raven"]) {
        [ravenAsDefault setStringValue:@"Raven is your default browser"]; 
        [ravenAsDefault setTextColor:[NSColor blackColor]]; 
        
    }
    else
    {
        [ravenAsDefault setStringValue:@"Raven is not your default browser"]; 
        [ravenAsDefault setTextColor:[NSColor blackColor]];
    }
    [defaultHandlerString release]; 

    //set the font list
    fontlist = [[NSMutableArray alloc]
                initWithArray:[[NSFontManager sharedFontManager]
                                availableFontFamilies]];
    [fontlist sortUsingSelector:@selector(caseInsensitiveCompare:)];
    [fontButton removeAllItems];
    [fontButton addItemsWithTitles:fontlist];
    [fontlist release];
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
        [ravenAsDefault setStringValue:@"Raven is your default browser"]; 
        [ravenAsDefault setTextColor:[NSColor blackColor]]; 
        
    }
    else
    {
        [ravenAsDefault setStringValue:@"Raven is not your default browser"]; 
        [ravenAsDefault setTextColor:[NSColor blackColor]];
    }
    [defaultHandlerString release]; 
}


-(void)removeHistoryButtonAction:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setInteger:[removeHistoryButton indexOfSelectedItem] forKey:@"removeHistoryButton"];
		[standardUserDefaults synchronize];
	}
}

-(void)deleteAllHistory:(id)sender
{
    DatabaseController *controller = [DatabaseController sharedUser]; 
    [controller deleteAllHistory]; 
}

-(void)purgeHistory:(id)sender
{
    DatabaseController *controller = [DatabaseController sharedUser]; 
    [controller purgeHistory];  
}

-(void)importBookmarkFromSafari:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults integerForKey:@"HaveImportedSafariBar"] == 1) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:NSLocalizedString(@"It seems that you already have imported your favorites from Safari", @"ImportBookmarkError")];
            [alert setInformativeText:NSLocalizedString(@"You can do it again but you may have duplicate favorites as it will import it again", @"ImportBookmarkDetailError")];
            [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
            [alert addButtonWithTitle:NSLocalizedString(@"No", @"No")];
            if ([alert runModal] == NSAlertFirstButtonReturn)
            {
                DatabaseController *controller = [DatabaseController sharedUser]; 
                [controller importBookmarkFromSafari]; 
                [standardUserDefaults setInteger:1 forKey:@"HaveImportedSafariBar"];
                [standardUserDefaults synchronize];
            }
            [alert release];

        }
        else
        {
            DatabaseController *controller = [DatabaseController sharedUser]; 
            [controller importBookmarkFromSafari]; 
            [standardUserDefaults setInteger:1 forKey:@"HaveImportedSafariBar"];
            [standardUserDefaults synchronize];
        }
    }
}

-(void)deleteAllBookmarks:(id)sender
{
    DatabaseController *controller = [DatabaseController sharedUser]; 
    [controller deleteAllBookmarks]; 
}

-(void)deleteAllFavorites:(id)sender
{
    DatabaseController *controller = [DatabaseController sharedUser]; 
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
        [standardUserDefaults setObject:[instapaperLogin stringValue] forKey:@"LoginInstapaper"]; 
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

@end
