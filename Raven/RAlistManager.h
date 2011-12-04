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
    NSString *_downloadPath;
    NSString *_destinationPath;
    NSMutableArray *appPlistArray; 
    NSMutableDictionary *appPlistDictionnary;
}
+(RAlistManager *)sharedUser;

-(NSMutableArray *)readAppList; 
-(void)forceReadApplist; 
-(void)writeNewAppListInMemory:(NSMutableArray *)appList writeToFile:(BOOL)flag;

-(void)importAppAthPath:(NSString *)path;
-(BOOL)checkifAppIsValide:(NSString *)path;
-(void)updateProcess; 
-(void)installApp;
-(void)UnzipFile:(NSString*)sourcePath;
-(NSInteger)checkForDuplicate:(NSString *)Identifier;  
-(void)changeStateOfAppAtIndex:(NSInteger)index withState:(NSInteger)state;
-(NSInteger)returnStateOfAppAtIndex:(NSInteger)index;
-(void)swapObjectAtIndex:(NSInteger)index upOrDown:(NSInteger)order;
-(void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
-(void)deleteAppAtIndex:(NSInteger)index;
@property (nonatomic, copy) NSString *downloadPath;
@property (nonatomic, copy) NSString *destinationPath; 
@end
