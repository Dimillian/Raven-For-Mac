//
//  NSButtonSub.h
//  Raven
//
//  Created by Thomas Ricouard on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAAttachedWindow.h"


@interface RASmartBarButton : NSButton {
    IBOutlet NSView *tooltip; 
    IBOutlet NSTextField *tooltipText; 
    MAAttachedWindow *attachedWindow; 
    NSTimer *timer; 
    NSImage *tempImage;
}
//-(void)closeSuggestionBox;
//-(void)showToolTip; 

@end
