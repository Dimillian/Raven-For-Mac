//
//  RAGridViewDataSource.h
//  Raven
//
//  Created by Thomas Ricouard on 01/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAGridViewCell.h"

@protocol RAGridViewDataSource <NSObject>

@required
-(NSInteger)numberOfCell; 
-(NSInteger)numberofCellPerRow; 
-(RAGridViewCell *)cellForIndex:(NSInteger)index; 
@end
