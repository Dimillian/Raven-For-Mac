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
@property (nonatomic, retain) NSNumber *key; 
@property (nonatomic, copy) NSString *name; 
@property (nonatomic, retain) NSNumber *progress; 
@property (nonatomic, retain) NSNumber *size; 
@property (nonatomic, copy) NSString *path; 
@property (nonatomic, retain) NSNumber *progressBytes; 
@property (nonatomic, copy) NSString *downloadUrl; 
-(id)initWithKey:(NSNumber *)k name:(NSString *)n progress:(NSNumber *)pro size:(NSNumber *)s path:(NSString *)p progressBytes:(NSNumber *)pb source:(NSString *)sc; 
@end
