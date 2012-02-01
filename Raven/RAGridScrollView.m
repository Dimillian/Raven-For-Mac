//
//  RAGridScrollView.m
//  Raven
//
//  Created by Thomas Ricouard on 01/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RAGridScrollView.h"

#define top_margin 50
#define left_margin 0; 
#define x_space 200; 
#define y_space 150; 
#define content_view_width 925
#define scroller_size 10
#define less_than_five_icon_diviser 2.2
#define icon_less_five_dist 90

@implementation RAGridScrollView
@synthesize delegate = _delegate, dataSource = _dataSource; 

-(id)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect]; 
    if (self) {
    }
    return self; 
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc]; 
}

-(void)redraw
{
    NSInteger row = 0;  
    CGFloat h = top_margin; 
    CGFloat x_iconView = [self getXbase]; 
    for (NSInteger i = 0; i<[_dataSource numberOfCell]; i++) {
        RAGridViewCell *cell = [_dataSource cellForIndex:i]; 
        [self.contentView addSubview:cell];
        [cell setFrameOrigin:NSMakePoint(x_iconView, h)];
        x_iconView = x_iconView + x_space; 
        row = row +1;
        if (row == [_dataSource numberofCellPerRow]) {
            h = h + y_space;
            x_iconView = [self getXbase]; 
            row = 0; 
        }
    }
    h = h + y_space;
    CGFloat final_h = 0; 
    CGFloat final_w = 0; 
    
    (self.frame.size.height < h) ? (final_h = h + top_margin) : (final_h = self.frame.size.height - scroller_size); 
    (self.frame.size.width < content_view_width) ? (final_w = content_view_width) : (final_w = self.frame.size.width - scroller_size);
    
    [self.contentView.documentView setFrameSize:NSMakeSize(final_w, final_h)]; 

}

-(CGFloat)getXbase
{
    CGFloat x_base_iconview = 0; 
    if ([_dataSource numberOfCell] <= 4)
    {
        float substrate = 40; 
        for (NSUInteger i = 0; i<[_dataSource numberOfCell]; i++) {
            if (i!=0) {
                substrate = substrate + icon_less_five_dist; 
            }
            x_base_iconview = self.frame.size.width/less_than_five_icon_diviser - substrate;
        }
    }
    else{
        if (self.frame.size.width > content_view_width) {
            x_base_iconview = (self.frame.size.width - content_view_width)/2;
        }
    }
    return x_base_iconview; 
}

#pragma mark - RAGridViewCellDelegate

-(void)onCloseButtonClick:(RAGridViewCell *)item
{
    [_delegate didClickOnCellCloseButton:item]; 
}

-(void)onRemoveButtonClick:(RAGridViewCell *)item
{
    [_delegate didClickOnCellRemoveButton:item]; 
}

-(void)onAddButtonClick:(RAGridViewCell *)item
{    
    [_delegate didClickOnCellAddButton:item]; 
}

-(void)onMouseDown:(RAGridViewCell *)item
{
    [_delegate didMouseDownOnCell:item]; 
}


@end
