//
//  DownloadDelegate.h
//  Raven
//
//  Created by Thomas Ricouard on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "DownloadController.h"
#import "DownloadObject.h"

@interface DownloadDelegate : NSObject <NSAlertDelegate>{
    NSString *downloadPath;
    NSString *downloadUrl; 
    NSUInteger downloadIndex; 
    NSData *downloadBlob; 
    NSNumber *totalByes; 
    NSNumber *progressBytes; 
    NSNumber *percentage; 
    NSString *downloadName;
    NSInteger bytesReceived;
    NSURLResponse *downloadResponse;
    NSTimeInterval startTime; 
}
@end
