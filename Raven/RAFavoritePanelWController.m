//
//  AddFavoritePanel.m
//  Raven
//
//  Created by Thomas Ricouard on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAFavoritePanelWController.h"
#import "RAInstapaperWindow.h"
#import "RavenAppDelegate.h"


@implementation RAFavoritePanelWController
@synthesize tempURL, tempTitle, tempFavico, state, index, type, thisDelegate; 
- (id)init
{
    self = [super init];
    if (self) {
        [self initWithWindowNibName:@"AddtoFavorite"]; 
    }
    
    return self;
}

-(void)awakeFromNib
{
    [[self window]setDelegate:self]; 
    title.stringValue = tempTitle;
    URL.stringValue = tempURL; 
    favico = tempFavico; 
    [buttonChoice selectCellWithTag:type];
    [instapaperButton setState:0]; 
    instapaper = [[RAInstapaperSubmit alloc]init]; 
    [instapaper setThisDelegate:self];

    
}

-(void)dealloc
{
    [super dealloc]; 
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)matriceChange:(id)sender
{
    if ([buttonChoice selectedTag] == 1) {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults) {
            [instapaperButton setState:[standardUserDefaults integerForKey:AUTO_SAVE_INSTAPAPER]]; 
        }
    }
    else if ([buttonChoice selectedTag] == 0)
    {
        [instapaperButton setState:0]; 
    }

}

-(void)AddFavorite:(id)sender
{
    //adding
    if (state == 1) {
        RADatabaseController *controller = [RADatabaseController sharedUser];
        //set the dabatase field with the field entered by the user
        [controller insertBookmark:[title stringValue] 
                               url:[URL stringValue] 
                              data:[favico TIFFRepresentation] 
                              type:[buttonChoice selectedTag]]; 
    }
    //editing
    else{
        RADatabaseController *controller = [RADatabaseController sharedUser]; 
        [controller editFavorite:index title:[title stringValue] url:[URL stringValue] type:[buttonChoice selectedTag]];
        
    }
    if ([instapaperButton state] == 1) {
        [instapaper setTitle:[title stringValue] URL:[URL stringValue]];
        [instapaper submitToInsta];
        [NSApp endSheet:[self window]];
        [[self window]orderOut:self];
    }
    else{
        [NSApp endSheet:[self window]];
        [[self window]orderOut:self];
    }
}

-(void)InstapButtonpresse:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([instapaperButton state] == 1) {
        if (standardUserDefaults)
        {
            if ([standardUserDefaults stringForKey:LOGIN_INSTAPAPER] == nil) {
                RavenAppDelegate *delegate  = (RavenAppDelegate *)[[NSApplication sharedApplication]delegate]; 
                [delegate showSettingsWindow:nil];
                [[delegate setting]setEightTab:nil]; 
                
            }
        }
    }
}

-(void)cancel:(id)sender
{
    [[self window]orderOut:self]; 
    [NSApp endSheet:[self window]]; 
    [thisDelegate favoritePanelDidClose:self];
}

-(void)didFinishAddingBookmarkToInstapaper:(RAInstapaperSubmit *)RAInstapaper
{
    [thisDelegate favoritePanelDidClose:self];
}
@end
