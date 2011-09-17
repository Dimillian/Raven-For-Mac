//
//  DownloadObject.m
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadObject.h"

@implementation DownloadObject
@synthesize size, progress, name, key, path, progressBytes, downloadUrl;

-(id)initWithKey:(NSNumber *)k name:(NSString *)n progress:(NSNumber *)pro size:(NSNumber *)s path:(NSString *)p progressBytes:(NSNumber *)pb source:(NSString *)sc  
{
    self.key = k;
    self.name = n; 
    self.progress = pro; 
    self.size = s; 
    self.path = p; 
    self.progressBytes = pb; 
    self.downloadUrl = sc; 
    
    return self; 
}

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


-(void)dealloc
{
    [key release]; 
    [name release]; 
    [size release]; 
    [progress release]; 
    [path release]; 
    [progressBytes release]; 
    [downloadUrl release]; 
    [super dealloc]; 
}

@end
