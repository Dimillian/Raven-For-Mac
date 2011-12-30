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
    BOOL isDragging; 
    BOOL wantHide; 
    NSView *originalSuperView; 
    NSView *windowContentView; 
    NSRect originaleFrame; 
    NSPoint initialMousePosition; 
    NSPoint previousMousePosition; 
    NSImage *originaleImage; 
    int swapForce; 
    int previousSwapForce; 
}
-(void)setNewOriginaleFrame; 
-(void)sendMouseEntered:(id)sender; 
-(void)mouseDownLongPress:(id)sender;
-(void)sendCloseDelegate:(id)sender; 
-(void)sendHideDelegate:(id)sender; 
-(void)displayDraggingMod; 
-(void)displayNormalMod; 
-(void)moveToLocation:(NSPoint)location withInitialMousePosition:(NSPoint)position; 
-(void)popupMenuWithLocation:(NSPoint)location; 
-(void)setHideAfterDragginOperation:(BOOL)op; 
-(NSMenu *)getMenu; 
@property (nonatomic, assign) id<RASBAPPMainButtonDelegate> delegate;
@property int swapForce;
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

//dragging
-(void)beginDrag:(RASBAPPMainButton *)button; 
-(void)endDrag:(RASBAPPMainButton *)button; 
-(void)swapWithOtherButton:(RASBAPPMainButton *)button; 
-(void)swapUp:(RASBAPPMainButton *)button; 
-(void)swapDown:(RASBAPPMainButton *)button; 
-(void)dragout:(RASBAPPMainButton *)button; 
@end
