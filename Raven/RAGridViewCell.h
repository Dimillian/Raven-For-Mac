//
//  RAGridViewCell.h
//  Raven
//
//  Created by Thomas Ricouard on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RASmartBarItem.h"

@protocol RAGridViewCellDelegate;

@interface RAGridViewCell : NSView
{
    id<RAGridViewCellDelegate> delegate;
    NSImageView *iconView;
    NSImageView *shadowView; 
    NSImageView *overlay; 
    NSButton *closeButton; 
    NSButton *removeButton; 
    NSButton *addButton; 
    
    NSTimer *timer; 
    
    NSTextField *textView; 
    RASmartBarItem *data; 
    
    BOOL inEditMod; 
}

-(id)initWithItem:(RASmartBarItem *)item; 
-(void)enableOverlay:(BOOL)cond; 
-(void)toggleEditMod:(BOOL)cond; 

-(void)closeButtonClicked:(id)sender; 
-(void)removeButtonClicked:(id)sender; 
-(void)addButtonClicked:(id)sender; 

@property (nonatomic, assign) id<RAGridViewCellDelegate> delegate;
@property (nonatomic, retain) RASmartBarItem *data; 
@end

@protocol RAGridViewCellDelegate
@optional
-(void)onCloseButtonClick:(RAGridViewCell *)item; 
-(void)onRemoveButtonClick:(RAGridViewCell *)item; 
-(void)onAddButtonClick:(RAGridViewCell *)item; 
-(void)onMouseDown:(RAGridViewCell *)item; 
@end

