//
//  WebViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 22/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RAItemObject.h"
#import "RADatabaseController.h"
#import "RADownloadController.h"
#import "RADownloadObject.h"
#import "RAMainWebView.h"
#import "RAFavoritePanelWController.h"
#import "RANSURLDownloadDelegate.h"
#import "RAAddressFieldBox.h"
#import "RATabButton.h"
#import "RATabView.h"
 
@class RAAdressTextField, RAMainWindowController, RavenAppDelegate; 

@protocol RAWebViewControllerDelegate;
@interface RAWebViewController : NSViewController <NSMenuDelegate, NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource, RAFavoritePanelControllerDelegate>{
    id<RAWebViewControllerDelegate> delegate;
    
    //MainView outlet 
    IBOutlet NSView *mainView; 
    IBOutlet NSView *switchView; 
    IBOutlet RAAdressTextField *address; 
    IBOutlet RAMainWebView *webview; 
    IBOutlet NSProgressIndicator *progress;
    IBOutlet NSButton *mobileButton; 
    IBOutlet NSButton *stopLoading; 
    IBOutlet NSImageView *temp; 
    IBOutlet NSButton *tabsButton; 
    IBOutlet NSButton *secondTabButton;
    IBOutlet NSProgressIndicator *progressMain; 
    IBOutlet NSMenu *webviewMenu;
    IBOutlet NSButton *backButton; 
    IBOutlet NSButton *forwardButton; 
    IBOutlet NSSearchField *searchWebView; 
    IBOutlet NSTextField *searchResults; 
    IBOutlet RAAddressFieldBox *addressBox; 
    IBOutlet NSView *addressBarView;
    
    RATabView *_tabView;  
    
    BOOL _newTab; 
    BOOL _internal; 
    NSString *UA; 
    NSInteger count; 
    NSImage *_favicon; 

    NSMutableArray *fPanelArray; 
    
    int doRegisterHistory;
    int doComeFromHistoryOrBookmark;    
}
-(id)initWithDelegate:(id<RAWebViewControllerDelegate>)dgate;

//Bouton action method
-(IBAction)go:(id)sender; 
-(IBAction)mobile:(id)sender;
-(IBAction)addbookmark:(id)sender; 
-(IBAction)home:(id)sender; 
-(IBAction)favoriteMenu:(id)sender; 
-(IBAction)gotopage:(id)sender;
-(IBAction)doASearchOnWebView:(id)sender; 
-(IBAction)enableSearch:(id)sender; 
-(IBAction)executeJSScript:(id)sender;

-(IBAction)addTabButtonClicked:(id)sender; 

//Other method
-(void)setMenu;
-(NSMenu *)getFavoriteMenu; 

-(void)loadWithUrl:(NSString *)url;
-(void)loadWithPreferredUrl;
-(void)loadInternalPage:(NSString *)page; 

-(void)checkua; 
-(void)setWindowTitle:(id)sender; 
-(id)infoValueForKey:(NSString*)key;
-(void)setMobileUserAgent;
-(void)setDesktopUserAgent; 
-(void)downloadFavicon:(id)sender; 
-(void)updateFaviconUI:(id)sender; 
-(void)saveHistory:(id)sender;

//internal
-(void)setWebViewBackground;

//Properties
@property (nonatomic, assign) id<RAWebViewControllerDelegate> delegate;
@property (nonatomic, retain) NSSearchField *searchWebView;
@property (nonatomic, retain) NSView *switchView;
@property (nonatomic, retain) NSView *addressBarView;
@property (nonatomic, retain) NSButton *secondTabButton; 
@property (nonatomic, retain) WebView *webview; 
@property (nonatomic, retain) NSTextField *address;
@property (nonatomic, retain) NSImage *favicon; 
@property (nonatomic, retain) NSButton *tabsButton;
@property (nonatomic, retain) RATabView *tabView; 
@property int doRegisterHistory;
@property (nonatomic, getter=isNewTab) BOOL newTab;
@property (nonatomic, getter=isInternal) BOOL internal; 
@end

//delegate
@protocol RAWebViewControllerDelegate
@required
-(void)webViewshouldCreateNewTab:(RAWebViewController *)RAWebView; 
@end
