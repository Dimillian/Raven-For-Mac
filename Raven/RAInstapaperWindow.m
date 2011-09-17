//
//  RAInstapaperWindow.m
//  Raven
//
//  Created by Thomas Ricouard on 01/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAInstapaperWindow.h"

@implementation RAInstapaperWindow
@synthesize tempLogin, tempPassword; 

- (id)init
{
    self = [super init];
    if (self) {
        [self initWithWindowNibName:@"InstaSheet"]; 
        
    }
    
    return self;
}

-(void)awakeFromNib
{
    [[self window]setDelegate:self]; 
    login.stringValue = tempLogin;
    password.stringValue = tempPassword; 
}
- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowDidEndSheet:(NSNotification *)notification;
{
    NSLog(@"release");
    
}

-(void)windowWillClose:(NSNotification *)notification
{
    [self autorelease]; 
}

-(void)SaveCredential:(id)sender
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setValue:[login stringValue] forKey:@"LoginInstapaper"]; 
        [standardUserDefaults setValue:[password stringValue] forKey:@"PasswordInstapaper"]; 
        [standardUserDefaults synchronize]; 
    }

    [NSApp endSheet:[self window]];
    [[self window]orderOut:self]; 

    
}

-(void)cancel:(id)sender
{
    [NSApp endSheet:[self window]];
    [[self window]orderOut:self]; 
  
}

@end
