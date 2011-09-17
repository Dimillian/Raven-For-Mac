//
//  RAppManagerWindow.h
//  Raven
//
//  Created by Thomas Ricouard on 17/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface RAppManagerWindow : NSWindowController <NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
    NSWindow *Window;
    IBOutlet NSTableView *tableview; 
    IBOutlet NSImageView *firstImageOff;
    IBOutlet NSImageView *firstImageOn;
    IBOutlet NSImageView *secondImageOff;
    IBOutlet NSImageView *secondImageOn;
    IBOutlet NSImageView *thirdImageOff;
    IBOutlet NSImageView *thirdImageOn;
    IBOutlet NSImageView *fourImageOff;
    IBOutlet NSImageView *fourimageOn;
    
    IBOutlet NSImageView *smallIcon; 
    IBOutlet NSImageView *bigIcon; 
    
    IBOutlet NSTextField *firstUrl;
    IBOutlet NSTextField *secondUrl;
    IBOutlet NSTextField *thirdUrl;
    IBOutlet NSTextField *fourUrl;
    IBOutlet NSTextField *appNameField;
    IBOutlet NSTextField *folderNameField;

}
-(IBAction)addAnApp:(id)sender;
-(IBAction)saveApp:(id)sender;
-(IBAction)deleteAnApp:(id)sender;

@end
