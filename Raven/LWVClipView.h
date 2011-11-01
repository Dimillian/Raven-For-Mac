//
//  LWVClipView.h
//  LinenWebView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) 2011 InScopeApps {+}. All rights reserved.
//
//  From http://www.koders.com/objectivec/fid22DEE7EA2343C20D0FEEC2C079245069DF3E32A5.aspx
//

#import <AppKit/AppKit.h>

@interface LWVClipView : NSClipView
@end

@interface LWVWebClipView : LWVClipView
{
    BOOL _haveAdditionalClip;
    NSRect _additionalClip;
}
- (void)setAdditionalClip:(NSRect)additionalClip;
- (void)resetAdditionalClip;
- (BOOL)hasAdditionalClip;
- (NSRect)additionalClip;

@end
