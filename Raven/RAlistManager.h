//
//  RAlistManager.h
//  Raven
//
//  Created by Thomas Ricouard on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAlistManager : NSObject

-(BOOL)importAppAthPath:(NSString *)path;
-(void)updateProcess; 

@end
