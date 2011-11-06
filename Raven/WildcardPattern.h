/*
 * Copyright (c) 2006 KATO Kazuyoshi <kzys@8-p.info>
 * This source code is released under the MIT license.
 */

#import <Cocoa/Cocoa.h>
#include <regex.h>

#define WildcardPattern Info8_pWildcardPattern
@interface WildcardPattern : NSObject {
    NSString* source_;
    regex_t pattern_;
}

- (id) initWithString: (NSString*) s;
+ (id) patternWithString: (NSString*) s;
- (BOOL) isMatch: (NSString*) s;

- (NSString*) string;
- (void) setString: (NSString*) s;

@end
