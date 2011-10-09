//
//  DownloadObject.h
//  Raven
//
//  Created by Thomas Ricouard on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RADownloadObject : NSObject{
    NSNumber *key; 
    NSString *name; 
    NSNumber *progress; 
    NSNumber *progressBytes; 
    NSNumber *size; 
    NSString *path; 
    NSString *downloadUrl; 
}
@property (retain) NSNumber *key; 
@property (copy) NSString *name; 
@property (retain) NSNumber *progress; 
@property (retain) NSNumber *size; 
@property (copy) NSString *path; 
@property (retain) NSNumber *progressBytes; 
@property (copy) NSString *downloadUrl; 
-(id)initWithKey:(NSNumber *)k name:(NSString *)n progress:(NSNumber *)pro size:(NSNumber *)s path:(NSString *)p progressBytes:(NSNumber *)pb source:(NSString *)sc; 
@end
