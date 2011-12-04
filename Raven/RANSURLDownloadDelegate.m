//
//  DownloadDelegate.m
//  Raven
//
//  Created by Thomas Ricouard on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//******
//This class handle all the download process, need major revision, crash a lot, super ugly
//*******

#import "RANSURLDownloadDelegate.h"
#import "RAMainWindowController.h"
#import "RAlistManager.h"
#import "RavenAppDelegate.h"

@implementation RANSURLDownloadDelegate
@synthesize delegate; 
@synthesize downloadUrl = _downloadUrl, downloadName = _downloadName, downloadPath = _downloadPath, totalByes = _totalByes, percentage = _percentage, ProgressBytes = _progressBytes; 
-(void)downloadDidBegin:(NSURLDownload *)download
{
    trackDownload = YES;
    NSURLRequest *request = [download request];
    //NSLog(@"%@:%@", [request mainDocumentURL], [request URL]);
    self.downloadUrl = [[request URL]absoluteString]; 
    if ([self.downloadUrl hasSuffix:@"rpa.zip"] || [self.downloadUrl hasSuffix:@"sba.zip"]) {
        trackDownload = NO; 
    }
    if (download) {
        
    }
    if (trackDownload) {
        
        RADownloadController *controller = [[RADownloadController alloc]init]; 
        downloadIndex  = [[controller downloadArray]count]; 
        [controller release];
        if (trackDownload) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DOWNLOAD_BEGIN object:nil];
        }
        // Reset the progress, this might be called multiple times.
        // bytesReceived is an instance variable defined elsewhere.
        bytesReceived = 0;
        self.ProgressBytes = 0; 
        self.downloadName = @"Waiting for the filename..."; 
        self.percentage = [NSNumber numberWithInt:0]; 
        self.totalByes = [NSNumber numberWithInt:0]; 
        self.downloadPath = @"Waiting for the path...";
        self.progressBytes = [NSNumber numberWithInt:0]; 
        startTime = [NSDate timeIntervalSinceReferenceDate]; 
        NSNumber *key = [NSNumber numberWithUnsignedInteger:downloadIndex]; 
        if (key != nil && self.downloadName != nil && self.percentage != nil && self.totalByes != nil && self.downloadPath != nil && self.ProgressBytes != nil && self.downloadUrl != nil) {
            aDownload = [[RADownloadObject alloc]initWithKey:key name:self.downloadName progress:self.percentage size:self.totalByes path:self.downloadPath progressBytes:self.ProgressBytes source:self.downloadUrl]; 
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
    if(filename != nil){self.downloadName = filename;}
    self.downloadPath = destinationFilename;
}

- (void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
    self.downloadPath = path; 
}



- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    if (trackDownload) {
        long long expectedLength = [downloadResponse expectedContentLength];
        self.totalByes = [NSNumber numberWithLongLong:expectedLength]; 
        bytesReceived = bytesReceived + length;
        self.progressBytes = [NSNumber numberWithInteger:bytesReceived];  
        if (expectedLength != NSURLResponseUnknownLength) {
            // If the expected content length is
            // available, display percent complete.
            float percentComplete = (bytesReceived/(float)expectedLength)*100.0;
            //int speed = [progressBytes doubleValue] / ([NSDate timeIntervalSinceReferenceDate] - startTime);
            //speed = speed / 1024; 
            self.percentage = [NSNumber numberWithFloat:percentComplete]; 
            //NSLog(@"Percent complete - %@",percentage);
        } else {
            // If the expected content length is
            // unknown, just log the progress.
            //NSLog(@"Bytes received - %d",bytesReceived);
        }
        //[progressBytes retain]; 
        //[percentage retain]; 
        //[totalByes retain]; 
        [self updateDownloadInformation];
    }
}

-(void)updateDownloadInformation
{
    NSNumber *key = [NSNumber numberWithUnsignedInteger:downloadIndex]; 
    if (key != nil && self.downloadName != nil && self.percentage != nil && self.totalByes != nil && self.downloadPath != nil && self.ProgressBytes != nil && self.downloadUrl != nil) {
        aDownload.key = key; 
        aDownload.name = self.downloadName;
        aDownload.progress = self.percentage; 
        aDownload.size= self.totalByes; 
        aDownload.path = self.downloadPath; 
        aDownload.progressBytes = self.ProgressBytes; 
        aDownload.downloadUrl = self.downloadUrl; 
        RADownloadController *controller = [[RADownloadController alloc]init]; 
        [controller replaceDownloadAtIndex:downloadIndex withDownload:aDownload];
        [controller release]; 
        [[NSNotificationCenter defaultCenter]postNotificationName:DOWNLOAD_UPDATE object:nil];
    }

}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    
}


-(void)downloadDidFinish:(NSURLDownload *)download
{   
    //NSLog(@"Finish"); 
    if ([self.downloadPath hasSuffix:@"rpa.zip"] || [self.downloadPath hasSuffix:@"sba.zip"]) {
        [[RAlistManager sharedUser]setDownloadPath:self.downloadPath];
        [[RAlistManager sharedUser]installApp];
    }
    if (trackDownload) {
        [self updateDownloadInformation];
        [[NSNotificationCenter defaultCenter]postNotificationName:DOWNLOAD_FINISH object:self.downloadName];
    }
    
    [delegate DownloadDelegateDidFinishJob:self];
}




@end
