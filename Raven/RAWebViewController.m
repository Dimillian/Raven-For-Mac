//
//  WebViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 22/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAWebViewController.h"
#import "RavenAppDelegate.h"
#import "RAMainWindowController.h"
#import "NSString+Raven.h"
#import "RAHiddenWindow.h"
#import "WebView+search.h"
#import "LWVClipView.h"


#define GOOGLE_SEARCH_URL @"http://www.google.com/search?q="
#define YANDEX_SEARCH_URL @"http://yandex.com/yandsearch?text="
#define FAVICON_URL @"http://s2.googleusercontent.com/s2/favicons?domain=%@"
#define FAVICON_PATH @"~/Library/Application Support/RavenApp/favicon/%@"

@implementation RAWebViewController
@synthesize passedUrl, switchView, tabsButton, webview, address, tabview, searchWebView; 
@synthesize tabButtonTab, pageTitleTab, faviconTab, closeButtonTab, progressTab, doRegisterHistory, isNewTab, secondTabButton, addressBarView, boxTab, tabHolder, delegate; 

#pragma -
#pragma mark init
-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"NavigatorNoBottom" bundle:nil];
    }
    
    return self; 
}

-(id)initWithDelegate:(id<RAWebViewControllerDelegate>)dgate
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"NavigatorNoBottom" bundle:nil]; 
        self.delegate = dgate;
    }
    
    return self;  
}

-(void)setMenu
{
    NSMenu *topMenu = [NSApp menu]; 
    [webviewMenu setTitle:@"View"]; 
    NSMenu *favortieMenu = [self getFavoriteMenu]; 
    [favortieMenu setTitle:@"Favorites"]; 
    [topMenu setSubmenu:webviewMenu forItem:[topMenu itemAtIndex:3]]; 
    [topMenu setSubmenu:favortieMenu forItem:[topMenu itemAtIndex:6]];
    //[NSApp setMenu:topMenu]; 
}
-(void)awakeFromNib
{  
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"]; 
    [myPreference setUsesPageCache:NO]; 
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) 
    {
        if ([standardUserDefaults integerForKey:ADBLOCK_CSS] == 1) {
            [myPreference setUserStyleSheetLocation:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"userContent"
                                                                                                 ofType:@"css"]]];
            [myPreference setUserStyleSheetEnabled:YES]; 
        }
        else
        {
            [myPreference setUserStyleSheetEnabled:NO]; 
        }
    }
    
    [self setDesktopUserAgent];
    //register history item
    [self setDoRegisterHistory:2];
    //Hide the stop loading button
    [stopLoading setHidden:YES];
    [webview setContinuousSpellCheckingEnabled:YES]; 
    //Setup the delegate of the webview
    RANSURLDownloadDelegate *downloadDL = [[RANSURLDownloadDelegate alloc]init]; 
    [webview setDownloadDelegate:downloadDL]; 
    [webview setShouldCloseWithWindow:YES]; 
    [address setDelegate:self]; 
    [webview setUIDelegate:self];
    [webview setResourceLoadDelegate:self]; 
    [webview setFrameLoadDelegate:self]; 
    [webview setPolicyDelegate:self]; 
    [webview setPreferences:myPreference]; 
    [[webview preferences]setDefaultFontSize:16];
    [webview setMaintainsBackForwardList:YES]; 
    NSImage *homeicon = [NSImage imageNamed:@"welcome-favicon.png"]; 
    
    [temp setImage:homeicon];     
    [tabButtonTab setToolTip:[self title]]; 
    
    [myPreference release]; 
    isNewTab = YES; 
    
    [progressMain setMinValue:0.0]; 
    [progressMain setMaxValue:1.0]; 
    [searchWebView setHidden:YES];
    
    if (IS_RUNNING_LION) {
        id webDocView = [[[self.webview mainFrame] frameView] documentView];
        NSScrollView *detailWebScrollView = (NSScrollView *)[[webDocView superview] superview];
        LWVWebClipView *webClipView = [[LWVWebClipView alloc] initWithFrame:[[detailWebScrollView contentView] frame]];
        [detailWebScrollView setContentView:webClipView];
        [detailWebScrollView setDocumentView:webDocView];
        [webClipView release];
     }
    
    
    [tabview setAlphaValue:0.0]; 
    [pageTitleTab setStringValue:NSLocalizedString(@"New tab", @"NewTab")];
    [progressTab setHidden:YES];
    [faviconTab setHidden:YES];
     
}

