//
//  WebView+Growl.m
//  Raven
//
//  Created by Thomas Ricouard on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WebView+Growl.h"


@implementation WebView (growl)

-(void)displayGrowlNotification
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"growlWebView" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"checkForGrowl()"];
    NSLog(@"%@", result);
}

@end
