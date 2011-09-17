//
//  RAppManagerWindow.m
//  Raven
//
//  Created by Thomas Ricouard on 17/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAppManagerWindow.h"
#import "RAappManagerPlistController.h"

@implementation RAppManagerWindow

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [tableview release];     
    [super dealloc];
}


-(void)awakeFromNib
{
    [tableview setDataSource:self]; 
    [tableview setDelegate:self];
    [tableview setAllowsEmptySelection:NO];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSString *path = [@"~/Library/Application Support/RavenApp/app/app.plist" stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:@"app"] mutableCopy];
    NSUInteger count = [folders count];
    [folders release]; 
    return count;
    
}



- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{  
    
    NSString *path = [@"~/Library/Application Support/RavenApp/app/app.plist" stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:@"app"] mutableCopy];
    NSDictionary *item = [folders objectAtIndex:row];
    NSString *appName = [item objectForKey:@"appname"];
    [folders release]; 
    return appName;
    
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSString *path = [@"~/Library/Application Support/RavenApp/app/app.plist" stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:@"app"] mutableCopy];
    NSDictionary *item = [folders objectAtIndex:[tableview selectedRow]];
    NSString *folderName = [item objectForKey:@"foldername"];
    [folderNameField setStringValue:[item objectForKey:@"foldername"]];
    [appNameField setStringValue:[item objectForKey:@"appname"]];
    NSArray *URL = [[item objectForKey:@"URL"]mutableCopy]; 
    [firstUrl setStringValue:[URL objectAtIndex:0]];
    [secondUrl setStringValue:[URL objectAtIndex:1]];
    [thirdUrl setStringValue:[URL objectAtIndex:2]];
    [fourUrl setStringValue:[URL objectAtIndex:3]];
    
    NSString *homeButtonPath = [NSString stringWithFormat:
                                @"~/Library/Application Support/RavenApp/app/%@/main.png", folderName];
    NSString *homeButtonBigPath = [NSString stringWithFormat:
                                   @"~/Library/Application Support/RavenApp/app/%@/main_big.png", folderName];
    NSString *firstImageOffPath = [NSString stringWithFormat:
                                   @"~/Library/Application Support/RavenApp/app/%@/1_off.png", folderName];
    NSString *firstImageOnPath = [NSString stringWithFormat:
                                  @"~/Library/Application Support/RavenApp/app/%@/1_on.png", folderName];
    NSString *secondImageOffPath = [NSString stringWithFormat:
                                    @"~/Library/Application Support/RavenApp/app/%@/2_off.png", folderName]; 
    NSString *secondImageOnPath = [NSString stringWithFormat:
                                   @"~/Library/Application Support/RavenApp/app/%@/2_on.png", folderName]; 
    NSString *thirdImageOffPath = [NSString stringWithFormat:
                                   @"~/Library/Application Support/RavenApp/app/%@/3_off.png", folderName]; 
    NSString *thirdImageOnPath = [NSString stringWithFormat:
                                  @"~/Library/Application Support/RavenApp/app/%@/3_on.png", folderName]; 
    NSString *fourImageOffPath = [NSString stringWithFormat:
                                  @"~/Library/Application Support/RavenApp/app/%@/4_off.png", folderName]; 
    NSString *fourImageOnPath = [NSString stringWithFormat:
                                 @"~/Library/Application Support/RavenApp/app/%@/4_on.png", folderName];
    
    [smallIcon setImage:[[[NSImage alloc]initWithContentsOfFile:[homeButtonPath stringByExpandingTildeInPath]]autorelease]];
    [bigIcon setImage:[[[NSImage alloc]initWithContentsOfFile:[homeButtonBigPath stringByExpandingTildeInPath]]autorelease]];
    [firstImageOff setImage:[[[NSImage alloc]initWithContentsOfFile:[firstImageOffPath stringByExpandingTildeInPath]]autorelease]];
    [firstImageOn setImage:[[[NSImage alloc]initWithContentsOfFile:[firstImageOnPath stringByExpandingTildeInPath]]autorelease]];
    [secondImageOff setImage:[[[NSImage alloc]initWithContentsOfFile:[secondImageOffPath stringByExpandingTildeInPath]]autorelease]];
    [secondImageOn setImage:[[[NSImage alloc]initWithContentsOfFile:[secondImageOnPath stringByExpandingTildeInPath]]autorelease]];
    [thirdImageOff setImage:[[[NSImage alloc]initWithContentsOfFile:[thirdImageOffPath stringByExpandingTildeInPath]]autorelease]];
    [thirdImageOn setImage:[[[NSImage alloc]initWithContentsOfFile:[thirdImageOnPath stringByExpandingTildeInPath]]autorelease]];
    [fourImageOff setImage:[[[NSImage alloc]initWithContentsOfFile:[fourImageOffPath stringByExpandingTildeInPath]]autorelease]];
    [fourimageOn setImage:[[[NSImage alloc]initWithContentsOfFile:[fourImageOnPath stringByExpandingTildeInPath]]autorelease]];
    
    [folders release]; 
    [URL release]; 
    
}

-(void)addAnApp:(id)sender
{
    RAappManagerPlistController *listManager = [[RAappManagerPlistController alloc]init];
    [listManager writeToPlistWithAppName:@"New app" folderName:@"Set the folder name" withURL1:@"URL1" URL2:@"URL2" URL3:@"URL3" URL4:@"URL4" atIndex:[tableview numberOfRows] +1];
    [listManager release]; 
    [tableview selectRowIndexes:[NSIndexSet indexSetWithIndex:[tableview numberOfRows]] byExtendingSelection:NO];
    [tableview reloadData];
}

-(void)saveApp:(id)sender
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupport = [[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@", [folderNameField stringValue]] stringByExpandingTildeInPath];
    //Check if exist, if not create the dir
    if ([fileManager fileExistsAtPath:applicationSupport] == NO)
        [fileManager createDirectoryAtPath:applicationSupport withIntermediateDirectories:YES attributes:nil error:nil];
    
    [[[firstImageOn image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/1_on.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[firstImageOff image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/1_off.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[secondImageOff image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/2_off.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[secondImageOn image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/2_on.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[thirdImageOff image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/3_off.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[thirdImageOn image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/3_on.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[fourImageOff image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/4_off.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[fourimageOn image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/4_on.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[smallIcon image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/main.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    [[[bigIcon image] TIFFRepresentation] writeToFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/app/%@/main_big.png", [folderNameField stringValue]]stringByExpandingTildeInPath] atomically:YES];
    RAappManagerPlistController *listManager = [[RAappManagerPlistController alloc]init];
    [listManager writeToPlistWithAppName:[appNameField stringValue] folderName:[folderNameField stringValue] withURL1:[firstUrl stringValue] URL2:[secondUrl stringValue] URL3:[thirdUrl stringValue] URL4:[fourUrl stringValue] atIndex:[tableview selectedRow]];
    [listManager release]; 
    [tableview reloadData];
    
}

-(void)deleteAnApp:(id)sender
{
    RAappManagerPlistController *listManager = [[RAappManagerPlistController alloc]init];
    [listManager deleteAppAtIndex:[tableview selectedRow]];
    [listManager release]; 
    [tableview reloadData];
}


@end
