//
//  RAPopupWindowController.m
//  Raven
//
//  Created by Thomas Ricouard on 09/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RAPopupWindowController.h"

@implementation RAPopupWindowController
@synthesize delegate; 

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib
{
    [[self window]setDelegate:self]; 
    if (IS_RUNNING_LION) {
        static int NSWindowAnimationBehaviorDocumentWindow = 3;
        [[self window]setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(windowWillClose:) 
                                                 name:NSWindowWillCloseNotification 
                                               object:self.window];

}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
}


-(void)windowWillClose:(NSNotification *)notification
{   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self autorelease]; 
}

-(void)dealloc
{
    [delegate onCloseButton:self];
    [super dealloc]; 
}

-(void)replaceWebView:(WebView *)webview
{
    [webview setFrame:mainView.frame]; 
    [webview setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [mainView addSubview:webview]; 
    [webview setFrameLoadDelegate:self];
    [webview setShouldCloseWithWindow:YES];
    [webview setUIDelegate:self];
    [webview setResourceLoadDelegate:self]; 
    [webview setPolicyDelegate:self]; 
    while ([webview isLoading])
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [NSApp nextEventMatchingMask:NSAnyEventMask untilDate:[NSDate dateWithTimeIntervalSinceNow:1.0] inMode:NSDefaultRunLoopMode dequeue:YES];
        [pool drain];
    }
}


-(void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    [addressBar setStringValue:[sender mainFrameURL]];
    
}

-(void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    [self.window setTitle:title]; 
}

-(void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    
}

-(void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
   
}

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{

    
}


-(void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    [listener use]; 
}

-(void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener
{
    [listener use]; 
    
}

-(void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    [listener use]; 
    
}


@end
