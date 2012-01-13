//
//  RATabView.h
//  Raven
//
//  Created by Thomas Ricouard on 12/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol RATabButtonDelegate; 
@interface RATabButton : NSButton
{
    id<RATabButtonDelegate> delegate; 
    BOOL isDragging; 
    BOOL isDown;
    NSPoint initialMousePosition; 
    NSPoint previousMousePosition; 
    int swapForce; 
    int previousSwapForce; 
    NSView *originalSuperView; 

}
-(void)moveToLocation:(NSPoint)location withInitialMousePosition:(NSPoint)position; 
@property (nonatomic, assign) id<RATabButtonDelegate> delegate; 
@end

@protocol RATabButtonDelegate
@optional
-(void)beginDrag:(RATabButton *)button; 
-(void)endDrag:(RATabButton *)button; 
-(void)swapUp:(RATabButton *)button; 
-(void)swapDown:(RATabButton *)button; 
@end
