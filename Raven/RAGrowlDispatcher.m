//
//  RAGrowlDispatcher.m
//  Raven
//
//  Created by Thomas Ricouard on 07/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAGrowlDispatcher.h"

@implementation RAGrowlDispatcher

-(id)init
{
    if (self = [super init]) {
        [GrowlApplicationBridge setGrowlDelegate:self];
        [[NSNotificationCenter defaultCenter]addObserver:self 
                                                selector:@selector(receiveNotification:) 
                                                    name:APP_UPDATED
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self 
                                                selector:@selector(receiveNotification:) 
                                                    name:NEW_APP_INSTALLED 
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self 
                                                selector:@selector(receiveNotification:) 
                                                    name:DOWNLOAD_BEGIN 
                                                  object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self 
                                                selector:@selector(receiveNotification:) 
                                                    name:DOWNLOAD_FINISH 
                                                  object:nil];

    }
    return (self); 

}

- (NSDictionary *) registrationDictionaryForGrowl {
    
    
    
    NSArray *array = [NSArray arrayWithObjects:@"Internal Event", @"Javascript notification", @"Web Application notification", nil]; /* each string represents a notification name that will be valid for us to use in alert methods */
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:1], /* growl 0.7 through growl 1.1 use ticket version 1 */
                          @"TicketVersion", /* Required key in dictionary */
                          array, /* defines which notification names our application can use, we defined example and error above */
                          @"AllNotifications", /*Required key in dictionary */
                          array, /* using the same array sets all notification names on by default */
                          @"DefaultNotifications", /* Required key in dictionary */
                          nil];
    return dict;
}

-(void)receiveNotification:(NSNotification *)notification
{   
    if ([[notification name]isEqualToString:NEW_APP_INSTALLED]) {
        [self growlAlert:NSLocalizedString(@"New application installed with success", @"Growl_App_Install_text") title:NSLocalizedString(@"New app installed", @"Growl_App_Install_Title")];
    }
    if ([[notification name]isEqualToString:APP_UPDATED]) {
        [self growlAlert:NSLocalizedString(@"Application updated with success", @"Growl_App_Update_text") title:NSLocalizedString(@"Application updated", @"Growl_App_Update_Title")];
    }
    if ([[notification name]isEqualToString:DOWNLOAD_BEGIN]) {
        [self growlAlert:NSLocalizedString(@"A file is downloading", @"Growl_Download_begin_Text") title:NSLocalizedString(@"A new download has begun", @"Growl_Download_Begin_Title")];
    }
    if ([[notification name]isEqualToString:DOWNLOAD_FINISH]) {
        [self growlAlert:[NSString stringWithFormat:NSLocalizedString(@"The file %@ have finished downloading", @"Growl_Download_Finish_Text"), [notification object]] title:NSLocalizedString(@"A download is done", @"Growl_Download_Finish_Title")];
    }
}


-(void)growlAlert:(NSString *)message title:(NSString *)title{
    [GrowlApplicationBridge notifyWithTitle:title 
                                description:message
                           notificationName:@"Internal Event"
                                   iconData:nil  
                                   priority:0 
                                   isSticky:NO 
                               clickContext:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}


@end
