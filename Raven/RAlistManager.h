//
//  RAlistManager.h
//  Raven
//
//  Created by Thomas Ricouard on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAlistManager : NSObject
{
    NSString *downloadPath;
    NSString *destinationPath;
}

-(void)importAppAthPath:(NSString *)path;
-(BOOL)checkifAppIsValide:(NSString *)path;
-(void)updateProcess; 
-(void)installApp;
-(void)UnzipFile:(NSString*)sourcePath;
-(void)checkforDuplicateFromApp:(NSString *)sourcePath; 
-(void)changeStateOfAppAtIndex:(NSInteger)index withState:(NSInteger)state;
-(NSInteger)returnStateOfAppAtIndex:(NSInteger)index;
-(void)swapObjectAtIndex:(NSInteger)index upOrDown:(NSInteger)order;
-(void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
-(void)deleteAppAtIndex:(NSInteger)index;
@property (copy) NSString *downloadPath;
@end
