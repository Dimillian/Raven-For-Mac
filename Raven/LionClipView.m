//
//  LionClipView.m
//  Raven
//
//  Created by Thomas Ricouard on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LionClipView.h"

@implementation LionClipView

#define SHADOW_HEIGHT 5

- (void)drawRect:(NSRect)dirtyRect
{
    
    // call super
    
    [super drawRect:dirtyRect];
    
    // work our the rects
    
    NSRect rect = [self documentVisibleRect];
    rect.size.height = [[self documentView] frame].size.height;
    
    [NSGraphicsContext saveGraphicsState];
    
    // set up our gradient
    
    NSGradient * grad = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:( 0.0 / 255.0 )
                                                                                        green:( 0.0 / 255.0 )
                                                                                         blue:( 0.0 / 255.0 )
                                                                                        alpha:.2]
                                                      endingColor:[NSColor clearColor]];
    
    // draw the background / any custom things, so the background and anything else
    
    [self drawBackground];
    
    
    if( [self visibleRect].origin.y < 0 )
    {
        
        // draw top static
        
        [grad drawInRect:NSMakeRect( 0.0, [self visibleRect].origin.y, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:90.0];
        
        // non static top
        
        [grad drawInRect:NSMakeRect( 0.0, -SHADOW_HEIGHT, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:270.0];
        
    }
    
    if( ( rect.size.height - rect.origin.y ) < [self visibleRect].size.height )
    {
        
        // draw bottom static
        
        [grad drawInRect:NSMakeRect( 0.0, ( [self visibleRect].size.height + [self visibleRect].origin.y ) - SHADOW_HEIGHT, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:270.0];
        
        // bottom non static
        
        [grad drawInRect:NSMakeRect( 0.0, rect.size.height, [self bounds].size.width, SHADOW_HEIGHT )
                   angle:90.0];
        
    }
    
    // release the gradient
    
    [grad release];
    
    [NSGraphicsContext restoreGraphicsState];
    
}

- (void)drawBackground
{
    /*
    // Save the current graphics state first so we can restore it.
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    // Change the pattern phase.
    [[NSGraphicsContext currentContext] setPatternPhase:
     NSMakePoint(0,[self frame].size.height)];
    
    // Stick the image in a color and fill the view with that color.
    NSImage *anImage = [NSImage imageNamed:@"bricks"];
    [[NSColor colorWithPatternImage:anImage] set];
    NSRectFill([self bounds]);
    
    // Restore the original graphics state.
    [[NSGraphicsContext currentContext] restoreGraphicsState];
     */
    
    [[NSColor controlColor] set];
    NSRectFill( [self bounds] );
    
}

@end
