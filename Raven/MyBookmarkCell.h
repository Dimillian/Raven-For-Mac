//
//  MyBookmarkCell.h
//  Raven
//
//  Created by Thomas Ricouard on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "PXListViewCell.h"

@interface MyBookmarkCell : PXListViewCell
{
	NSTextField *titleLabel;
    NSTextField *url; 
    NSImageView *favicon;
    IBOutlet NSImageView *imageView; 
    
}

@property (nonatomic, retain) IBOutlet NSTextField *titleLabel;
@property (nonatomic, retain) IBOutlet NSTextField *url;
@property (nonatomic, retain) IBOutlet NSImageView *favicon;

@end
