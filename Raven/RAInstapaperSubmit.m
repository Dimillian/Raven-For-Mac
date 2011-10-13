//
//  RAInstapaperSubmit.m
//  Raven
//
//  Created by Thomas Ricouard on 13/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAInstapaperSubmit.h"
#import "RavenAppDelegate.h"

@implementation RAInstapaperSubmit


-(void)dealloc{
    [localeTitle release]; 
    [localeTitle release]; 
    [localInsta release]; 
    [super dealloc];
}
-(void)setTitle:(NSString *)title URL:(NSString *)URL
{
    localeTitle = title; 
    localeURL = URL; 
    
}
-(void)submitToInsta
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        EMGenericKeychainItem *key = [EMGenericKeychainItem genericKeychainItemForService:@"raven.instapaper" withUsername:[standardUserDefaults stringForKey:LOGIN_INSTAPAPER]];
        LTInstapaperAPI *instaApi = [[LTInstapaperAPI alloc]initWithUsername:[standardUserDefaults stringForKey:LOGIN_INSTAPAPER] password:key.password delegate:self]; 
        localInsta = instaApi;
        [localInsta authenticate]; 
        [instaApi release]; 
    }
    
    
    
}


- (void)instapaper:(LTInstapaperAPI *)ip authDidFinishWithCode:(NSUInteger)code {
    // http://www.instapaper.com/api
    if (code == 200) {
        [self succeeded];
    } else {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if(standardUserDefaults)
        {
            RavenAppDelegate *delegate  = (RavenAppDelegate *)[[NSApplication sharedApplication]delegate]; 
            [delegate showSettingsWindow:nil];
            [[delegate setting]setEightTab:nil]; 
            NSAlert *alert = [[NSAlert alloc]init]; 
            [alert setMessageText:NSLocalizedString(@"Wrong username or password", @"instapaperError")];
            [alert setInformativeText:NSLocalizedString(@"Please review your instapaper credentials.", @"InstapaperDetailError")];
            [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Ok")];
            [alert setIcon:[NSImage imageNamed:@"instapaper-big.png"]]; 
            [alert beginSheetModalForWindow:[delegate.setting window] modalDelegate:self didEndSelector:nil contextInfo:nil];
            [alert release];
        }
    }
}

-(void)instapaper:(LTInstapaperAPI *)instapaper addDidFinishWithCode:(NSUInteger)code
{
    
}

-(void)succeeded
{
    [localInsta addURL:localeURL title:localeTitle]; 
}


@end
