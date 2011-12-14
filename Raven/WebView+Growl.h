//
//  WebView+Growl.h
//  Raven
//
//  Created by Thomas Ricouard on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "RAGrowlDispatcher.h"

@interface WebView (growl)

-(void)displayGrowlNotification; 

@end