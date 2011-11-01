//
//  RavenAppDelegate.h
//  Raven
//
//  Created by Thomas Ricouard on 25/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Carbon/Carbon.h>
#import <sqlite3.h>
#import "RAHistoryViewController.h"
#import "RANavigatorViewController.h"
#import "RABookmarkViewController.h"
#import "RADownloadViewController.h"
#import "RASettingViewController.h"
#import "RAItemObject.h"
#import "url.h"
#import "RADatabaseController.h"
#import "RAMainWindowController.h"
#import "RADownloadController.h"
#import "RADownloadObject.h"
#import "RASettingWindowController.h"
#import "RAAboutPanelWindowController.h"

@interface RavenAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSImageDelegate> {
    RASettingWindowController *setting;
    RAAboutPanelWindowController *about; 
    IBOutlet NSMenu *favoriteMenu; 
    NSMutableArray *mainWindowArray; 
    NSString *opennedDocumentPath;
}
//button action
-(IBAction)newWindow:(id)sender;
-(void)newWindowsFromOther:(NSString *)url; 
-(IBAction)showSettingsWindow:(id)sender;
-(IBAction)showAboutPanel:(id)sender;
-(IBAction)favoriteMenu:(id)sender;
-(IBAction)importSelectedApp:(id)sender;
-(IBAction)webAppShop:(id)sender; 
-(IBAction)twitterProfile:(id)sender;
-(IBAction)websiteSupport:(id)sender; 
-(IBAction)officialWebsite:(id)sender;
-(void)importAppAction;
-(void)openAnInternalWindowWithUrl:(NSString *)URL; 
@property (nonatomic, retain) RASettingWindowController *setting; 
@property (nonatomic, retain) NSMutableArray *mainWindowArray;  


@end
