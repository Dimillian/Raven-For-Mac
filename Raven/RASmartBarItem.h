//
//  RASmartBarItem.h
//  Raven
//
//  Created by Thomas Ricouard on 06/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RASmartBarItem : NSObject
{
    NSString *_appName; 
    NSString *_folder; 
    NSString *_context;
    NSImage *_mainIcon; 
    NSImage *_mainIconBig; 
    NSMutableArray *_URLArray; 
    NSMutableArray *_buttonImageArrayOn; 
    NSMutableArray *_buttonImageArrayOff; 
    NSMutableArray *_navigatorViewControllerArray; 
    BOOL _isHidden; 
    NSInteger _index; 
}

-(id)initWithAppName:(NSString *)name 
      withFolderName:(NSString *)folder 
        withUrlArray:(NSArray *)urlArray 
       andPlistIndex:(int)plistIndex; 

-(void)cleanNavigatorController; 

@property (nonatomic, copy) NSString *appName; 
@property (nonatomic, copy) NSString *folder; 
@property (nonatomic, copy) NSString *context; 
@property (nonatomic, retain) NSImage *mainIcon; 
@property (nonatomic, retain) NSImage *mainIconBig; 
@property (nonatomic, assign) NSMutableArray *URLArray; 
@property (nonatomic, assign) NSMutableArray *buttonImageArrayOn; 
@property (nonatomic, assign) NSMutableArray *buttonImageArrayOff; 
@property (nonatomic, assign) NSMutableArray *navigatorViewControllerArray; 
@property BOOL isHidden; 
@property NSInteger index; 

@end
