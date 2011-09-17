//
//  RAappManagerPlistController.m
//  Raven
//
//  Created by Thomas Ricouard on 17/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAappManagerPlistController.h"

@implementation RAappManagerPlistController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)writeToPlistWithAppName:(NSString *)appname folderName:(NSString *)folderName 
                      withURL1:(NSString *)URL1 URL2:(NSString *)URL2 URL3:(NSString *)URL3 URL4:(NSString *)URL4 atIndex:(NSInteger)index
{
    NSString *path = [@"~/Library/Application Support/RavenApp/app/app.plist" stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:@"app"] mutableCopy];
    if (index > [folders count]) {
        NSMutableArray *URLs = [[NSMutableArray alloc]initWithCapacity:4];
        NSMutableDictionary *newapp= [[NSMutableDictionary alloc]initWithCapacity:3];
        [newapp setObject:appname forKey:@"appname"];
        [newapp setObject:folderName forKey:@"foldername"];
        [URLs addObject:URL1];
        [URLs addObject:URL2];
        [URLs addObject:URL3];
        [URLs addObject:URL4];
        [newapp setObject:URLs forKey:@"URL"];
        [folders addObject:newapp];
        [dict setObject:folders forKey:@"app"];
        [dict writeToFile:path atomically:YES];
        [URLs release]; 
        [newapp release]; 
        [folders release]; 
    }
    else
    {
        NSMutableDictionary *item = [folders objectAtIndex:index];
        NSMutableArray *URL = [item objectForKey:@"URL"];
        [item setObject:appname forKey:@"appname"]; 
        [item setObject:folderName forKey:@"foldername"]; 
        [URL removeAllObjects]; 
        [URL addObject:URL1]; 
        [URL addObject:URL2]; 
        [URL addObject:URL3]; 
        [URL addObject:URL4]; 
        [item setObject:URL forKey:@"URL"]; 
        [dict writeToFile:path atomically:YES];
        [folders release]; 
        
        
        
    }
    
    
    
}

-(void)deleteAppAtIndex:(NSInteger)index
{
    NSString *path = [@"~/Library/Application Support/RavenApp/app/app.plist" stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:@"app"] mutableCopy];
    [folders removeObjectAtIndex:index];
    [dict setObject:folders forKey:@"app"];
    [dict writeToFile:path atomically:YES];
    [folders release]; 
    
}

@end

