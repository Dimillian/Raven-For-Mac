//
//  DownloadDelegate.m
//  Raven
//
//  Created by Thomas Ricouard on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RANSURLDownloadDelegate.h"
#import "RAMainWindowController.h"
#import "RAlistManager.h"


@implementation RANSURLDownloadDelegate

//******
//This class handle all the download process, need major revision, crash a lot, super ugly
//*******

-(void)downloadDidBegin:(NSURLDownload *)download
{
    trackDownload = YES;
    NSURLRequest *request = [download request];
    //NSLog(@"%@:%@", [request mainDocumentURL], [request URL]);
    downloadUrl = [[request URL]absoluteString]; 
    if ([downloadUrl hasSuffix:@"rpa.zip"] || [downloadUrl hasSuffix:@"sba.zip"]) {
        trackDownload = NO; 
    }
    if (download) {
        
    }
    [downloadUrl retain]; 
    if (trackDownload) {
        
        RADownloadController *controller = [[RADownloadController alloc]init]; 
        downloadIndex  = [[controller downloadArray]count]; 
        [controller release];
        if (trackDownload) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadDidBegin" object:nil];
        }
        
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
        NSNumber *key = [NSNumber numberWithUnsignedInteger:downloadIndex]; 
        if (key != nil && downloadName != nil && percentage != nil && totalByes != nil && downloadPath != nil && progressBytes != nil && downloadUrl != nil) {
            aDownload = [[RADownloadObject alloc]initWithKey:key name:downloadName progress:percentage size:totalByes path:downloadPath progressBytes:progressBytes source:downloadUrl]; 
            RADownloadController *controller = [[RADownloadController alloc]init]; 
            [[controller downloadArray]addObject:aDownload];
            [controller release];
        }
    }
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    // Retain the response to use later.
    [self setDownloadResponse:response];
}

- (void)setDownloadResponse:(NSURLResponse *)aDownloadResponse
{
    [aDownloadResponse retain];
    
    // downloadResponse is an instance variable defined elsewhere.
    [downloadResponse release];
    downloadResponse = aDownloadResponse;
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



- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    if (trackDownload) {
        long long expectedLength = [downloadResponse expectedContentLength];
        totalByes = [NSNumber numberWithLongLong:expectedLength]; 
        bytesReceived = bytesReceived + length;
        progressBytes = [NSNumber numberWithInteger:bytesReceived];  
        if (expectedLength != NSURLResponseUnknownLength) {
            // If the expected content length is
            // available, display percent complete.
            float percentComplete = (bytesReceived/(float)expectedLength)*100.0;
            //int speed = [progressBytes doubleValue] / ([NSDate timeIntervalSinceReferenceDate] - startTime);
            //speed = speed / 1024; 
            percentage = [NSNumber numberWithFloat:percentComplete]; 
            //NSLog(@"Percent complete - %@",percentage);
        } else {
            // If the expected content length is
            // unknown, just log the progress.
            //NSLog(@"Bytes received - %d",bytesReceived);
        }
        //[progressBytes retain]; 
        //[percentage retain]; 
        //[totalByes retain]; 
        [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadDidUpdate" object:nil];
        [self updateDownloadInformation];
    }
}

-(void)updateDownloadInformation
{
    NSNumber *key = [NSNumber numberWithUnsignedInteger:downloadIndex]; 
    if (key != nil && downloadName != nil && percentage != nil && totalByes != nil && downloadPath != nil && progressBytes != nil && downloadUrl != nil) {
        aDownload.key = key; 
        aDownload.name = downloadName;
        aDownload.progress = percentage; 
        aDownload.size= totalByes; 
        aDownload.path = downloadPath; 
        aDownload.progressBytes = progressBytes; 
        aDownload.downloadUrl = downloadUrl; 
        RADownloadController *controller = [[RADownloadController alloc]init]; 
        [controller replaceDownloadAtIndex:downloadIndex withDownload:aDownload];
        [controller release]; 
    }

}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    
}


-(void)downloadDidFinish:(NSURLDownload *)download
{   
    //NSLog(@"Finish"); 
    if ([downloadPath hasSuffix:@"rpa.zip"] || [downloadPath hasSuffix:@"sba.zip"]) {
        RAlistManager *listManager = [[RAlistManager alloc]init];
        listManager.downloadPath = downloadPath;
        [listManager installApp];
    }
    if (trackDownload) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadDidFinish" object:nil];
    }

}




@end