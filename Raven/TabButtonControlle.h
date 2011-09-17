//
//  TabButtonControlle.h
//  Raven
//
//  Created by Thomas Ricouard on 24/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TabButtonControlle : NSViewController {
    
    
    IBOutlet NSImageView *background;
    IBOutlet NSImageView *favicon; 
    IBOutlet NSTextField *pageTitle; 
    IBOutlet NSButton *tabButton; 
    IBOutlet NSButton *closeButton; 
    IBOutlet NSProgressIndicator *progress;

    
}
@property (nonatomic, retain) NSProgressIndicator *progress; 
@property (nonatomic, retain) NSButton *tabButton;
@property (nonatomic, retain) NSButton *closeButton; 
@property (nonatomic, retain) NSImageView *background; 
@property (nonatomic, retain) NSImageView *favicon; 
@property (nonatomic, retain) NSTextField *pageTitle; 

@end
