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
    NSString *_makerName; 
    NSString *_internalAppUrl; 
    NSString *_category; 
    NSImage *_mainIcon; 
    NSImage *_mainIconBig; 
    NSMutableArray *_URLArray; 
    NSMutableArray *_buttonImageArrayOn; 
    NSMutableArray *_buttonImageArrayOff; 
    NSMutableArray *_navigatorViewControllerArray; 
    BOOL _visible; 
    NSInteger _index; 
}

-(id)initWithDictionnary:(NSDictionary *)dictionnary andPlistIndex:(int)plistIndex; 
-(void)cleanNavigatorController; 
-(void)hideSmartBarItem; 
-(void)showSmartBarItem; 

@property (nonatomic, copy) NSString *appName; 
@property (nonatomic, copy) NSString *folder; 
@property (nonatomic, copy) NSString *context; 
@property (nonatomic, copy) NSString *makerName; 
@property (nonatomic, copy) NSString *category; 
@property (nonatomic, copy) NSString *internalAppUrl; 
@property (nonatomic, retain) NSImage *mainIcon; 
@property (nonatomic, retain) NSImage *mainIconBig; 
@property (nonatomic, assign) NSMutableArray *URLArray; 
@property (nonatomic, assign) NSMutableArray *buttonImageArrayOn; 
@property (nonatomic, assign) NSMutableArray *buttonImageArrayOff; 
@property (nonatomic, assign) NSMutableArray *navigatorViewControllerArray; 
@property (nonatomic, getter = isVisible) BOOL visible; 
@property NSInteger index; 

@end