-(id)infoValueForKey:(NSString*)key
{ 
    if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
        return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}


-(void)initWithUrl:(NSString *)url
{
    //load the lading home page
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}

-(void)initWithWelcomePage
{
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:indexPath]]]; 
    
}

-(void)initWithHistoryPage
{
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"history" ofType:@"html"];
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:indexPath]]];   
}

-(void)initWithBookmarkPage
{
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"Bookmarks" ofType:@"html"];
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:indexPath]]]; 
}

-(void)initwithFavoritePage
{
    
}

-(void)initWithFirstTimeLaunchPage
{
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"Start" ofType:@"html"];
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:indexPath]]]; 
}
-(void)initWithPreferredUrl
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) 
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[standardUserDefaults objectForKey:@"NewTabUrl"]]]];
}

-(void)checkua
{
    
    //Check if the UA and change the windows size
    if ([UA isEqualToString:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543 Safari/419.3"]) {
        
    }
    else
    {
        
    }

}

#pragma mark -
#pragma mark Tab
-(IBAction)tabsButtonClicked:(id)sender{
    [delegate tabDidSelect:self];
}

-(IBAction)closeButtonTabClicked:(id)sender{
    [delegate tabWillClose:self];
    
}

#pragma mark -
#pragma mark action
-(IBAction)enableSearch:(id)sender
{
    if ([searchWebView isHidden]) {
        [searchWebView setHidden:NO];
        [searchWebView selectText:self];
    }
    else{
        [searchWebView setHidden:YES];
        [webview removeAllHighlights];
        [searchResults setStringValue:@""];
    }
}

-(IBAction)executeJSScript:(id)sender
{

}

-(IBAction)doASearchOnWebView:(id)sender
{
    if (![[searchWebView stringValue]isEqualToString:@""]) {
        NSInteger results = [webview highlightAllOccurencesOfString:[searchWebView stringValue]];
        [searchResults setStringValue:[NSString stringWithFormat:@"%d results", results]];
        
    }
    else{
        [webview removeAllHighlights];
        [searchResults setStringValue:@""];
    }
}

//Enter pressed in address field
-(IBAction)go:(id)sender
{
    //cool workflow to check if user put http:// or not and put it if not
    
    NSString *addressTo = [address stringValue];
    addressTo = [addressTo stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if (addressTo != nil) {
            if ([addressTo hasPrefix:@"javascript:"]) {
                [webview stringByEvaluatingJavaScriptFromString:addressTo]; 
                }
                else
                {
                    if ([addressTo hasPrefix:@"http://"] || [addressTo hasPrefix:@"https://"])
                    {
                        [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:addressTo]]];
                    }
                    
                    else
                    {
                        NSString *parsedAdress = [NSString stringWithFormat:@"http://%@", addressTo];
                        [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:parsedAdress]]];
        
                    }
                }
        }
    
}

-(void)addbookmark:(id)sender
{
    RAFavoritePanelWController *favoritePanel = [[RAFavoritePanelWController alloc]init];
    [favoritePanel setTempURL:[webview mainFrameURL]]; 
    [favoritePanel setTempTitle:[webview mainFrameTitle]]; 
    [favoritePanel setTempFavico:favicon]; 
    [favoritePanel setState:1];
    [favoritePanel setType:0];
    [NSApp beginSheet:[favoritePanel window] modalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:NULL contextInfo:nil];
    //[NSApp runModalForWindow:[favoritePanel window]];
    
}

-(void)gotopage:(id)sender
{
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[sender representedObject]]]];
    
}

-(void)favoriteMenu:(id)sender
{
    //[webview highlightAllOccurencesOfString:@"google"];
    NSMenu *menu = [self getFavoriteMenu];
    NSRect frame = [(NSButton *)sender frame];
    NSPoint menuOrigin = [[(NSButton *)sender superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y+frame.size.height-25)
                                                               toView:nil];
    
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:menuOrigin
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:0
                                     windowNumber:[[(NSButton *)sender window] windowNumber]
                                          context:[[(NSButton *)sender window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1]; 
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:(NSButton *)sender];
    
}

