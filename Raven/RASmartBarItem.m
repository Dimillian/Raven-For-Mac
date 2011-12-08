//
//  RASmartBarItem.m
//  Raven
//
//  Created by Thomas Ricouard on 06/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RASmartBarItem.h"
#import "RANavigatorViewController.h"

@implementation RASmartBarItem
@synthesize folder = _folder, appName = _appName, URLArray = _URLArray, buttonImageArrayOn = _buttonImageArrayOn, buttonImageArrayOff = _buttonImageArrayOff, isVisible = _isVisible, mainIcon = _mainIcon, mainIconBig = _mainIconBig, index = _index, navigatorViewControllerArray =_navigatorViewControllerArray, context = _context; 

-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        
    }
    
    return self; 
}

-(id)initWithDictionnary:(NSDictionary *)dictionnary andPlistIndex:(int)plistIndex
{
    self = [super init]; 
    if (self != nil) {

        self.appName = [dictionnary objectForKey:PLIST_KEY_APPNAME]; 
        self.folder = [dictionnary objectForKey:PLIST_KEY_FOLDER]; 
        self.isVisible = [[dictionnary objectForKey:PLIST_KEY_ENABLE]intValue];
        self.index = plistIndex;
        NSImage *mainImage = [[NSImage alloc]initByReferencingFile:
                              [[NSString stringWithFormat:application_support_path@"%@/main.png", self.folder]stringByExpandingTildeInPath]];
        self.mainIcon = mainImage;
        NSImage *mainImageBig = [[NSImage alloc]initByReferencingFile:
                                 [[NSString stringWithFormat:application_support_path@"%@/main_big.png", self.folder]stringByExpandingTildeInPath]];
        self.mainIconBig = mainImageBig; 
        _URLArray = [[dictionnary objectForKey:PLIST_KEY_URL]mutableCopy];
        _navigatorViewControllerArray = [[NSMutableArray alloc]init]; 
        _buttonImageArrayOn = [[NSMutableArray alloc]init]; 
        _buttonImageArrayOff = [[NSMutableArray alloc]init]; 
        
        NSUInteger i = 1;
        for (NSString *URL in _URLArray) {
            RANavigatorViewController *navView = [[RANavigatorViewController alloc]init];
            [navView setBaseUrl:[_URLArray objectAtIndex:i-1]]; 
            [_navigatorViewControllerArray addObject:navView];
            NSImage *imageOn = [[NSImage alloc]initByReferencingFile:
                                [[NSString stringWithFormat:application_support_path@"%@/%d_on.png", self.folder, i]stringByExpandingTildeInPath]];
            [imageOn setSize:NSMakeSize(32, 32)];
            NSImage *imageOff = [[NSImage alloc]initByReferencingFile:
                                [[NSString stringWithFormat:application_support_path@"%@/%d_off.png", self.folder, i]stringByExpandingTildeInPath]];
            [imageOff setSize:NSMakeSize(32, 32)];
            [_buttonImageArrayOn addObject:imageOn]; 
            [_buttonImageArrayOff addObject:imageOff]; 
            [imageOn release]; 
            [imageOff release]; 
            [navView release]; 
            i++;
        }
        
        NSURL *URL = [NSURL URLWithString:[_URLArray objectAtIndex:0]];
        self.context = [URL host];
        [mainImage release]; 
        [mainImageBig release]; 
    }
    
    return self; 
}

-(void)cleanNavigatorController
{
    [_navigatorViewControllerArray release]; 
    _navigatorViewControllerArray = [[NSMutableArray alloc]init]; 
    for (NSString *URL in _URLArray) {
        RANavigatorViewController *navView = [[RANavigatorViewController alloc]init]; 
        [_navigatorViewControllerArray addObject:navView];
        [navView release]; 
    }
}
-(void)dealloc
{
    [_URLArray release]; 
    [_context release]; 
    [_navigatorViewControllerArray release]; 
    [_buttonImageArrayOn release]; 
    [_buttonImageArrayOff release]; 
    [_mainIcon release]; 
    [_mainIconBig release]; 
    [_appName release]; 
    [_folder release]; 
    [super dealloc]; 
}
@end
