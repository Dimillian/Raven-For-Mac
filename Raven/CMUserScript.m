/*
 * Copyright (c) 2006 KATO Kazuyoshi <kzys@8-p.info>
 * This source code is released under the MIT license.
 */

#import "CMUserScript.h"
#import "WildcardPattern.h"

#import "Utils.h"

static NSString* dummyBundleId_ = nil;

@implementation CMUserScript
- (NSString*) filename
{
    return fullPath_;
}

+ (void) setDummyBundleIdentifier: (NSString*) bundleId
{
    [dummyBundleId_ release];
    dummyBundleId_ = [bundleId retain];
}

- (NSMutableArray*) include
{
    return include_;
}

- (void) setInclude: (NSArray*) ary
{
    [include_ setArray: ary];
}

- (NSMutableArray*) exclude
{
    return exclude_;
}

- (void) setExclude: (NSArray*) ary
{
    [exclude_ setArray: ary];
}

- (void) elements: (NSArray*) elements
       toPatterns: (NSMutableArray*) result
{
    size_t i, n;

    for (i = 0, n = [elements count]; i < n; i++) {
        NSXMLElement* e = [elements objectAtIndex: i];

        WildcardPattern* pattern = [WildcardPattern patternWithString: [e stringValue]];

        [result addObject: pattern];
    }
}

- (void) array: (NSArray*) ary
    toElements: (NSXMLElement*) parent
          name: (NSString*) name
{
    int i, n;
    for (i = 0, n = [ary count]; i < n; i++) {
        NSXMLElement* e = [NSXMLElement elementWithName: name
                                            stringValue: [ary objectAtIndex: i]];
        [parent addChild: e];
    }
}

- (void) configureWithXMLElement: (NSXMLElement*) element
{
    if (! element)
        return;
    [self setName: ElementAttribute(element, @"name")];
    [self setNamespace: ElementAttribute(element, @"namespace")];
    [self setScriptDescription: ElementAttribute(element, @"description")];

    [self elements: [element elementsForName: @"Include"]
        toPatterns: include_];
    [self elements: [element elementsForName: @"Exclude"]
        toPatterns: exclude_];

    NSArray* ary;
    ary = [[element elementsForName: @"Application"] valueForKey: @"stringValue"];
    [applications_ addObjectsFromArray: ary];
}

- (NSXMLElement*) XMLElement
{
    NSXMLElement* result;
    result = [[NSXMLElement alloc] initWithName: @"Script"];

    ElementSetAttribute(result, @"name", [self name]);
    ElementSetAttribute(result, @"namespace", [self namespace]);
    ElementSetAttribute(result, @"description", [self scriptDescription]);

    if (fullPath_) {
        ElementSetAttribute(result, @"filename", [fullPath_ lastPathComponent]);
    }

    [self array: [include_ valueForKey: @"string"] toElements: result
           name: @"Include"];
    [self array: [exclude_ valueForKey: @"string"] toElements: result
           name: @"Exclude"];

    [self array: [applications_ allObjects] toElements: result
           name: @"Application"];

    return [result autorelease];
}

- (BOOL) isEqualTo: (CMUserScript*) other
{
    // not same namespace
    if ([self namespace] && ! [[self namespace] isEqualTo: [other namespace]])
        return false;

    return [[self name] isEqualTo: [other name]];
}

- (BOOL) isInstalled: (NSString*) scriptDir
{
    NSString* path;
    path = [NSString stringWithFormat: @"%@/%@", scriptDir, [self basenameFromName]];
    if (! [[NSFileManager defaultManager] fileExistsAtPath: path]) {
        return NO;
    }

    CMUserScript* other;
    other = [[CMUserScript alloc] initWithContentsOfFile: path
                                                 element: nil];
    [other autorelease];

    return [self isEqualTo: other];
}

- (NSString*) name
{
    return name_;
}

- (void) setName: (NSString*) name
{
    [name_ release];
    name_ = [name retain];
}

- (NSString*) scriptDescription
{
    return description_;
}

- (void) setScriptDescription: (NSString*) desc
{
    [description_ release];
    description_ = [desc retain];
}

- (NSString*) namespace
{
    return namespace_;
}

