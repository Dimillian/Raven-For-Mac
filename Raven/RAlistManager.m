//
//  RAlistManager.m
//  Raven
//
//  Created by Thomas Ricouard on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAlistManager.h"
#import "RavenAppDelegate.h"
#import "RAHiddenWindow.h"
@implementation RAlistManager
@synthesize downloadPath;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


//Basically import app from separate app.plist to main app.plist after checking it is a real app.
-(void)importAppAthPath:(NSString *)path
{
    NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
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
    [self updateProcess];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"newAppInstalled" object:nil];
}

//Check if the app is valid, if yes import it
-(BOOL)checkifAppIsValide:(NSString *)path
{
    NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    if (dict == nil) {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:NSLocalizedString(@"This Raven Application file is invalid.", @"invalideAppMessage")];
        [alert setInformativeText:NSLocalizedString(@"Please check the source of the file.", @"invalideAppContinur")];
        //[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        //call the alert and check the selected button
        [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Ok")];
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [alert release]; 
        return NO;
    }
    else {
        return YES;
    }

}

//used to update plist and maintain it up to date with all latest key pair, fired at each launch for beta period
-(void)updateProcess
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    for (int x=0; x<[folders count]; x++) {
        NSMutableDictionary *item = [folders objectAtIndex:x];
        if ([item objectForKey:PLIST_KEY_UDID] == nil) {
            NSString *udid = [NSString stringWithFormat:@"com.yourname.%@", [item objectForKey:PLIST_KEY_APPNAME]];
            [item setObject:udid forKey:PLIST_KEY_UDID];
        }
        if ([item objectForKey:PLIST_KEY_ENABLE] == nil){
            [item setObject:[NSNumber numberWithInt:1] forKey:PLIST_KEY_ENABLE];
        }
        if ([item objectForKey:PLIST_KEY_CATEGORY] == nil) {
            [item setObject:@"No category" forKey:PLIST_KEY_CATEGORY];
        }
        if ([[item objectForKey:PLIST_KEY_CATEGORY]isEqualToString:@"No categorie"]) {
            [item setObject:@"No category" forKey:PLIST_KEY_CATEGORY];
        }
        if ([item objectForKey:PLIST_KEY_OFFICIAL] == nil) {
            [item setObject:@"Unofficial" forKey:PLIST_KEY_OFFICIAL];
        }
        [folders replaceObjectAtIndex:x withObject:item];
    }
    [dict setObject:folders forKey:PLIST_KEY_DICTIONNARY];
    [dict writeToFile:path atomically:YES];
    [folders release]; 


}

//Fired by the download view, once app unziped, delete the zip
-(void)installApp
{
    [self UnzipFile:downloadPath];
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    [fileManager removeItemAtPath:downloadPath error:nil];

}

//if install is ok then import
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    if (returnCode == NSAlertFirstButtonReturn) {
        [self importAppAthPath:destinationPath];
        [fileManager removeItemAtPath:destinationPath error:nil];
    }
    else
    {
       [fileManager removeItemAtPath:destinationPath error:nil];  
    }
}

//unzip, and see if the user want to import it
- (void)UnzipFile:(NSString*)sourcePath
{
    NSString *downloadFolder = [@"~/Downloads" stringByExpandingTildeInPath];
    destinationPath = [sourcePath stringByReplacingOccurrencesOfString:@".zip" withString:@""];
    NSTask    *unzip = [[[NSTask alloc] init] autorelease];
    [unzip setLaunchPath:@"/usr/bin/unzip"];
    [unzip setArguments:[NSArray arrayWithObjects:@"-o", sourcePath, @"-d", downloadFolder, nil]];
    [unzip launch];
    [unzip waitUntilExit];
    BOOL success = [self checkifAppIsValide:destinationPath]; 
    if (success) {
        NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", destinationPath];
        [destinationPath retain];
        NSDictionary*dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
        NSString *appname = [NSString stringWithFormat:@"Would you like to install this web app? %@",[dict objectForKey:PLIST_KEY_APPNAME]];
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:appname];
        NSImage *icon = [[NSImage alloc]initWithContentsOfFile:
                         [NSString stringWithFormat:@"%@/main.png", destinationPath]];
        [destinationPath retain];
        [alert setIcon:icon];
        //[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        //call the alert and check the selected button
        [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Yeah")];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        [alert release]; 
        [icon release]; 
    }
}


-(void)checkforDuplicateFromApp:(NSString *)sourcePath
{
    
}


-(void)swapObjectAtIndex:(NSInteger)index upOrDown:(NSInteger)order
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY]mutableCopy];
    if (order == 1 && index+1 < [folders count]) {
        id tempA = [folders objectAtIndex:index];
        id tempB = [folders objectAtIndex:index + 1];
        [folders replaceObjectAtIndex:index withObject:tempB];
        [folders replaceObjectAtIndex:index+1 withObject:tempA];
    }
    else if (order == 0 && index > 0)
    {
        id tempA = [folders objectAtIndex:index];
        id tempB = [folders objectAtIndex:index - 1];
        [folders replaceObjectAtIndex:index withObject:tempB];
        [folders replaceObjectAtIndex:index-1 withObject:tempA];
    }
    [dict setObject:folders forKey:PLIST_KEY_DICTIONNARY];
    [dict writeToFile:path atomically:YES];
    [folders release];
    
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY]mutableCopy];
    if (to != from) {
        id obj = [folders objectAtIndex:from];
        [obj retain];
        [folders removeObjectAtIndex:from];
        if (to >= [folders count]) {
            [folders addObject:obj];
        } else {
            [folders insertObject:obj atIndex:to];
        }
        [obj release];
    }
    [dict setObject:folders forKey:PLIST_KEY_DICTIONNARY];
    [dict writeToFile:path atomically:YES];
    [folders release];
}

-(void)changeStateOfAppAtIndex:(NSInteger)index withState:(NSInteger)state
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSMutableDictionary *item = [folders objectAtIndex:index]; 
    [item setObject:[NSNumber numberWithInteger:state] forKey:PLIST_KEY_ENABLE];
    [folders replaceObjectAtIndex:index withObject:item];
    [dict setObject:folders forKey:PLIST_KEY_DICTIONNARY]; 
    [dict writeToFile:path atomically:YES];
    [folders release]; 
    
    
    
}


-(NSInteger)returnStateOfAppAtIndex:(NSInteger)index
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSMutableDictionary *item = [folders objectAtIndex:index]; 
    NSNumber *state = [item objectForKey:PLIST_KEY_ENABLE]; 
    [folders release];
    return [state integerValue];
    
}

-(void)deleteAppAtIndex:(NSInteger)index
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSMutableDictionary *appToDelete = [folders objectAtIndex:index];
    NSString *folderName = [appToDelete objectForKey:PLIST_KEY_FOLDER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[[NSString stringWithFormat:application_support_path@"%@", folderName]stringByExpandingTildeInPath] error:nil];
    [folders removeObjectAtIndex:index];
    [dict setObject:folders forKey:PLIST_KEY_DICTIONNARY];
    [dict writeToFile:path atomically:YES];
    [folders release]; 
    
}


@end
