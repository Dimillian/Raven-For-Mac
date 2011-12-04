//
//  DownloadDelegate.h
//  Raven
//
//  Created by Thomas Ricouard on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "RADownloadController.h"
#import "RADownloadObject.h"

@protocol RANSURLDownloadActionDelegate;
@interface RANSURLDownloadDelegate : NSObject <NSAlertDelegate, NSURLDownloadDelegate>{
    id<RANSURLDownloadActionDelegate>delegate; 
    NSString *_downloadPath;
    NSString *_downloadUrl; 
    NSUInteger downloadIndex; 
    NSData *downloadBlob; 
    NSNumber *_totalByes; 
    NSNumber *_progressBytes; 
    NSNumber *_percentage; 
    NSString *_downloadName;
    NSInteger bytesReceived;
    NSURLResponse *downloadResponse;
    NSTimeInterval startTime; 
    RADownloadObject *aDownload;
    BOOL trackDownload; 
}
-(void)setDownloadResponse:(NSURLResponse *)aDownloadResponse;
-(void)updateDownloadInformation; 
@property (nonatomic, assign) id<RANSURLDownloadActionDelegate>delegate; 
@property (nonatomic, retain) NSString *downloadPath; 
@property (nonatomic, retain) NSString *downloadName;
@property (nonatomic, retain) NSString *downloadUrl; 
@property (nonatomic, retain) NSNumber *totalByes; 
@property (nonatomic, retain) NSNumber *ProgressBytes; 
@property (nonatomic, retain) NSNumber *percentage; 


@end

@protocol RANSURLDownloadActionDelegate
-(void)DownloadDelegateDidFinishJob:(RANSURLDownloadDelegate *)RAdownloadDelegate; 
@end