-(NSMenu *)getFavoriteMenu
{
    int i=0; 
    NSUInteger b; 
    NSMenu *menu = [[NSMenu alloc]init]; 
    //instancie l'app delegate
    RADatabaseController *controller = [RADatabaseController sharedUser];
    [controller readBookmarkFromDatabase:0 order:1]; 
    b = controller.bookmarks.count; 
    for (i=0;i<b;i++)
    {
        RAItemObject *bookmark = (RAItemObject *)[controller.bookmarks objectAtIndex:i];
        
        
        NSMenuItem *item = [[NSMenuItem alloc]init];
        [item setTarget:self]; 
        bookmark.title = [bookmark.title stringByPaddingToLength:35 withString:@" " startingAtIndex:0];
        [item setTitle:bookmark.title]; 
        [item setRepresentedObject:bookmark.url]; 
        [item setImage:bookmark.favico];
        [item setAction:@selector(gotopage:)];
        [item setEnabled:YES];
        [menu addItem:item]; 
        [item release]; 
    }
    RAMainWindowController *mainWindow = [[NSApp keyWindow]windowController]; 
    [menu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *item = [[NSMenuItem alloc]init];
    [item setTarget:mainWindow];
    [item setTitle:@"Edit Favorites"];
    [item setAction:@selector(bookmark:)];
    [item setEnabled:YES]; 
    [menu addItem:item]; 
    [item release]; 
    
    return [menu autorelease]; 
}
//mobile button, change the UA and the window sier
-(void)mobile:(id)sender
{
    //Instanciate the app delegate
    //Check if the UA is already mobile, and change it back to desktop
    if ([UA isEqualToString:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A5302b Safari/7534.48.3"]) {
        [self setDesktopUserAgent];
        //set the mobile button to a new image
        NSImage *iphone = [NSImage imageNamed:@"narrow_off.png"]; 
        [mobileButton setImage:iphone];
        //resize the window
        //[[sender window] setContentSize:NSMakeSize(1152,772)];
        
    }
    else
    {
        [self setMobileUserAgent];
        //set the mobile button to a new image
        NSImage *display = [NSImage imageNamed:@"wide.png"]; 
        [mobileButton setImage:display]; 
        //resize the window
        //[[sender window]setContentSize:NSMakeSize(400,558)];
        
    }
    
    
    [UA retain]; 
    [webview reload:self]; 
    
}

-(void)setDesktopUserAgent
{
    NSString *versionString;
    NSDictionary * sv = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    versionString = [sv objectForKey:@"ProductVersion"];
    NSDictionary *safariVersion = [NSDictionary dictionaryWithContentsOfFile:@"/Applications/Safari.app/Contents/info.plist"];
    NSString *safariVersionShort = [safariVersion objectForKey:@"CFBundleShortVersionString"];
    NSString *safariVersionLong = [safariVersion objectForKey:@"CFBundleVersion"];
    NSString *appversion = [self infoValueForKey:@"CFBundleVersion"];
    NSDictionary * wv = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/Frameworks/WebKit.framework/Versions/A/Resources/Info.plist"];
    NSString *webkitVerion = [wv objectForKey:@"CFBundleVersion"];
    //Safari string Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_1) AppleWebKit/534.51.5 (KHTML, like Gecko) Version/5.1 Safari/534.51.3
    UA = [NSString stringWithFormat:@"Mozilla/5.0 (Macintosh; Intel Mac OS X %@) AppleWebKit/%@ (KHTML, like Gecko) Version/%@ Safari/%@ Raven for Mac/%@" ,versionString, webkitVerion, safariVersionShort, safariVersionLong, appversion]; 
    [webview setCustomUserAgent:UA];
    [UA retain];

}

-(void)setMobileUserAgent
{
    UA = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A5302b Safari/7534.48.3"]; 
    [webview setCustomUserAgent:UA];
    [UA retain];

}

-(void)home:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:@"PreferredUrl"];
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:val]]];
    
}

