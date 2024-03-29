//
//  SettingWindow.h
//  Raven
//
//  Created by thomasricouard on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "RADatabaseController.h"
#import "LTInstapaperAPI.h"
#import "EMKeychainItem.h"
#import "RACookieWindowController.h"
#import <WebKit/WebKit.h>

@interface RASettingWindowController : NSWindowController <NSWindowDelegate, NSToolbarDelegate, NSTabViewDelegate, LTInstapaperAPIDelegate>
{
    IBOutlet NSToolbar *toolbar; 
    IBOutlet NSTabView *tabview; 
    IBOutlet NSPopUpButton *removeHistoryButton;
    IBOutlet NSPopUpButton *fontStandardButton; 
    IBOutlet NSPopUpButton *fontStandardSizeButton; 
    IBOutlet NSPopUpButton *fontFixedButton; 
    IBOutlet NSPopUpButton *fontFixedSizeButton; 
    NSMutableArray *fontlist; 
    IBOutlet NSTextField *instapaperLogin; 
    IBOutlet NSTextField *instapaperPassword; 
    IBOutlet NSProgressIndicator *isCheckingForInstapaperLogin; 
    IBOutlet NSTextField *ravenAsDefault; 
    IBOutlet NSTextField *numberOfCookies; 
    IBOutlet NSButton *adblockButton;
    IBOutlet NSButton *javascriptButton; 
    IBOutlet NSButton *javaButton; 
    IBOutlet NSButton *pluginButton; 
    IBOutlet NSButton *popupButton; 
    LTInstapaperAPI *insta; 
    RACookieWindowController *cookiesWindow;

}


-(IBAction)deleteAllHistory:(id)sender;
-(IBAction)setFirstTab:(id)sender;
-(IBAction)setSecondTab:(id)sender; 
-(IBAction)setThirdTab:(id)sender; 
-(IBAction)setFourTab:(id)sender; 
-(IBAction)setFiveTab:(id)sender; 
-(IBAction)setSixTab:(id)sender; 
-(IBAction)setSevenTab:(id)sender;
-(IBAction)setEightTab:(id)sender;
-(IBAction)purgeHistory:(id)sender;
-(IBAction)removeHistoryButtonAction:(id)sender; 
-(IBAction)importBookmarkFromSafari:(id)sender;
-(IBAction)factorySettings:(id)sender;
-(IBAction)deleteAllBookmarks:(id)sender;
-(IBAction)deleteAllFavorites:(id)sender;
-(IBAction)saveInstapaperCredential:(id)sender;
-(IBAction)createInstapaperAccount:(id)sender;
-(IBAction)setAsDefaultBrowser:(id)sender;
-(IBAction)openCookiesManager:(id)sender; 
-(IBAction)adblock:(id)sender; 
-(IBAction)setFontStandardSize:(id)sender;
-(IBAction)setFontStandardStyle:(id)sender;
-(IBAction)setFontFixedSize:(id)sender;
-(IBAction)setFontFixedStyle:(id)sender;
-(IBAction)javascript:(id)sender; 
-(IBAction)java:(id)sender;
-(IBAction)plugin:(id)sender;
-(IBAction)popup:(id)sender;
@end
