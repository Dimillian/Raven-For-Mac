//
//  RAGridScrollView.h
//  Raven
//
//  Created by Thomas Ricouard on 01/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAGridViewCell.h"
#import "RAGridViewDataSource.h"
#import "RAGridViewContentView.h"

@protocol RAGridScrollViewDelegate; 
@interface RAGridScrollView : NSScrollView <RAGridViewCellDelegate>
{
    id<RAGridViewDataSource> _dataSource; 
    id<RAGridScrollViewDelegate> _delegate; 
    RAGridViewContentView *contentView; 
}
@property (nonatomic, assign) id<RAGridScrollViewDelegate>delegate; 
@property (nonatomic, assign) id<RAGridViewDataSource>dataSource; 
-(void)redraw; 
-(CGFloat)getXbase;
@end

@protocol RAGridScrollViewDelegate <NSObject>
@optional
-(void)didSelectCell:(RAGridViewCell *)cell atIndex:(NSInteger)index; 
@required
-(void)didClickOnCellCloseButton:(RAGridViewCell *)cell; 
-(void)didClickOnCellRemoveButton:(RAGridViewCell *)cell; 
-(void)didMouseDownOnCell:(RAGridViewCell *)cell; 
-(void)didClickOnCellAddButton:(RAGridViewCell *)cell; 
@end
