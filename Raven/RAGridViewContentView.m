//
//  RAGridViewContentView.m
//  Raven
//
//  Created by Thomas Ricouard on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAGridViewContentView.h"

@implementation RAGridViewContentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

-(BOOL)isFlipped
{
    return YES; 
}
@end
