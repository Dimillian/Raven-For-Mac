//
//  LWVClipView.m
//  LinenWebView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) 2011 InScopeApps {+}. All rights reserved.
//
//  From http://www.koders.com/objectivec/fidD68502CAF940A73CC1E990AF8A2E3D17ACFCD647.aspx
//

#import "LWVClipView.h"
#define SHADOW_HEIGHT 8

static NSGradient *gradient = nil;

@implementation LWVClipView

- (void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];

    [[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint( 0, [self bounds].size.height )];
    NSColor *backgroundColor = [NSColor colorWithPatternImage:
                           [NSImage imageNamed:@"linenLight"]];
    [backgroundColor set];
    
    NSRectFill(self.bounds);
    NSRect rect = [self documentVisibleRect];
    rect.size.height = [[self documentView] frame].size.height;
    
    // shadow
    if(gradient == nil){
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:( 0.0 / 255.0 )
                                                                                        green:( 0.0 / 255.0 )
                                                                                        blue:( 0.0 / 255.0 )
                                                                                        alpha:.2]
                                                          endingColor:[NSColor clearColor]];
    }
    if( [self visibleRect].origin.y < 0 )
    {
        
        // draw top static
        
        [gradient drawInRect:NSMakeRect( 0.0, [self visibleRect].origin.y, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:90.0];
        
        // non static top
        
        [gradient drawInRect:NSMakeRect( 0.0, -SHADOW_HEIGHT, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:270.0];
        
    }
    
    if( ( rect.size.height - rect.origin.y ) < [self visibleRect].size.height )
    {
        
        // draw bottom static
        
        [gradient drawInRect:NSMakeRect( 0.0, ( [self visibleRect].size.height + [self visibleRect].origin.y ) - SHADOW_HEIGHT, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:270.0];
        
        // bottom non static
        
        [gradient drawInRect:NSMakeRect( 0.0, rect.size.height, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:90.0];
        
    }

}

@end

@implementation LWVWebClipView
- (id)initWithFrame:(NSRect)frame{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }
    
    // In WebHTMLView, we set a clip. This is not typical to do in an
    // NSView, and while correct for any one invocation of drawRect:,
    // it causes some bad problems if that clip is cached between calls.
    // The cached graphics state, which clip views keep around, does
    // cache the clip in this undesirable way. Consequently, we want to 
    // release the GState for all clip views for all views contained in 
    // a WebHTMLView. Here we do it for subframes, which use WebClipView.
    // See these bugs for more information:
    // <rdar://problem/3409315>: REGRESSSION (7B58-7B60)?: Safari draws blank frames on macosx.apple.com perf page
    [self releaseGState];
    
    return self;
}

- (void)resetAdditionalClip{
    _haveAdditionalClip = NO;
}

- (void)setAdditionalClip:(NSRect)additionalClip{
    _haveAdditionalClip = YES;
    _additionalClip = additionalClip;
}

- (BOOL)hasAdditionalClip{
    return _haveAdditionalClip;
}

- (NSRect)additionalClip{
    return _additionalClip;
}

//- (NSRect)_focusRingVisibleRect{
//    NSRect rect = [self visibleRect];
//    if (_haveAdditionalClip) {
//        rect = NSIntersectionRect(rect, _additionalClip);
//    }
//    return rect;
//}
//
//- (void)scrollWheel:(NSEvent *)event{
//    NSView *docView = [self documentView];
//    if ([docView respondsToSelector:@selector(_webView)]) {
//        WebView *wv = [docView _webView];
//        if ([wv _dashboardBehavior:WebDashboardBehaviorAllowWheelScrolling]) {
//            [super scrollWheel:event];
//        }
//        return;
//    }
//    [super scrollWheel:event];
//}

@end
