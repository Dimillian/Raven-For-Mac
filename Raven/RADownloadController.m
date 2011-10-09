//
//  DownloadController.m
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//******
//This class is a singleton that handle the downloadArray and interact with it, it populate the download view.. Super ugly
//*******

#import "RADownloadController.h"


@implementation RADownloadController
@synthesize path, downloadArray;
static RADownloadController *sharedUserManager = nil;

+(RADownloadController *)sharedUser
{
    if (sharedUserManager == nil) {
        sharedUserManager = [[super allocWithZone:NULL] init];

    }
    return sharedUserManager; 
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedUser] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}


-(void)checkAndCreatePlist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupport = [[NSString stringWithString:@"~/Library/Application Support/RavenApp"] stringByExpandingTildeInPath];
    //Check if exist, if not create the dir
    if ([fileManager fileExistsAtPath:applicationSupport] == NO)
        [fileManager createDirectoryAtPath:applicationSupport withIntermediateDirectories:YES attributes:nil error:nil];
    
    path = [applicationSupport stringByAppendingPathComponent:downloadPlist]; 
    [path retain]; 
    BOOL succes; 
    succes = [fileManager fileExistsAtPath:path]; 
    
	if(succes) return;
    
    
    NSString *plistDownloadPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:downloadPlist];
    
    [fileManager copyItemAtPath:plistDownloadPath toPath:path error:nil];
    
    fileManager = nil; 
	[fileManager release];
    

    
    
}

-(void)readDownloadFromPlist
{
    downloadArray = [[[NSMutableArray alloc]initWithContentsOfFile:path]retain]; 
}

-(void)writeDownloadInplist
{
    NSNumber *number = [NSNumber numberWithInt:10]; 
    RADownloadObject *object = [[RADownloadObject alloc]initWithKey:number name:@"hey" progress:number size:number path:@"hey" progressBytes:number source:@"Jey"]; 
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:object]; 
    [downloadArray addObject:objectData]; 
    [object release]; 
    [downloadArray writeToFile:path atomically:YES]; 
}

-(void)AddADownloadToArray:(RADownloadObject *)aDownload
{
    if (downloadArray == nil) {
    downloadArray = [[NSMutableArray alloc]init];
    }
    [downloadArray addObject:aDownload]; 
}

-(void)replaceDownloadAtIndex:(NSUInteger)index withDownload:(RADownloadObject *)aDownload
{
    [downloadArray replaceObjectAtIndex:index withObject:aDownload]; 
}
-(void)dealloc
{
    [super dealloc]; 
}
@end
