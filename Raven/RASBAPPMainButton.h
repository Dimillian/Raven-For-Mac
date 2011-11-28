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
    NSTimer *timer; 
    BOOL isDown;
}
-(void)sendMouseEntered:(id)sender; 
-(void)mouseDownLongPress:(id)sender;
-(void)sendCloseDelegate:(id)sender; 
-(void)sendHideDelegate:(id)sender; 
-(NSMenu *)getMenu; 
@property (nonatomic, assign) id<RASBAPPMainButtonDelegate> delegate;
@end

@protocol RASBAPPMainButtonDelegate
@optional
- (void)mouseDidEntered:(RASBAPPMainButton *)button;
- (void)mouseDidExited:(RASBAPPMainButton *)button;
- (void)mouseDidScroll:(RASBAPPMainButton *)button; 
- (void)mouseDidClicked:(RASBAPPMainButton *)button;
- (void)shouldDisplayCloseButton:(RASBAPPMainButton *)button;
- (void)shouldDisplayHideButton:(RASBAPPMainButton *)button; 
- (void)shouldCloseApp:(RASBAPPMainButton *)button; 
- (void)shouldHideApp:(RASBAPPMainButton *)button; 
@end
