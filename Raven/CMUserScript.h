/* -*- objc -*-
 *
 * Copyright (c) 2006 KATO Kazuyoshi <kzys@8-p.info>
 * This source code is released under the MIT license.
 */

#import <Cocoa/Cocoa.h>

#define CMUserScript Info8_pCMUserScript
@interface CMUserScript : NSObject {
    NSString* script_;
    
    NSMutableArray* include_;
    NSMutableArray* exclude_;
    NSMutableSet* applications_;
    
    NSString* fullPath_;

    NSString *name_, *namespace_, *description_;
}

+ (void) setDummyBundleIdentifier: (NSString*) bundleId;
+ (NSDictionary*) parseMetadata: (NSString*) script;

- (id) initWithString: (NSString*) script
              element: (NSXMLElement*) element;
- (id) initWithContentsOfFile: (NSString*) path
                      element: (NSXMLElement*) element;

- (NSXMLElement*) XMLElement;
- (void) configureWithXMLElement: (NSXMLElement*) element;

// accessor
- (NSMutableArray*) include;
- (NSMutableArray*) exclude;

- (NSString*) name;
- (void) setName: (NSString*) name;

- (NSString*) namespace;
- (void) setNamespace: (NSString*) ns;

- (NSString*) scriptDescription;
- (void) setScriptDescription: (NSString*) desc;


- (NSString*) script;
- (NSString*) basenameFromName;

- (BOOL) isInstalled: (NSString*) path;
- (BOOL) install: (NSString*) path;
- (BOOL) uninstall;

- (BOOL) isEnabled;
- (void) setEnabled: (BOOL) flag;

- (BOOL) isMatched: (NSURL*) url;
- (NSString*) filename;

+ (NSString*) fileNameFromString: (NSString*) s;
+ (NSString*) uniqueName: (NSString*) name others: (NSArray*) others;
+ (NSArray*) patternsFromStrings: (NSArray*) src;

@end
