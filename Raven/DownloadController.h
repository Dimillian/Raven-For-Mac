//
//  DownloadController.h
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "url.h"
#import "DownloadObject.h"

@interface DownloadController : NSObject{
    NSString *path; 
    NSMutableArray *downloadArray; 
}
+(DownloadController *)sharedUser;
-(void)checkAndCreatePlist;
-(void)readDownloadFromPlist; 
-(void)writeDownloadInplist; 
-(void)AddADownloadToArray:(DownloadObject *)aDownload; 
-(void)replaceDownloadAtIndex:(NSUInteger )index withDownload:(DownloadObject *)aDownload; 
@property (nonatomic, retain) NSString *path; 
@property (nonatomic, assign) NSMutableArray *downloadArray; 

@end
