//
//  RATabView.h
//  Raven
//
//  Created by Thomas Ricouard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol RATabViewDelegate;
@interface RATabPlaceholderView : NSView
{   
    
     id<RATabViewDelegate> delegate;
}

-(id)initWithDelegate:(id<RATabViewDelegate>)dgate;
@property (nonatomic, assign) id<RATabViewDelegate> delegate;
@end

@protocol RATabViewDelegate
@optional
- (void)didReceiveDoubleClick:(RATabPlaceholderView *)view;
@end