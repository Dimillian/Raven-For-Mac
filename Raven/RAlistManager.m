//
//  RAlistManager.m
//  Raven
//
//  Created by Thomas Ricouard on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAlistManager.h"

@implementation RAlistManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)importAppAthPath:(NSString *)path
{
    NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    if (dict == nil) {
        return NO;
    }
    else {
        NSString *appFolder = [dict objectForKey:PLIST_KEY_FOLDER];
        NSString *appPlist = [PLIST_PATH stringByExpandingTildeInPath];
        NSMutableDictionary *dictToEdit = [NSMutableDictionary dictionaryWithContentsOfFile:appPlist];
        NSMutableArray *folders = [[dictToEdit objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
        [folders addObject:dict];
        [dictToEdit setObject:folders forKey:PLIST_KEY_DICTIONNARY];
        [dictToEdit writeToFile:appPlist atomically:YES];
        [folders release];
        NSString *applicationSupportPath = [[NSString stringWithFormat:application_support_path@"%@", appFolder]stringByExpandingTildeInPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:path toPath:applicationSupportPath error:nil];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/app.plist", applicationSupportPath] error:nil];
        return YES;
    }
}


-(void)updateProcess
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSInteger count  = [folders count];
    NSInteger x; 
    for (x=0; x<count; x++) {
        NSMutableDictionary *item = [folders objectAtIndex:x];
        if ([item objectForKey:PLIST_KEY_UDID] == nil) {
            NSString *udid = [NSString stringWithFormat:@"com.yourname.%@", [item objectForKey:PLIST_KEY_APPNAME]];
            [item setObject:udid forKey:PLIST_KEY_UDID];
        }
        if ([item objectForKey:PLIST_KEY_ENABLE] == nil){
            [item setObject:[NSNumber numberWithInt:1] forKey:PLIST_KEY_ENABLE];
        }
        [folders replaceObjectAtIndex:x withObject:item];
    }
    [dict setObject:folders forKey:PLIST_KEY_DICTIONNARY];
    [dict writeToFile:path atomically:YES];
    [folders release]; 


}
@end
