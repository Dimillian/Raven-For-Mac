//
//  MyListViewCell.h
//  PXListView
//
//  Created by Alex Rozanski on 29/05/2010.
//  Copyright 2010 Alex Rozanski. http://perspx.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PXListViewCell.h"

@interface RAHistoryCell : PXListViewCell
{
	NSTextField *titleLabel;
    NSTextField *date; 
    NSTextField *url; 
    NSImageView *favicon;
    IBOutlet NSImageView *imageView; 
    
}

@property (nonatomic, retain) IBOutlet NSTextField *titleLabel;
@property (nonatomic, retain) IBOutlet NSTextField *date;
@property (nonatomic, retain) IBOutlet NSTextField *url;
@property (nonatomic, retain) IBOutlet NSImageView *favicon;

@end
