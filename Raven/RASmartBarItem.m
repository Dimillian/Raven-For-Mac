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
@synthesize folder = _folder, appName = _appName, URLArray = _URLArray, buttonImageArrayOn = _buttonImageArrayOn, buttonImageArrayOff = _buttonImageArrayOff, visible = _visible, mainIcon = _mainIcon, mainIconBig = _mainIconBig, index = _index, navigatorViewControllerArray =_navigatorViewControllerArray, context = _context, category = _category, makerName = _makerName, internalAppUrl = _internalAppUrl; 

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

        _appName = [[dictionnary objectForKey:PLIST_KEY_APPNAME]retain]; 
        _folder = [[dictionnary objectForKey:PLIST_KEY_FOLDER]retain]; 
        _category = [[dictionnary objectForKey:PLIST_KEY_CATEGORY]retain]; 
        _makerName = [[dictionnary objectForKey:PLIST_KEY_OFFICIAL]retain]; 
        _visible = [[dictionnary objectForKey:PLIST_KEY_ENABLE]intValue];
        _index = plistIndex;
        _mainIcon = [[NSImage alloc]initByReferencingFile:
                     [[NSString stringWithFormat:application_support_path@"%@/main.png", self.folder]stringByExpandingTildeInPath]];;
        _mainIconBig = [[NSImage alloc]initByReferencingFile:
                        [[NSString stringWithFormat:application_support_path@"%@/main_big.png", self.folder]stringByExpandingTildeInPath]];; 
        _URLArray = [[dictionnary objectForKey:PLIST_KEY_URL]mutableCopy];
        _navigatorViewControllerArray = [[NSMutableArray alloc]init]; 
        _buttonImageArrayOn = [[NSMutableArray alloc]init]; 
        _buttonImageArrayOff = [[NSMutableArray alloc]init];
        NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:_URLArray]; 
        for (NSString *URL in tmpArray) {
            if ([URL isEqualToString:@""]) {
                [_URLArray removeObject:URL]; 
            }
        }
        [tmpArray release]; 
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
        
        NSURL *url = [[NSURL alloc]initWithString:[_URLArray objectAtIndex:0]];
        _context = [url host]; 
        [url release];
        _internalAppUrl = [[NSString alloc]initWithFormat:@"%@://", _appName]; 
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


-(void)hideSmartBarItem
{
    self.visible = NO; 
    [_buttonImageArrayOn release]; 
    [_buttonImageArrayOff release]; 
    [_navigatorViewControllerArray release]; 
    
}

-(void)showSmartBarItem
{
    self.visible = YES; 
    _buttonImageArrayOn = [[NSMutableArray alloc]init]; 
    _buttonImageArrayOff = [[NSMutableArray alloc]init]; 
    _navigatorViewControllerArray = [[NSMutableArray alloc]init]; 
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
}
-(void)dealloc
{
    [_category release]; 
    [_makerName release]; 
    [_URLArray release]; 
    [_navigatorViewControllerArray release]; 
    [_buttonImageArrayOn release]; 
    [_buttonImageArrayOff release]; 
    [_mainIcon release]; 
    [_mainIconBig release]; 
    [_appName release]; 
    [_folder release]; 
    [_internalAppUrl release]; 
    [super dealloc]; 
}
@end
