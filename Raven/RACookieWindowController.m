//
//  RACookieWindowController.m
//  Raven
//
//  Created by Thomas Ricouard on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RACookieWindowController.h"

@implementation RACookieWindowController

- (id)init
{
    self = [super init];
    if (self) {
        [self initWithWindowNibName:@"RACookieWindow"]; 
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
-(void)awakeFromNib
{
    [tableview setDataSource:self]; 
    [tableview setDelegate:self];
    [tableview setAllowsEmptySelection:NO];
}

-(void)fetchCookie
{
    NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc]initWithKey:NSHTTPCookieExpires
                                                 ascending:NO] autorelease];
    NSArray *sortDescriptor = [NSArray arrayWithObject:dateDescriptor];
    if(localCookieStore)
    {
        [localCookieStore release], localCookieStore = nil;
    }
    localCookieStore = [[NSMutableArray alloc]init];
    localCookieStore = [[[NSHTTPCookieStorage sharedHTTPCookieStorage]sortedCookiesUsingDescriptors:sortDescriptor]copy]; 
    [tableview reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [localCookieStore count];
    
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{  
    NSHTTPCookie *aCookie = [localCookieStore objectAtIndex:row];
    if (tableColumn == titleColumn) {
        return [aCookie name];
    }
    if (tableColumn == urlColumn) {
        return [aCookie domain];
    }
    if (tableColumn == commentColumn) {
        return [aCookie expiresDate];
    }
    
    return nil;
    

}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSHTTPCookie *aCookie = [localCookieStore objectAtIndex:[tableview selectedRow]]; 
    [deleteButton setEnabled:YES]; 
}

-(void)deleteSelectedCookie:(id)sender
{
    NSHTTPCookie *aCookie = [localCookieStore objectAtIndex:[tableview selectedRow]]; 
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:aCookie]; 
    [self fetchCookie]; 
}
- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
