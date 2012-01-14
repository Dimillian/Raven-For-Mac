//
//  RATabView.h
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol RATabPlaceHolderDelegate;
@interface RATabPlaceholderView : NSView
{   
    
     id<RATabPlaceHolderDelegate> delegate;
}

-(id)initWithDelegate:(id<RATabPlaceHolderDelegate>)dgate;
@property (nonatomic, assign) id<RATabPlaceHolderDelegate> delegate;
@end

@protocol RATabPlaceHolderDelegate
@optional
- (void)didReceiveDoubleClick:(RATabPlaceholderView *)view;
@end