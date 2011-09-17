//
//  AddFavoritePanel.h
//  Raven
//
//  Created by Thomas Ricouard on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DatabaseController.h"
#import "LTInstapaperAPI.h"
#import "EMKeychainItem.h"

@interface AddFavoritePanel : NSWindowController <NSWindowDelegate, LTInstapaperAPIDelegate>
{
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
    LTInstapaperAPI *localInsta; 
    
}
@property int state; 
@property int index; 
@property int type; 
@property (nonatomic, retain) NSString *tempTitle; 
@property (nonatomic, retain) NSString *tempURL; 
@property (nonatomic, retain) NSImage *tempFavico; 
-(IBAction)AddFavorite:(id)sender; 
-(IBAction)cancel:(id)sender; 
-(IBAction)submitToInsta:(id)sender;
-(IBAction)InstapButtonpresse:(id)sender; 
-(IBAction)matriceChange:(id)sender;
-(void)succeeded;

@end