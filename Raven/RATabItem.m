//
//  RATabItem.m
//  Raven
//
//  Created by Thomas Ricouard on 14/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RATabItem.h"
#import "RANavigatorViewController.h"

@implementation RATabItem
@synthesize webViewController = _webViewController, tabView = _tabView, delegate; 

-(id)init
{
    self = [super init]; 
    if(self){
        _tabView = [[RATabView alloc]initWithNibName:@"RATabView" bundle:nil]; 
        [_tabView setDelegate:self]; 
        _webViewController = [[RAWebViewController alloc]initWithDelegate:self andTabView:_tabView]; 

    }
    return self; 
}


-(void)dealloc
{
    [_tabView release]; 
    [_webViewController release]; 
    [super dealloc]; 
}

-(void)callView
{
    [_webViewController view]; 
    [_tabView view]; 
}

-(void)setWebViewDelegate:(RANavigatorViewController *)controller
{
    [[_webViewController webview]setUIDelegate:controller]; 
    [[_webViewController webview]setPolicyDelegate:controller]; 
}

-(void)prepareTabClose
{
    [[self.webViewController webview]setUIDelegate:nil]; 
    [[self.tabView view]setAlphaValue:0.0]; 
    [[self.tabView view]removeFromSuperview];
    [self.webViewController view];
    [self.webViewController setDelegate:nil];
    [[self.webViewController webview]setPolicyDelegate:nil];
    [[self.webViewController webview]stopLoading:[self.webViewController webview]];
    [[self.webViewController webview]removeFromSuperview];
    [[self.webViewController view]removeFromSuperview];
}

#pragma mark -
#pragma mark RATabViewDelegate

-(void)tabDidSelect:(RATabView *)tabView
{
    [delegate tabItemDidSelect:self]; 
}

-(void)tabWillClose:(RATabView *)tabView
{
    [delegate tabItemWillClose:self]; 
}

-(void)tabDidStartDragging:(RATabView *)tabView
{
    [delegate tabItemDidStartDragging:self]; 
}

-(void)tabDidMoveLeft:(RATabView *)tabView
{
    [delegate tabItemDidMoveLeft:self]; 
}

-(void)tabDidMoveRight:(RATabView *)tabView
{
    [delegate tabItemDidMoveRight:self]; 
}

-(void)tabDidStopDragging:(RATabView *)tabView
{
    [delegate tabItemDidStopDragging:self]; 
}


#pragma mark -
#pragma mark RAWebViewDelegate

-(void)webViewshouldCreateNewTab:(RAWebViewController *)RAWebView
{
    [delegate tabItemRequestANewTab:self]; 
}

@end
