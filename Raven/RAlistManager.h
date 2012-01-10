//
//  RAlistManager.h
//  Raven
//
//  Created by Thomas Ricouard on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//Manage an array containing dictionary of all apps in the app.plist
//This Array is shared across all the app and is used by main window class
//Main window create the smart bar derived from this array to generate the smart bar item
//Any change made to the smart bar are later replicated here in memory and sometimes write to file
//to update the .plist
//The .plist is loaded at each launch and writen when you close a window
//Most of the part is entierly managed in memory to make the thing speedier. 

//On of my idea would be to "merge" this class with the app array in the main window, it will remove a layer 
//And make replicate of operations easier, but each window need a separate state of the smart bar

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
