//
//  RASBAPPMainButton.h
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@protocol RASBAPPMainButtonDelegate;
@interface RASBAPPMainButton : NSButton
{
    id<RASBAPPMainButtonDelegate> delegate;
}
@property (nonatomic, assign) id<RASBAPPMainButtonDelegate> delegate;
@end

@protocol RASBAPPMainButtonDelegate
@optional
- (void)mouseDidEntered:(RASBAPPMainButton *)button;
- (void)mouseDidExited:(RASBAPPMainButton *)button;
- (void)mouseDidScroll:(RASBAPPMainButton *)button; 
@end
