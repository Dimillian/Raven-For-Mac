//
//  DownloadDelegate.m
//  Raven
//
//  Created by Thomas Ricouard on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadDelegate.h"
#import "MainWindowController.h"
#import "RAlistManager.h"


@implementation DownloadDelegate

//******
//This class handle all the download process, need major revision, crash a lot, super ugly
//*******

-(void)downloadDidBegin:(NSURLDownload *)download
{
    NSURLRequest *request = [download request];
    //NSLog(@"%@:%@", [request mainDocumentURL], [request URL]);
    downloadUrl = [[request URL]absoluteString]; 
    if (download) {
        
    }
    [downloadUrl retain]; 
    DownloadController *controller = [DownloadController sharedUser]; 
    downloadIndex  = [controller.downloadArray count]; 
    [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadDidBegin" object:nil];
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSString *destinationFilename;
    NSString *homeDirectory = NSHomeDirectory();
    
    destinationFilename = [[homeDirectory stringByAppendingPathComponent:@"Downloads"]
                           stringByAppendingPathComponent:filename];
    [download setDestination:destinationFilename allowOverwrite:NO];
    downloadName = filename; 
    downloadPath = destinationFilename;
    [downloadPath retain];
}

- (void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
    downloadPath = path; 
    [downloadPath retain];
}

- (void)setDownloadResponse:(NSURLResponse *)aDownloadResponse
{
    [aDownloadResponse retain];
    
    // downloadResponse is an instance variable defined elsewhere.
    [downloadResponse release];
    downloadResponse = aDownloadResponse;
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    // Reset the progress, this might be called multiple times.
    // bytesReceived is an instance variable defined elsewhere.
    bytesReceived = 0;
    progressBytes = 0; 
    downloadName = @"Waiting for the filename..."; 
    percentage = [NSNumber numberWithInt:0]; 
    totalByes = [NSNumber numberWithInt:0]; 
    downloadPath = @"Waiting for the path...";
    progressBytes = [NSNumber numberWithInt:0]; 
    startTime = [NSDate timeIntervalSinceReferenceDate]; 
    
    // Retain the response to use later.
    [self setDownloadResponse:response];
    NSNumber *key = [NSNumber numberWithUnsignedInteger:downloadIndex]; 
    if (key != nil && downloadName != nil && percentage != nil && totalByes != nil && downloadPath != nil && progressBytes != nil && downloadUrl != nil) {
        DownloadObject *aDownload = [[DownloadObject alloc]initWithKey:key name:downloadName progress:percentage size:totalByes path:downloadPath progressBytes:progressBytes source:downloadUrl]; 
        DownloadController *controller = [DownloadController sharedUser]; 
        [controller AddADownloadToArray:aDownload];
        [aDownload release]; 
    }
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadDidUpdate" object:nil];
    long long expectedLength = [downloadResponse expectedContentLength];
    totalByes = [NSNumber numberWithLongLong:expectedLength]; 
    bytesReceived = bytesReceived + length;
    progressBytes = [NSNumber numberWithInteger:bytesReceived];  
    if (expectedLength != NSURLResponseUnknownLength) {
        // If the expected content length is
        // available, display percent complete.
        float percentComplete = (bytesReceived/(float)expectedLength)*100.0;
        int speed = [progressBytes doubleValue] / ([NSDate timeIntervalSinceReferenceDate] - startTime);
        speed = speed / 1024; 
        percentage = [NSNumber numberWithFloat:percentComplete]; 
        //NSLog(@"Percent complete - %@",percentage);
    } else {
        // If the expected content length is
        // unknown, just log the progress.
        //NSLog(@"Bytes received - %d",bytesReceived);
    }
    [progressBytes retain]; 
    [percentage retain]; 
    [totalByes retain]; 
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:downloadIndex]; 
    if (key != nil && downloadName != nil && percentage != nil && totalByes != nil && downloadPath != nil && progressBytes != nil && downloadUrl != nil) {
        DownloadObject *aDownload = [[DownloadObject alloc]initWithKey:key name:downloadName progress:percentage size:totalByes path:downloadPath progressBytes:progressBytes source:downloadUrl]; 
        DownloadController *controller = [DownloadController sharedUser]; 
        [controller replaceDownloadAtIndex:downloadIndex withDownload:aDownload];
        [aDownload release]; 
    }
    
}
- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    
}


-(void)downloadDidFinish:(NSURLDownload *)download
{
    DownloadController *controller = [DownloadController sharedUser]; 
    downloadIndex  = [controller.downloadArray count]; 
    //NSLog(@"Finish"); 
    if ([downloadPath hasSuffix:@"rpa.zip"] || [downloadPath hasSuffix:@"sba.zip"]) {
        RAlistManager *listManager = [[RAlistManager alloc]init];
        listManager.downloadPath = downloadPath;
        [listManager installApp]; 
    }
     [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadDidFinish" object:nil];

}




@end
