//
//  TabButtonControlle.m
//  Raven
//
//  Created by Thomas Ricouard on 24/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabButtonControlle.h"



@implementation TabButtonControlle //don't ask why there is no 'r', I don't know
@synthesize tabButton, background, pageTitle, favicon, closeButton, progress; 

-(void)awakeFromNib
{
        [tabButton setToolTip:[self title]]; 
}

//SPAAAAAACE

- (void)dealloc
{
    [super dealloc];
}

@end
