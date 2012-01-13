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
@synthesize downloadPath = _downloadPath, destinationPath = _destinationPath;
static RAlistManager *sharedUserManager = nil;

#pragma mark Singleton management
+(RAlistManager *)sharedUser
{
    if (sharedUserManager == nil) {
        sharedUserManager = [[[self class] alloc] init];
    }
    return sharedUserManager; 
}

#pragma mark -
#pragma mark File and memory management
-(NSMutableArray *)readAppList
{
    if (!appPlistDictionnary) {
        NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
        appPlistDictionnary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    }
    if (appPlistArray) { 
        [appPlistArray release], appPlistArray = nil; 
    }
    appPlistArray = [[NSMutableArray alloc]initWithArray:
                     [appPlistDictionnary objectForKey:PLIST_KEY_DICTIONNARY]];
    return appPlistArray;
    
}

-(void)forceReadApplist
{
    if (appPlistDictionnary) {
        [appPlistDictionnary release], appPlistDictionnary = nil; 
    }
    appPlistDictionnary = [[NSMutableDictionary alloc]initWithContentsOfFile:[PLIST_PATH stringByExpandingTildeInPath]];
    if (appPlistArray) { 
        [appPlistArray release], appPlistArray = nil; 
    }
    appPlistArray = [[NSMutableArray alloc]initWithArray:
                     [appPlistDictionnary objectForKey:PLIST_KEY_DICTIONNARY]];
    
      
}

-(void)writeNewAppListInMemory:(NSMutableArray *)appList writeToFile:(BOOL)flag
{
    if (appList != nil) {
        [appPlistDictionnary setObject:appList forKey:PLIST_KEY_DICTIONNARY];
    }

    if(flag){
        NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
        [appPlistDictionnary writeToFile:path atomically:NO];
    }
}

#pragma mark -
#pragma mark Standard Operation

//Basically import app from separate app.plist to main app.plist after checking it is a real app.
//Need to check for duplicate and replace if yes 
-(void)importAppAthPath:(NSString *)path
{
    [self writeNewAppListInMemory:[self readAppList] writeToFile:YES];

    BOOL newApp;
    NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    NSString *appFolder = [dict objectForKey:PLIST_KEY_FOLDER];
    NSString *appPlist = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dictToEdit = [NSMutableDictionary dictionaryWithContentsOfFile:appPlist];
    NSMutableArray *folders = [[dictToEdit objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSInteger indexIfExit = [self checkForDuplicate:[dict objectForKey:PLIST_KEY_UDID]];
    if (indexIfExit == -1) {
        [folders addObject:dict];
        newApp = YES;
    }
    else
    {
        [folders replaceObjectAtIndex:indexIfExit withObject:dict];
        newApp = NO;
    }
    [self writeNewAppListInMemory:folders writeToFile:YES];
    [folders release];
    NSString *applicationSupportPath = [[NSString stringWithFormat:application_support_path@"%@", appFolder]stringByExpandingTildeInPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager copyItemAtPath:path toPath:applicationSupportPath error:nil];
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/app.plist", applicationSupportPath] error:nil];
    [self updateProcess];
    if (newApp) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NEW_APP_INSTALLED object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_UPDATED object:nil];

    }
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
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
    [self forceReadApplist];
    NSMutableArray *folders = [self readAppList];
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
    [self writeNewAppListInMemory:folders writeToFile:YES];
    [self forceReadApplist];
}

//Fired by the download view, once app unziped, delete the zip
-(void)installApp
{
    [self UnzipFile:self.downloadPath];
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    [fileManager removeItemAtPath:self.downloadPath error:nil];

}

//if install is ok then import
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    if (returnCode == NSAlertFirstButtonReturn) {
        [self importAppAthPath:self.destinationPath];
        [fileManager removeItemAtPath:self.destinationPath error:nil];
    }
    else
    {
       [fileManager removeItemAtPath:self.destinationPath error:nil];  
    }
}

//unzip, and see if the user want to import it
- (void)UnzipFile:(NSString*)sourcePath
{
    NSString *downloadFolder = [@"~/Downloads" stringByExpandingTildeInPath];
    self.destinationPath = [sourcePath stringByReplacingOccurrencesOfString:@".zip" withString:@""];
    NSTask    *unzip = [[[NSTask alloc] init] autorelease];
    [unzip setLaunchPath:@"/usr/bin/unzip"];
    [unzip setArguments:[NSArray arrayWithObjects:@"-o", sourcePath, @"-d", downloadFolder, nil]];
    [unzip launch];
    [unzip waitUntilExit];
    BOOL success = [self checkifAppIsValide:self.destinationPath]; 
    if (success) {
        NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", self.destinationPath];
        NSDictionary*dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
        NSString *appname = [NSString stringWithFormat:@"Would you like to install this web app? %@",[dict objectForKey:PLIST_KEY_APPNAME]];
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:appname];
        [alert setInformativeText:@"If you already have this app installed it will just be replaced and updated"];
        NSImage *icon = [[NSImage alloc]initWithContentsOfFile:
                         [NSString stringWithFormat:@"%@/main.png", self.destinationPath]];
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


-(NSInteger)checkForDuplicate:(NSString *)Identifier
{
    NSMutableArray *folders = [self readAppList];
    for (int x=0; x<[folders count]; x++) {
        NSMutableDictionary *item = [folders objectAtIndex:x];
        if ([[item objectForKey:PLIST_KEY_UDID]isEqualToString:Identifier]) {
            return x; 
        }
    }
    return -1; 
}


-(void)swapObjectAtIndex:(NSInteger)index upOrDown:(NSInteger)order
{
    NSMutableArray *folders = [self readAppList];
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
    [self writeNewAppListInMemory:folders writeToFile:NO];
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    NSMutableArray *folders = [self readAppList];
    [folders moveObjectFromIndex:from toIndex:to]; 
    [self writeNewAppListInMemory:folders writeToFile:NO];
} 

-(void)changeStateOfAppAtIndex:(NSInteger)index withState:(NSInteger)state
{
    NSMutableArray *folders = [self readAppList];
    NSMutableDictionary *item = [folders objectAtIndex:index]; 
    [item setObject:[NSNumber numberWithInteger:state] forKey:PLIST_KEY_ENABLE];
    [folders replaceObjectAtIndex:index withObject:item];
    [self writeNewAppListInMemory:folders writeToFile:NO];
    //RAMainWindowController *mainWindow = [[NSApp keyWindow]windowController];
    //[mainWindow hideAppAtIndex:index];
}


-(NSInteger)returnStateOfAppAtIndex:(NSInteger)index
{
    NSMutableArray *folders = [self readAppList];
    NSMutableDictionary *item = [folders objectAtIndex:index]; 
    NSNumber *state = [item objectForKey:PLIST_KEY_ENABLE]; 
    return [state integerValue];
    
}

-(void)deleteAppAtIndex:(NSInteger)index
{
    NSMutableArray *folders = [self readAppList];
    NSMutableDictionary *appToDelete = [folders objectAtIndex:index];
    NSString *folderName = [appToDelete objectForKey:PLIST_KEY_FOLDER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[[NSString stringWithFormat:application_support_path@"%@", folderName]stringByExpandingTildeInPath] error:nil];
    [folders removeObjectAtIndex:index];
    [self writeNewAppListInMemory:folders writeToFile:YES];
    [self forceReadApplist];
    
}


@end