-(void)setWindowTitle:(id)sender
{
    NSString *title = [webview mainFrameTitle];
    if (title == nil) {
        [[sender window]setTitle:NSLocalizedString(@"New tab", @"NewTab")]; 
    }
    else
    {
    [[sender window] setTitle:title];
    }
}

-(void)getFavicon:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *URL = [webview mainFrameURL];
    NSString *URLPrefix; 
    if ([URL hasPrefix:@"https"]) {
        URLPrefix = @"https://";
    }
    else{
        URLPrefix = @"http://";
    }
    URL = [[NSURL URLWithString:URL]host];
    NSError * error;
    NSString * html = [NSString stringWithContentsOfURL:
                       [NSURL URLWithString:
                        [NSString stringWithFormat:@"%@%@",URLPrefix,URL]]
                                               encoding:NSUTF8StringEncoding
                                                  error:&error];  
    //second try, different encoding
    if (![html length]) {
        html = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLPrefix,URL]]
                                                   encoding:NSISOLatin1StringEncoding
                                                      error:&error];  
    }
    
    if( [html length] )
    {
        
        NSXMLDocument * DOM = [[[NSXMLDocument alloc] initWithXMLString:html
                                                                options:NSXMLDocumentTidyHTML
                                                                  error:&error] autorelease];
        
        NSArray * nodes = [[DOM rootElement]nodesForXPath:@"head/link[@rel='shortcut icon' or @rel='icon']"
                                                     error:&error];
        if( [nodes count] )
        {
            NSString * href = [[[nodes lastObject] attributeForName:@"href"] stringValue];
            if( [href rangeOfString:@"http"].location != NSNotFound )
            {
                URL = href;
            } else {
                if ([href hasPrefix:@"/"]) {
                    URL = [NSString stringWithFormat:@"%@%@%@",URLPrefix,URL,href];
                }
                else{
                    URL = [NSString stringWithFormat:@"%@%@/%@",URLPrefix,URL,href];
                }
            }
        } else {
            URL = [NSString stringWithFormat:@"%@%@/favicon.ico",URLPrefix,URL];
        }
        
    } else {
        URL = [NSString stringWithFormat:FAVICON_URL,URL];
    }
    NSData * blob = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    NSImage *tempIcon = [[NSImage alloc]initWithData:blob];
    if (!tempIcon) {
        tempIcon = [NSImage imageNamed:@"MediumSiteIcon"];
        favicon = tempIcon; 
    }
    else{
        favicon = tempIcon;  
    }
    [pool release]; 
    [self performSelectorOnMainThread:@selector(setFaviconUI:) withObject:nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(saveHistory:) withObject:nil];
}

-(void)setFaviconUI:(id)sender
{
    NSString *title = [webview mainFrameTitle];
    if ([title isEqualToString:@"Raven Welcome Page"] || 
        [title isEqualToString:@"Raven Internal Page"] ||            
        [[webview mainFrameURL]isEqualToString:@"http://go.raven.io/"]){
        [temp setImage:[NSImage imageNamed:@"ravenico.png"]]; 
        [faviconTab setImage:[NSImage imageNamed:@"ravenico.png"]]; 
    }
    else{
        [temp setImage:favicon]; 
        [faviconTab setImage:favicon]; 
    }
}

-(void)saveHistory:(id)sender
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    RADatabaseController *controller = [RADatabaseController sharedUser];
    NSString *title = [webview mainFrameTitle];
    if ([title isEqualToString:@""] || [[webview mainFrameURL]isEqualToString:@"http://go.raven.io/"]) {
    }
    else if (doRegisterHistory == 2) {
        NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0]; 
        NSString *currentUrl= [webview mainFrameURL];
        NSImage *currentFavicon = favicon;
        NSString *udid = [[NSURL URLWithString:[webview mainFrameURL]]host];
        if (udid != nil) {
            udid = [udid createFileNameFromString:udid];
            [[currentFavicon TIFFRepresentation] writeToFile:[[NSString stringWithFormat:FAVICON_PATH, udid]stringByExpandingTildeInPath] atomically:YES];
            [controller insetHistoryItem:[webview mainFrameTitle] 
                                     url:currentUrl 
                                    data:[udid dataUsingEncoding:NSStringEncodingConversionAllowLossy] 
                                    date:currentDate];
            [controller updateBookmarkFavicon:[currentFavicon TIFFRepresentation] forUrl:currentUrl];

        }
        [currentDate release]; 
    }
    [pool release]; 
}


