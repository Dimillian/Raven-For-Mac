//
//  RAHiddenWindow.m
//  Raven
//
//  Created by Thomas Ricouard on 17/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAHiddenWindow.h"

@implementation RAHiddenWindow
- (id)initWithContentRect:(NSRect)frame
{
    self = [super initWithContentRect:frame
                            styleMask:NSBorderlessWindowMask backing:NSBackingStoreNonretained
                                defer:YES];
    [self setLevel:NSNormalWindowLevel];
    [self setIgnoresMouseEvents:YES];
    [self setAlphaValue:0.0];
    
    return self;
}

// don't allow our sheets to move this window
- (void)setFrameOrigin:(NSPoint)aPoint { return; }
@end