- (void) setNamespace: (NSString*) ns
{
    [namespace_ release];
    namespace_ = [ns retain];
}

- (NSString*) script
{
    NSString* result;
    if (fullPath_) {
        result = [[NSString alloc] initWithData: [NSData dataWithContentsOfFile: fullPath_]
                                       encoding: NSUTF8StringEncoding];
        [result autorelease];
    } else {
        result = script_;
    }
    return result;
}

+ (NSString*) fileNameFromString: (NSString*) s
{
    size_t len = [s length];

    unichar* src = (unichar*) malloc(len * sizeof(unichar));
    [s getCharacters: src];

    unichar* dst = (unichar*) malloc(len * sizeof(unichar));

    NSCharacterSet* cs = [NSCharacterSet alphanumericCharacterSet];
    size_t i, j = 0;
    for (i = 0; i < len; i++) {
        if ([cs characterIsMember: src[i]]) {
            dst[j++] = src[i];
        }
    }

    return [[NSString stringWithCharacters: dst length: j] lowercaseString];
}

- (NSString*) basenameFromName
{
    NSString* s = [[self class] fileNameFromString: [self name]];
    return [NSString stringWithFormat: @"%@.user.js", s];
}

+ (NSString*) uniqueName: (NSString*) name
                  others: (NSArray*) others
{
    int i = 2;
    NSString* s = [NSString stringWithFormat: @"%@.user.js", name];
    while ([others containsObject: s]) {
        s = [NSString stringWithFormat: @"%@-%d.user.js", name, i];
        i++;
    }
    return s;
}

- (BOOL) install: (NSString*) dir
{
    [fullPath_ release];
    fullPath_ = [[NSString alloc] initWithFormat: @"%@/%@", dir, [self basenameFromName]];

    if ([[NSFileManager defaultManager] fileExistsAtPath: fullPath_]) {
        CMUserScript* other;
        other = [[CMUserScript alloc] initWithContentsOfFile: fullPath_
                                                     element: nil];

        // same filename, but not same script
        if (! [self isEqualTo: other]) {
            NSArray* ary = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
            NSString* s;
            s = [[self class] uniqueName: [[self class] fileNameFromString: [self name]]
                                  others: ary];

            [fullPath_ release];
            fullPath_ = [[NSString alloc] initWithFormat: @"%@/%@", dir, s];
        }
        [other release];
    }

    NSData* data = [script_ dataUsingEncoding: NSUTF8StringEncoding];
    return [data writeToFile: fullPath_ atomically: YES];
}

- (BOOL) uninstall
{
    if (fullPath_) {
        return [[NSFileManager defaultManager] removeItemAtPath:fullPath_ error:nil];
    }
    return NO;
}

- (BOOL) isEnabled
{
    NSString* appId = [[NSBundle mainBundle] bundleIdentifier];
    if (! appId) {
        appId = dummyBundleId_;
    }
    return [applications_ containsObject: appId];
}

- (void) setEnabled: (BOOL) flag
{
    NSString* appId = [[NSBundle mainBundle] bundleIdentifier];
    if (! appId) {
        appId = dummyBundleId_;
    }
    if (flag) {
        [applications_ addObject: appId];
    } else {
        [applications_ removeObject: appId];
    }
}

- (BOOL) isMatched: (NSURL*) url
          patterns: (NSArray*) ary
{
    NSString* str = [url absoluteString];
    
    int i;
    for (i = 0; i < [ary count]; i++) {
        WildcardPattern* pat = [ary objectAtIndex: i];
        if ([pat isMatch: str]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) isMatched: (NSURL*) url
{
    if (! include_)
        return YES;
    
    if ([self isMatched: url patterns: include_]) {
        if (! [self isMatched: url patterns: exclude_]) {
            return YES;
        }
    }
    return NO;
}

+ (void) parseMetadataLine: (NSString*) line
                    result: (NSMutableDictionary*) result
{
    NSString* key;
    NSString* value;
    
    NSScanner* scanner = [[NSScanner alloc] initWithString: line];
    [scanner autorelease];
    
    // Skip to "@"
    [scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString: @"@"]
                            intoString: NULL];
    
    // Read key until whitespace
    if ([scanner isAtEnd])
        return;
    [scanner scanUpToCharactersFromSet: [NSCharacterSet whitespaceCharacterSet]
                            intoString: &key];

    // Read value until "\r" or "\n"
    if ([scanner isAtEnd])
        return;
    [scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString: @"\n\r"]
                            intoString: &value];
    
    NSMutableArray* ary = [result objectForKey: key];
    if (! ary) {
        ary = [[NSMutableArray alloc] init];
        [result setObject: ary forKey: key];
        [ary release];
    }
    [ary addObject: value];
}

