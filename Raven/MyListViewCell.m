//
//  MyListViewCell.m
//  PXListView
//
//  Created by Alex Rozanski on 29/05/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com. All rights reserved.
//

#import "MyListViewCell.h"

#import <iso646.h>


@implementation MyListViewCell

@synthesize titleLabel, date, url, favicon;

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
    [date release], date = nil; 
    [url release], url = nil; 
    [imageView release], imageView = nil; 
    
	[super dealloc];
}

#pragma mark -
#pragma mark Reuse

- (void)prepareForReuse
{
	[titleLabel setStringValue:@""];
    [date setStringValue:@""];
    [url setStringValue:@""];
    [favicon setImage:[NSImage imageNamed:@""]];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    
    //[NSColor colorWithDeviceRed:101/255.0 green:45/255.0 blue:134/255.0 alpha:1.0f]
	if([self isSelected]) {
        [imageView setImage:[NSImage imageNamed:@"customcell5.png"]];
        [titleLabel setTextColor:[NSColor whiteColor]];
        [url setTextColor:[NSColor whiteColor]];
        [date setTextColor:[NSColor whiteColor]];
	}
	else {
        [imageView setImage:[NSImage imageNamed:@"customcell3.PNG"]];
        [titleLabel setTextColor:[NSColor blackColor]];
        [url setTextColor:[NSColor disabledControlTextColor]];
        [date setTextColor:[NSColor keyboardFocusIndicatorColor]];
    }

    
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
