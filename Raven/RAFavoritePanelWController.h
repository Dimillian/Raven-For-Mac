//
//  AddFavoritePanel.h
//  Raven
//
//  Created by Thomas Ricouard on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RADatabaseController.h"
#import "LTInstapaperAPI.h"
#import "EMKeychainItem.h"
#import "RAInstapaperSubmit.h"

@protocol RAFavoritePanelControllerDelegate; 
@interface RAFavoritePanelWController : NSWindowController <NSWindowDelegate, RAInstapaperDelegate>
{
    id<RAFavoritePanelControllerDelegate>thisDelegate; 
    IBOutlet NSTextField *title; 
    IBOutlet NSTextField *URL; 
    NSString *tempTitle; 
    NSString *tempURL; 
    NSImage *tempFavico; 
    NSImage *favico;
    int state; 
    int index;
    int type;
    IBOutlet NSMatrix *buttonChoice; 
    IBOutlet NSButton *instapaperButton; 
    RAInstapaperSubmit *instapaper;
    
}
@property int state; 
@property int index; 
@property int type; 
@property (nonatomic, assign) id<RAFavoritePanelControllerDelegate>thisDelegate;  
@property (nonatomic, retain) NSString *tempTitle; 
@property (nonatomic, retain) NSString *tempURL; 
@property (nonatomic, retain) NSImage *tempFavico; 
-(IBAction)AddFavorite:(id)sender; 
-(IBAction)cancel:(id)sender; 
-(IBAction)InstapButtonpresse:(id)sender; 
-(IBAction)matriceChange:(id)sender;

@end

@protocol RAFavoritePanelControllerDelegate
-(void)favoritePanelDidClose:(RAFavoritePanelWController *)fpanel; 
@end
