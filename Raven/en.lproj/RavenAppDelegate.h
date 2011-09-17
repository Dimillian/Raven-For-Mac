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
#import "HistoryViewController.h"
#import "NavigatorViewController.h"
#import "BookmarkViewController.h"
#import "DownloadViewController.h"
#import "SettingViewController.h"
#import "bookmarkObject.h"
#import "url.h"
#import "DatabaseController.h"
#import "MainWindowController.h"
#import "DownloadController.h"
#import "DownloadObject.h"
#import "SettingWindow.h"
#import "AboutPanel.h"
#import "RAppManagerWindow.h"

@interface RavenAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSImageDelegate> {
    SettingWindow *setting;
    AboutPanel *about; 
    RAppManagerWindow *appManager;
    IBOutlet NSMenu *favoriteMenu; 
    NSMutableArray *mainWindowArray; 
}
//button action
-(IBAction)newWindow:(id)sender;
-(void)newWindowsFromOther:(NSString *)url; 
-(IBAction)showSettingsWindow:(id)sender;
-(IBAction)showAboutPanel:(id)sender;
-(IBAction)favoriteMenu:(id)sender;
-(IBAction)showAppManager:(id)sender;
@property (nonatomic, retain) SettingWindow *setting; 
@property (nonatomic, retain) NSMutableArray *mainWindowArray;  


@end
