//
//  AboutPanel.m
//  Raven
//
//  Created by Thomas Ricouard on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAAboutPanelWindowController.h"

@implementation RAAboutPanelWindowController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)openAK:(id)sender
{
    NSWorkspace *Workspace = [NSWorkspace sharedWorkspace]; 
    [Workspace openURL:[NSURL URLWithString:@"http://raven.io/acknowledgements.html"]]; 
}

-(void)openLA:(id)sender
{
    NSWorkspace *Workspace = [NSWorkspace sharedWorkspace]; 
    [Workspace openURL:[NSURL URLWithString:@"http://raven.io/eula.html"]];  
}

-(void)windowWillClose:(NSNotification *)notification
{
    [self autorelease]; 
}

-(void)dealloc
{
    [version release]; 
    [super dealloc]; 
}

-(id)infoValueForKey:(NSString*)key
{ 
    if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
        return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

-(void)awakeFromNib
{
    [version setStringValue:[self infoValueForKey:@"CFBundleVersion"]];

}
@end
