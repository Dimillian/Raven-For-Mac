//
//  RAPopupWindowController.h
//  Raven
//
//  Created by Thomas Ricouard on 09/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RAMainWebView.h"

@protocol RAPopupWindowDelegate;
@interface RAPopupWindowController : NSWindowController <NSWindowDelegate>
{
    id                  <RAPopupWindowDelegate>delegate; 
    IBOutlet NSTextField *addressBar; 
    IBOutlet NSView *mainView; 
    BOOL loadOnce; 
}

-(void)replaceWebView:(WebView *)webview; 

@property (nonatomic, assign) id<RAPopupWindowDelegate>delegate; 
@end

@protocol RAPopupWindowDelegate
@optional
-(void)onCloseButton:(RAPopupWindowController *)windowController; 
@end
