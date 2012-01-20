//
//  DownloadObject.m
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RADownloadObject.h"

@implementation RADownloadObject
@synthesize size = _size, progress = _progress, name = _name, key = _key, path = _path, 
            progressBytes = _progressBytes, downloadUrl = _downloadUrl, downloadRequest = _downloadRequest;
@dynamic readbleTotalFileSize, readbleProgressFileSize; 

-(id)initWithKey:(NSNumber *)k name:(NSString *)n progress:(NSNumber *)pro size:(NSNumber *)s path:(NSString *)p progressBytes:(NSNumber *)pb source:(NSString *)sc  
{
    if (self = [super init]) {
        self.key = k;
        self.name = n; 
        self.progress = pro; 
        self.size = s; 
        self.path = p; 
        self.progressBytes = pb; 
        self.downloadUrl = sc; 
    }
    return (self); 
}

-(NSString *)readbleTotalFileSize
{
    
    return [self stringFromFileSize:[_size intValue]]; 
}

-(NSString *)readbleProgressFileSize
{
    return [self stringFromFileSize:[_progressBytes intValue]]; 
}

- (NSString *)stringFromFileSize:(int)theSize
{
	float floatSize = theSize;
	if (theSize<1023)
		return([NSString stringWithFormat:@"%i bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
	
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

/*
//I'll figure out why I put this later
-(id) initWithCoder: (NSCoder*) coder {
    if (self = [super init]) {
        key = [[coder decodeObjectForKey:@"Key"]copy];
        name = [[coder decodeObjectForKey:@"Name"]copy];
        progress = [[coder decodeObjectForKey:@"Progress"]copy];
        size = [[coder decodeObjectForKey:@"Size"]copy];
        path = [[coder decodeObjectForKey:@"Path"]copy];
        progressBytes = [[coder decodeObjectForKey:@"ProgressBytes"]copy]; 
        downloadUrl = [[coder  decodeObjectForKey:@"DownloadUrl"]copy]; 
    }
    return self;
}

//and this too
-(void) encodeWithCoder: (NSCoder*) coder {
    
    [coder encodeObject:self.key forKey:@"Key"]; 
    [coder encodeObject:self.name forKey:@"Name"]; 
    [coder encodeObject:self.progress forKey:@"Progress"]; 
    [coder encodeObject:self.size forKey:@"Size"]; 
    [coder encodeObject:self.path forKey:@"Path"]; 
    [coder encodeObject:self.progressBytes forKey:@"ProgressBytes"]; 
    [coder encodeObject:self.downloadUrl forKey:@"DownloadUrl"]; 
}
 */


-(void)dealloc
{
    [_key release]; 
    [_name release]; 
    [_size release]; 
    [_progress release]; 
    [_path release]; 
    [_progressBytes release]; 
    [_downloadUrl release]; 
    [_downloadRequest release]; 
    [super dealloc]; 
}

@end
