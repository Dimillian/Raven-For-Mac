//
//  RATabItem.h
//  Raven
//
//  Created by Thomas Ricouard on 14/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RATabView.h"
#import "RAWebViewController.h"


@protocol RATabItemDelegate; 
@class RANavigatorViewController;
@interface RATabItem : NSObject <RATabViewDelegate, RAWebViewControllerDelegate>
{
    id<RATabItemDelegate> delegate; 
    RAWebViewController *_webViewController; 
    RATabView *_tabView; 
}
-(void)callView; 
-(void)prepareTabClose; 
-(void)setWebViewDelegate:(RANavigatorViewController *)controller; 
@property (nonatomic, assign) id<RATabItemDelegate> delegate; 
@property (nonatomic, retain) RAWebViewController *webViewController; 
@property (nonatomic, retain) RATabView *tabView; 

@end

@protocol RATabItemDelegate
@required
-(void)tabItemWillClose:(RATabItem *)tab;
-(void)tabItemDidSelect:(RATabItem *)tab;
-(void)tabItemDidMoveLeft:(RATabItem *)tab; 
-(void)tabItemDidMoveRight:(RATabItem *)tab;
-(void)tabItemDidStartDragging:(RATabItem *)tab; 
-(void)tabItemDidStopDragging:(RATabItem *)tab; 
-(void)tabItemRequestANewTab:(RATabItem *)tab; 
@end