//
//  RAInstapaperWindow.h
//  Raven
//
//  Created by Thomas Ricouard on 01/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DatabaseController.h"

@interface RAInstapaperWindow : NSWindowController <NSWindowDelegate>
{
   IBOutlet  NSTextField *login; 
   IBOutlet NSTextField *password; 
    NSString *tempLogin; 
    NSString *tempPassword; 
     
}

-(IBAction)SaveCredential:(id)sender;
-(IBAction)cancel:(id)sender;
@property (nonatomic, retain) NSString *tempLogin; 
@property (nonatomic, retain) NSString *tempPassword; 

@end
