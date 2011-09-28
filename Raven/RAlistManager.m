//
//  RAlistManager.m
//  Raven
//
//  Created by Thomas Ricouard on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAlistManager.h"
#import "RavenAppDelegate.h"

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
    RavenAppDelegate *delegate =  (RavenAppDelegate *)[[NSApplication sharedApplication] delegate];
    [delegate refreshWindow];
}

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

-(void)installApp
{
    [self UnzipFile:downloadPath];
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    [fileManager removeItemAtPath:downloadPath error:nil];

}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        [self importAppAthPath:destinationPath];
        NSFileManager *fileManager = [NSFileManager defaultManager]; 
        [fileManager removeItemAtPath:destinationPath error:nil];
    }
}

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
        NSString *appname = [NSString stringWithFormat:@"You have downloaded this Raven Smart Bar Application? \n        %@",[dict objectForKey:PLIST_KEY_APPNAME]];
        
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:appname];
        NSImage *icon = [[NSImage alloc]initWithContentsOfFile:
                         [NSString stringWithFormat:@"%@/main.png", destinationPath]];
        [destinationPath retain];
        [alert setIcon:icon];
        [alert setInformativeText:NSLocalizedString(@"Would you like to install this application ?", @"promptInstallFromWebContinue")];
        //[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        //call the alert and check the selected button
        [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yeah")];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        [alert release]; 
        [icon release]; 
    }

    
}

-(void)checkforDuplicateFromApp:(NSString *)sourcePath
{
    
}
@end
