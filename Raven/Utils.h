#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

id ArrayFirstObject(NSArray* ary);

unsigned int StringReplace(NSMutableString* self,
                           NSString* target, NSString* replacement);
NSString* StringWithContentsOfURL(NSURL* url);

WebScriptObject* JSFunctionCall(WebScriptObject* func, NSArray* args);
NSArray* JSObjectKeys(WebScriptObject* obj);
id JSValueForKey(NSObject* self, NSString* key);

#define IS_JS_UNDEF(obj) ([(obj) isKindOfClass: [WebUndefined class]])

void ElementSetAttribute(NSXMLElement* self, NSString* key, NSString* value);
NSString* ElementAttribute(NSXMLElement* self, NSString* key);

NSURL* WebFrameRequestURL(WebFrame* frame);

void DebugLog(NSString* format, ...);
