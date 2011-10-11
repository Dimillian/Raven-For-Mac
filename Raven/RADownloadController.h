//
//  DownloadController.h
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "url.h"
#import "RADownloadObject.h"

@interface RADownloadController : NSObject{
    NSString *path; 
}
-(NSMutableArray*) downloadArray;
-(void)checkAndCreatePlist;
/*
-(void)readDownloadFromPlist; 
-(void)writeDownloadInplist; 
-(void)AddADownloadToArray:(RADownloadObject *)aDownload; 
 */
-(void)replaceDownloadAtIndex:(NSUInteger )index withDownload:(RADownloadObject *)aDownload; 
@property (nonatomic, retain) NSString *path; 

@end
