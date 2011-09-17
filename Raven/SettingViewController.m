//
//  SettingViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import <sqlite3.h>
#import "RavenAppDelegate.h"
#import "MainWindowController.h"

@implementation SettingViewController

-(void)awakeFromNib
{
    [webview setUIDelegate:self];
    [webview setPolicyDelegate:self];
    [[webview mainFrame]loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://raven.io/demo/apps/"]]];
    
}

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    WebView *tempview = [[WebView alloc]init]; 
    [tempview setFrameLoadDelegate:self]; 
    [[tempview mainFrame]loadRequest:request]; 
    return tempview; 
}

//Little hack to intercept URL, the webview start provisiosing with the previous request. Only way to catch the URL
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]){
        if ([[sender mainFrameURL]isEqualToString:@""]) {
        }
        else
        {
            MainWindowController *controller = [[webview window]windowController];
            controller.navigatorview.PassedUrl = [sender mainFrameURL]; 
            [controller setting:nil];
            [controller raven:nil];
            [controller.navigatorview addtabs:nil];
            [sender stopLoading:sender];   
        }
    }
}


- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    MainWindowController *controller = [[webView window]windowController];
    controller.navigatorview.PassedUrl = [[request URL]absoluteString]; 
    [controller setting:nil];
    [controller raven:nil];
    [controller.navigatorview addtabs:nil];

}

- (void)dealloc
{
    [webview setUIDelegate:nil]; 
    [webview setPolicyDelegate:nil]; 
    [webview close]; 
    [super dealloc];
}


@end
