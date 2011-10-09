//
//  AboutPanel.h
//  Raven
//
//  Created by Thomas Ricouard on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface RAAboutPanelWindowController : NSWindowController <NSWindowDelegate>
{
    IBOutlet NSTextField *version; 
}
-(id)infoValueForKey:(NSString*)key;
-(IBAction)openLA:(id)sender;
-(IBAction)openAK:(id)sender;

@end
