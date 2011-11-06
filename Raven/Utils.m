#import "Utils.h"

#include <stdio.h>

id ArrayFirstObject(NSArray* self)
{
    if ([self count] > 0)
        return [self objectAtIndex: 0];
    else
        return nil;
}

unsigned int StringReplace(NSMutableString* self,
                           NSString* target, NSString* replacement)
{
    return [self replaceOccurrencesOfString: target
                                 withString: replacement
                                    options: 0
                                      range: NSMakeRange(0, [self length])];
}

/*
  NSString + stringWithContentsOfURL: don't work with
  compressed responce (like gzip or deflate)
 */
NSString* StringWithContentsOfURL(NSURL* url)
{
    NSURLResponse* resp;
    NSError* error;
    NSData* data;
    NSURLRequest* req = [NSURLRequest requestWithURL: url];
    data = [NSURLConnection sendSynchronousRequest: req
                                 returningResponse: &resp
                                             error: &error];

    NSString* result = [[NSString alloc] initWithData: data
                                             encoding: NSUTF8StringEncoding];
    return [result autorelease];
}

WebScriptObject* JSFunctionCall(WebScriptObject* func, NSArray* args)
{
    if (IS_JS_UNDEF(func)) {
        return nil;
    }
    WebScriptObject* jsThis = [func evaluateWebScript: @"this"];
    if (! jsThis) {
        return nil;
    }
    NSMutableArray* ary = [NSMutableArray arrayWithObject: jsThis];
    [ary addObjectsFromArray: args];
    return [func callWebScriptMethod: @"call" withArguments: ary];
}

NSArray* JSObjectKeys(WebScriptObject* obj)
{
    WebScriptObject* func = [obj evaluateWebScript: @"function(obj){var result=[];for(var k in obj)result.push(k);return result;}"];
    WebScriptObject* keys = JSFunctionCall(func, [NSArray arrayWithObject: obj]);

    size_t i;
    NSMutableArray* result = [NSMutableArray array];
    WebScriptObject* jsUndefined = [obj evaluateWebScript: @"undefined"];
    for (i = 0; [keys webScriptValueAtIndex: i] != jsUndefined; i++) {
        [result addObject: [keys webScriptValueAtIndex: i]];
    }
    return result;
}

id JSValueForKey(NSObject* self, NSString* key)
{
    id result;
    @try {
        result = [self valueForKey: key];
    } @catch (NSException* e) {
        return nil;
    }

    if (IS_JS_UNDEF(result)) {
        return nil;
    }

    return result;
}

void ElementSetAttribute(NSXMLElement* self, NSString* key, NSString* value)
{
    if ([self attributeForName: key]) {
        [self removeAttributeForName: key];
    }
    NSXMLNode* node;
    node = [NSXMLNode attributeWithName: key stringValue: value];
    [self addAttribute: node];
}

NSString* ElementAttribute(NSXMLElement* self, NSString* key)
{
    NSXMLNode* node = [self attributeForName: key];
    if (node)
        return [node stringValue];
    else
        return nil;
}

void DebugLog(NSString* format, ...)
{
    static FILE* log = NULL;
    if (! log) {
        log = fopen("/tmp/greasekit_debug.log", "a");
        fprintf(log, "--\n");
    }

    va_list args;
    va_start(args, format);
    NSString* s = [NSString stringWithFormat: format, args];
    fprintf(log, "%s", [[NSString stringWithFormat: @"%@\n", s] UTF8String]);
    va_end(args);

    fflush(log);
}

NSURL* WebFrameRequestURL(WebFrame* frame)
{
    WebDataSource* dataSource = [frame dataSource];
    if (! dataSource) {
        return nil;
    }
    return [[dataSource request] URL];
}