#pragma -
#pragma mark webview Delegate
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    // Only report feedback for the main frame.
    if (frame == [sender mainFrame]){
        //NSString *url = [[[[frame provisionalDataSource] request] URL] absoluteString];
        //Unhide the stop lading
        [stopLoading setHidden:NO];
        //animate the progressbar
        [progress startAnimation:self]; 
        [[temp animator]setAlphaValue:0.0];
        [[[self faviconTab]animator]setAlphaValue:0.0];
        [[self progressTab]startAnimation:self];
        [progressMain setHidden:NO]; 
        [progressMain setControlSize:NSMiniControlSize]; 
        
    }
    
}

//Call when webview really did start loading
- (void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame
{
    //get the current URL
    NSString *url = [webview mainFrameURL];
    //set the URl in the address bar
    
    [address setStringValue:url];
    
}


//set the title when the webview receive it
- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    // Only report feedback for the main frame.
    if (frame == [sender mainFrame]){
        [self performSelectorInBackground:@selector(getFavicon:) withObject:nil];
        //get the current title and set it in the window title
        NSString *title = [webview mainFrameTitle];
        [pageTitleTab setStringValue:[webview mainFrameTitle]];
        [pageTitleTab setToolTip:[webview mainFrameTitle]]; 
        [[sender window] setTitle:title];
        if (isNewTab)
        {
            [address setStringValue:@""];
            isNewTab = NO; 
        }
    } 
}


//set the favicon when the webview finished loading
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    //Set favicons
    [progress stopAnimation:self];
    [progressTab stopAnimation:self];
    [[faviconTab animator]setAlphaValue:1.0];
    [[temp animator]setAlphaValue:1.0];
    [progressMain setHidden:YES]; 
    [stopLoading setHidden:YES];
    [pageTitleTab setStringValue:[webview mainFrameTitle]];
    /*
     if ([[webview mainFrameURL] hasPrefix:@"https"]) {
     [addressBox setBorderColor:[NSColor greenColor]]; 
     }
     */
}
    
//Idea to auto fill a form à la other browsers, could be useful for credentials manager and auto login feature
    //Currently made for gmail
/*
 DOMHTMLFormElement *form = (DOMHTMLFormElement *)[[frame DOMDocument] getElementById:@"gaia_loginform"];
 DOMHTMLInputElement *username = (DOMHTMLInputElement *)[[form elements] namedItem:@"Email"];
 [username setValue:@"myemailacct"];
 
 DOMHTMLInputElement *password = (DOMHTMLInputElement *)[[form elements] namedItem:@"Passwd"];
 [password setValue:@"omghi"];
 
 [form submit];
 */
     


//If the webview fail load and receive error
- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    if ([error code] == - 1009) {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:@"Please check your Internet connection"];
        [alert setInformativeText:@"It appear that you don't have any active Internet connection"]; 
        [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Yeah")];
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [alert release]; 
    }
    else
    {
        if ([error code] == - 999) {
            
        }
        if (frame == [sender mainFrame]){
            //get the current address in the address bar
            NSString *addressTo = [address stringValue];
            addressTo = [addressTo stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            if (addressTo != nil) {
                addressTo = [NSString stringWithFormat:GOOGLE_SEARCH_URL@"%@", addressTo];
                //launch a google search
                [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:addressTo]]];
            }
        }
    }
}


#pragma -
#pragma mark memory management



//Bad memory maanagement for now ! 
- (void)dealloc
{  
    

    [webview stopLoading:webview]; 
    [webview setUIDelegate:nil];
    [webview setDownloadDelegate:nil]; 
    [webview setResourceLoadDelegate:nil]; 
    [webview setFrameLoadDelegate:nil];
    [webview setPolicyDelegate:nil]; 
    [webview close];
    [webview removeFromSuperview];
    [webview release], webview = nil;
    
    [super dealloc];
}

@end

//Private API to accept untrunsted certificate, should be removed next time soemtime with a brain pass by here

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{

	return YES;
}

@end
