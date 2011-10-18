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


#define GOOGLE_SEARCH_URL @"http://www.google.com/search?q="

@implementation RAWebViewController
@synthesize passedUrl, switchView, tabsButton, webview, address, tabview; 
@synthesize tabButtonTab, backgroundTab, pageTitleTab, faviconTab, closeButtonTab, progressTab, doRegisterHistory, isNewTab, secondTabButton, closeButtonTabShortcut, addressBarView, boxTab, tabHolder; 

#pragma -
#pragma mark action
-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"NavigatorNoBottom" bundle:nil]; 
    }
    
    return self; 
}
/*
+(NSString*)webScriptNameForSelector:(SEL)sel
{
    if(sel == @selector(logJavaScriptString:))
        return @"log";
    return nil;
}

//this allows JavaScript to call the -logJavaScriptString: method
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)sel
{
    if(sel == @selector(logJavaScriptString:))
        return NO;
    return YES;
}


- (void)logJavaScriptString:(NSString*) logText
{
    NSLog(@"JavaScript: %@",logText);
}
*/
-(void)awakeFromNib
{
    WebPreferences *myPreference = [[WebPreferences alloc]initWithIdentifier:@"PreferenceWeb"]; 
    [myPreference setUsesPageCache:NO]; 
    [self setDesktopUserAgent];
    [self setDoRegisterHistory:2];
    //Hide the stop loading button
    [stopLoading setHidden:YES];
    //Setup the delegate of the webview
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
    RADownloadController *controller = [[RADownloadController alloc]init]; 
    downloadIndex  = [controller.downloadArray count]; 
    [controller release];
    
    [myPreference release]; 
    isNewTab = YES; 
    [progressMain setMinValue:0.0]; 
    [progressMain setMaxValue:1.0]; 
    
    

    
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


-(void)search:(id)sender
{
    [webview searchFor:@"Hello" direction:YES caseSensitive:NO wrap:NO]; 
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
    [favoritePanel setTempFavico:[webview mainFrameIcon]]; 
    [favoritePanel setState:1];
    [favoritePanel setType:0];
    RAHiddenWindow *hiddenWindow = [[RAHiddenWindow alloc]initWithContentRect:[[NSApp keyWindow]frame] styleMask:NSBorderlessWindowMask backing:NSBackingStoreNonretained defer:YES];
    [hiddenWindow setLevel:NSNormalWindowLevel];
    [hiddenWindow setIgnoresMouseEvents:YES];
    [hiddenWindow setAlphaValue:0.0];
    [[NSApp keyWindow]addChildWindow:hiddenWindow ordered:NSWindowAbove];
    [NSApp beginSheet:[favoritePanel window] modalForWindow:hiddenWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];
    //[NSApp runModalForWindow:[favoritePanel window]];
    [hiddenWindow release]; 
    
}

-(void)gotopage:(id)sender
{
    [[webview mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[sender representedObject]]]];
    
}

-(void)favoriteMenu:(id)sender
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
    RAMainWindowController *mainWindow = [[sender window]windowController]; 
    [menu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *item = [[NSMenuItem alloc]init];
    [item setTarget:mainWindow];
    [item setTitle:@"Edit Favorites"];
    [item setAction:@selector(bookmark:)];
    [item setEnabled:YES]; 
    [menu addItem:item]; 
    [item release]; 
    
    
    
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
    
    [menu release]; 
    
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
        [temp setImage:[webview mainFrameIcon]];
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
        //get the current title and set it in the window title
        NSString *title = [webview mainFrameTitle];
        [[self pageTitleTab]setStringValue:[webview mainFrameTitle]];
        [[self pageTitleTab]setToolTip:[webview mainFrameTitle]]; 
        [[sender window] setTitle:title];
        if (isNewTab)
        {
            [address setStringValue:@""];
            isNewTab = NO; 
        }
    }    
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame
{
    [temp setImage:[webview mainFrameIcon]];
    [[self faviconTab]setImage:[webview mainFrameIcon]]; 
}

//set the favicon when the webview finished loading
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    RADatabaseController *controller = [RADatabaseController sharedUser];
    // Only report feedback for the main frame.
    [progressMain setHidden:YES]; 
    NSString *title =  [webview mainFrameTitle]; 
    //get the current page icon
    favicon = [webview mainFrameIcon];
    [temp setImage:favicon]; 
    [stopLoading setHidden:YES];
    [[self faviconTab]setImage:[webview mainFrameIcon]]; 
    [[self pageTitleTab]setStringValue:[webview mainFrameTitle]];
    [[self progressTab]stopAnimation:self];
    [progress stopAnimation:self]; 
    [[[self faviconTab]animator]setAlphaValue:1.0]; 
    [[temp animator]setAlphaValue:1.0]; 
    /*
     if ([[webview mainFrameURL] hasPrefix:@"https"]) {
     [addressBox setBorderColor:[NSColor greenColor]]; 
     }
     */
    if ([title isEqualToString:@"Raven Welcome Page"] || 
        [title isEqualToString:@"Raven Internal Page"] ||            
        [[webview mainFrameURL]isEqualToString:@"http://go.raven.io/"])
    {
        [temp setImage:[NSImage imageNamed:@"ravenico.png"]]; 
        [faviconTab setImage:[NSImage imageNamed:@"ravenico.png"]]; 
    }
    else
    {
        if ([title isEqualToString:@""]) {
            NSLog(@"blank title");
        }
        
        else if (doRegisterHistory == 2) {
            if (frame == [sender mainFrame]){
                NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0]; 
                NSString *currentUrl= [webview mainFrameURL];
                NSImage *currentFavicon = [webview mainFrameIcon];
                NSString *udid = currentUrl;
                udid = [udid createFileNameFromString:udid];
                [[currentFavicon TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/favicon/%@", udid]stringByExpandingTildeInPath] atomically:YES];
                [controller insetHistoryItem:[webview mainFrameTitle] 
                                         url:currentUrl 
                                        data:[udid dataUsingEncoding:NSStringEncodingConversionAllowLossy] 
                                        date:currentDate];
                [controller updateBookmarkFavicon:[currentFavicon TIFFRepresentation] forUrl:currentUrl];
                [currentDate release]; 
            }
            
        }
    }
     
}


//If the webview fail load and receive error
- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
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

//Private API to accept untrunsted certificate, should be enhance or removed

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{

	return YES;
}

@end
