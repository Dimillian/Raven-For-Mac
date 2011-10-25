//
//  WebView+search.h
//  Raven
//
//  Created by Thomas Ricouard on 24/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WebView (search)

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
