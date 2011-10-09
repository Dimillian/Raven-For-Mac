//
//  MyDownloadCell.m
//  Raven
//
//  Created by Thomas Ricouard on 23/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RADownloadCell.h"
#import <iso646.h>

@implementation RADownloadCell

@synthesize titleLabel, progressText, progressView, imageView, iconDownload, openButton ;

#pragma mark -
#pragma mark Init/Dealloc

- (id)initWithReusableIdentifier: (NSString*)identifier
{
	if((self = [super initWithReusableIdentifier:identifier]))
	{
	}
	
	return self;
}

- (void)dealloc
{
	[titleLabel release], titleLabel=nil;
    [progressText release], progressText = nil; 
    [progressView release], progressView = nil; 
    [imageView release], imageView = nil; 
    [iconDownload release], iconDownload = nil; 
    [openButton release], openButton = nil;
    
	[super dealloc];
}

#pragma mark -
#pragma mark Reuse

- (void)prepareForReuse
{
    [progressView setMinValue:0.0];
    [progressView setMaxValue:100.0]; 
	[titleLabel setStringValue:@"Not set"];
    [progressText setStringValue:@"Not set"];
    [progressView setDoubleValue:100];
    [iconDownload setImage:[NSImage imageNamed:@"Not set"]];
    [progressView setControlSize:NSMiniControlSize]; 
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    //[NSColor colorWithDeviceRed:101/255.0 green:45/255.0 blue:134/255.0 alpha:1.0f]
	if([self isSelected]) {
		[[NSColor selectedControlColor] set];
        [imageView setImage:[NSImage imageNamed:@"customcell5.png"]];
        [titleLabel setTextColor:[NSColor whiteColor]];
        [progressText setTextColor:[NSColor whiteColor]];
	}
	else {
		[[NSColor whiteColor] set];
        [imageView setImage:[NSImage imageNamed:@"customcell3.PNG"]];
        [titleLabel setTextColor:[NSColor blackColor]];
        [progressText setTextColor:[NSColor disabledControlTextColor]];
    }
    
    //Draw the border and background
	NSBezierPath *roundedRect = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:0.0 yRadius:0.0];
	[roundedRect fill];
}


#pragma mark -
#pragma mark Accessibility

- (NSArray*)accessibilityAttributeNames
{
	NSMutableArray*	attribs = [[[super accessibilityAttributeNames] mutableCopy] autorelease];
	
	[attribs addObject: NSAccessibilityRoleAttribute];
	[attribs addObject: NSAccessibilityDescriptionAttribute];
	[attribs addObject: NSAccessibilityTitleAttribute];
	[attribs addObject: NSAccessibilityEnabledAttribute];
	
	return attribs;
}

- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute
{
	if( [attribute isEqualToString: NSAccessibilityRoleAttribute]
       or [attribute isEqualToString: NSAccessibilityDescriptionAttribute]
       or [attribute isEqualToString: NSAccessibilityTitleAttribute]
       or [attribute isEqualToString: NSAccessibilityEnabledAttribute] )
	{
		return NO;
	}
	else
		return [super accessibilityIsAttributeSettable: attribute];
}

- (id)accessibilityAttributeValue:(NSString*)attribute
{
	if([attribute isEqualToString:NSAccessibilityRoleAttribute])
	{
		return NSAccessibilityButtonRole;
	}
	
    if([attribute isEqualToString:NSAccessibilityDescriptionAttribute]
       or [attribute isEqualToString:NSAccessibilityTitleAttribute])
	{
		return [titleLabel stringValue];
	}
    
	if([attribute isEqualToString:NSAccessibilityEnabledAttribute])
	{
		return [NSNumber numberWithBool:YES];
	}
    
    return [super accessibilityAttributeValue:attribute];
}

@end