+ (NSDictionary*) parseMetadata: (NSString*) script
{
    NSMutableDictionary* result;
    result = [[NSMutableDictionary alloc] init];
    
    BOOL inMetadata = NO;
    NSArray* lines = [script componentsSeparatedByString: @"\n"];
    int i;
    for (i = 0; i < [lines count]; i++) {
        NSString* line = [lines objectAtIndex: i];

        
        if ([line rangeOfString: @"==UserScript=="].length) {
            inMetadata = YES;
        } else if ([line rangeOfString: @"==/UserScript=="].length) {
            inMetadata = NO;
        } else if (inMetadata) {
            [CMUserScript parseMetadataLine: line
                                     result: result];
        }
    }
    
    if ([result count] == 0) {
        [result release];
        return nil;
    } else {
        return [result autorelease];
    }
}

+ (NSArray*) patternsFromStrings: (NSArray*) ary
{
    if (! ary)
        return nil;
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    int i;
    for (i = 0; i < [ary count]; i++) {
        WildcardPattern* pat = [WildcardPattern patternWithString: [ary objectAtIndex: i]];
        [result addObject: pat];
    }
    
    return [result autorelease];
}

- (id) initWithString: (NSString*) s
              element: (NSXMLElement*) element
{
    self = [self init];
    if (! self)
        return nil;

    NSMutableString* ms = [NSMutableString stringWithString: s];
    NSString* replacement;
    if ([ms rangeOfString: @"\n"].length) {
        replacement = @"";
    } else {
        replacement = @"\n";
    }
    [ms replaceOccurrencesOfString: @"\r" withString: replacement
                           options: 0 range: NSMakeRange(0, [ms length])];

    script_ = [ms retain];

    if (element) {
        [self configureWithXMLElement: element];
    } else {
        // metadata
        NSDictionary* md = [CMUserScript parseMetadata: script_];
        [self setName: ArrayFirstObject([md objectForKey: @"@name"])];
        [self setNamespace: ArrayFirstObject([md objectForKey: @"@namespace"])];
        [self setScriptDescription: ArrayFirstObject([md objectForKey: @"@description"])];

        // include
        NSArray* ary;
        ary = [CMUserScript patternsFromStrings: [md objectForKey: @"@include"]];
        [self setInclude: ary];
        include_ = [ary mutableCopy];
    
        // exclude
        ary = [CMUserScript patternsFromStrings: [md objectForKey: @"@exclude"]];
        [self setExclude: ary];
    }
    
    return self;
}

- (id) initWithData: (NSData*) data
            element: (NSXMLElement*) element
{
    NSString* str = [[NSString alloc] initWithData: data
                                          encoding: NSUTF8StringEncoding];
    self = [self initWithString: str
                        element: element];
    if (! self)
        return nil;
    
    return self;
}


- (id) initWithContentsOfFile: (NSString*) path
                      element: (NSXMLElement*) element
{
    self = [self initWithData: [NSData dataWithContentsOfFile: path]
                      element: element];

    if (! self)
        return nil;
    
    fullPath_ = [path retain];
    
    return self;
}

#pragma mark Override
- (id) init
{
    // NSLog(@"CMUserScript %p - init", self);

    self = [super init];
    
    script_ = nil;

    include_ = [[NSMutableArray alloc] init];
    exclude_ = [[NSMutableArray alloc] init];
    applications_ = [[NSMutableSet alloc] init];
    
    fullPath_ = nil;

    name_ = nil;
    namespace_ = nil;
    description_ = nil;
    
    return self;
}

- (void) dealloc
{
    // NSLog(@"CMUserScript %p - dealloc", self);
    [script_ release];

    [include_ release];
    [exclude_ release];
    
    [fullPath_ release];
    
    [super dealloc];
}

@end
