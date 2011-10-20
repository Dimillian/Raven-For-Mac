//
//  HistorySplitView.m
//  Raven
//
//  Created by Thomas Ricouard on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASplitView.h"

@implementation RASplitView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(CGFloat)dividerThickness
{
    return 0.0; 
}

-(NSColor *)dividerColor
{
    return [NSColor blackColor]; 
}

-(NSSplitViewDividerStyle)dividerStyle
{
    return 2; 
}


@end
