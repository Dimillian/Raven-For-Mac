//
//  MyDownloadCell.h
//  Raven
//
//  Created by Thomas Ricouard on 23/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXListViewCell.h"

@interface MyDownloadCell : PXListViewCell {
    IBOutlet NSTextField *titleLabel;
    IBOutlet NSTextField *progressText; 
    IBOutlet NSProgressIndicator *progressView;
    IBOutlet NSImageView *imageView; 
    IBOutlet NSImageView *iconDownload; 
    IBOutlet NSButton *openButton; 
    
}

@property (nonatomic, retain) IBOutlet NSTextField *titleLabel;
@property (nonatomic, retain) IBOutlet NSTextField *progressText;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressView;
@property (nonatomic, retain) IBOutlet NSImageView *imageView;
@property (nonatomic, retain) IBOutlet NSImageView *iconDownload;
@property (nonatomic, retain) IBOutlet NSButton *openButton; 

@end
