//
//  MyWebView.h
//  Raven
//
//  Created by Thomas Ricouard on 29/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface RAMainWebView : WebView {
    NSMutableDictionary *twoFingersTouches;
    
}

@property (retain) NSMutableDictionary *twoFingersTouches;

@end
