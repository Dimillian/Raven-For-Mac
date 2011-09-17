//
//  RAappManagerPlistController.h
//  Raven
//
//  Created by Thomas Ricouard on 17/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAappManagerPlistController : NSObject
{
    
}

-(void)writeToPlistWithAppName:(NSString *)appname folderName:(NSString *)folderName 
                      withURL1:(NSString *)URL1 
                          URL2:(NSString *)URL2 
                          URL3:(NSString *)URL3 
                          URL4:(NSString *)URL4 
                       atIndex:(NSInteger)index;

-(void)deleteAppAtIndex:(NSInteger)index; 



@end
