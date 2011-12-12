//
//  RAShelfView.m
//  Raven
//
//  Created by Thomas Ricouard on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAShelfView.h"
#import "RAMainWindowController.h"
#import "RASmartBarItem.h"
#import "RASmartBarViewController.h"

@implementation RAShelfView
@synthesize appListShelf; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

-(void)awakeFromNib
{
    RAMainWindowController *mainWindow = [[NSApp keyWindow]windowController];
    appListShelf = [[NSMutableArray alloc]init]; 
    for (RASmartBarViewController *item in mainWindow.appList) {
        [appListShelf addObject:item.smartBarItem]; 
    }
    [collectionView setDelegate:self]; 
    
}


-(void)insertObject:(RASmartBarItem *)p inPersonModelArrayAtIndex:(NSUInteger)index {
    [appListShelf insertObject:p atIndex:index];
}

-(void)removeObjectFromPersonModelArrayAtIndex:(NSUInteger)index {
    [appListShelf removeObjectAtIndex:index];
}

-(void)setPersonModelArray:(NSMutableArray *)a {
    appListShelf = a;
}

-(NSArray*)personModelArray {
    return appListShelf;
}

@end
