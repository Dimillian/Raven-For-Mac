//
//  RASmartBarViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASmartBarViewController.h"
#import "RAMainWindowController.h"


//button size and position
#define button_x 36
#define button_w 32
#define button_h 32

#define number_h 20

#define badge_x 59
#define badge_y 238
#define badge_w 26
#define badge_h 26

#define light_y 230
#define light_x 75
#define light_w 7
#define light_h 8

//Perfect place for the badge
//[[totalTabsNumber animator]setFrame:NSMakeRect(badge_x-1, badge_y+1, badge_w, number_h)];
//[[badgeView animator]setFrame:NSMakeRect(badge_x, badge_y, badge_w, badge_h)];

@implementation RASmartBarViewController
@synthesize folderName, appName, firstURL, secondURL, thirdURL, fourthURL, state, delegate, selectedButton, mainButton, appNumber; 


-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"RASmartBarViewController" bundle:nil]; 
    }
    
    return self; 
}

-(id)initWithDelegate:(id<RASmartBarViewControllerDelegate>)dgate
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"RASmartBarViewController" bundle:nil]; 
        self.delegate = dgate;
    }
    
    return self;  
}

-(void)dealloc
{
    [firstNavigatorView release]; 
    [SecondNavigatorView release]; 
    [ThirdtNavigatorView release]; 
    [FourthNavigatorView release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}


-(void)awakeFromNib
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:UPDATE_TAB_NUMBER 
                                              object:nil];

    
    state = 0;
    selectedButton = 1; 
    firstNavigatorView = [[RANavigatorViewController alloc]init];
    SecondNavigatorView = [[RANavigatorViewController alloc]init];
    ThirdtNavigatorView = [[RANavigatorViewController alloc]init];
    FourthNavigatorView = [[RANavigatorViewController alloc]init];

    NSString *homeButtonPath = [NSString stringWithFormat:application_support_path@"%@/main.png", folderName];
    NSString *firstImageOffPath = [NSString stringWithFormat:application_support_path@"%@/1_off.png", folderName];
    NSString *firstImageOnPath = [NSString stringWithFormat:application_support_path@"%@/1_on.png", folderName];
    NSString *secondImageOffPath = [NSString stringWithFormat:application_support_path@"%@/2_off.png", folderName]; 
    NSString *secondImageOnPath = [NSString stringWithFormat:application_support_path@"%@/2_on.png", folderName]; 
    NSString *thirdImageOffPath = [NSString stringWithFormat:application_support_path@"%@/3_off.png", folderName]; 
    NSString *thirdImageOnPath = [NSString stringWithFormat:application_support_path@"%@/3_on.png", folderName]; 
    NSString *fourImageOffPath = [NSString stringWithFormat:application_support_path@"%@/4_off.png", folderName]; 
    NSString *fourImageOnPath = [NSString stringWithFormat:application_support_path@"%@/4_on.png", folderName];

    NSImage *homeButtonImage = [[NSImage alloc]initWithContentsOfFile:[homeButtonPath stringByExpandingTildeInPath]];
    NSImage *firstImageOff = [[NSImage alloc]initWithContentsOfFile:[firstImageOffPath stringByExpandingTildeInPath]];
    NSImage *firstImageOn = [[NSImage alloc]initWithContentsOfFile:[firstImageOnPath stringByExpandingTildeInPath]];
    NSImage *secondImageOff = [[NSImage alloc]initWithContentsOfFile:[secondImageOffPath stringByExpandingTildeInPath]];
    NSImage *secondImageOn = [[NSImage alloc]initWithContentsOfFile:[secondImageOnPath stringByExpandingTildeInPath]];
    NSImage *thirdImageOff = [[NSImage alloc]initWithContentsOfFile:[thirdImageOffPath stringByExpandingTildeInPath]];
    NSImage *thirdImageOn = [[NSImage alloc]initWithContentsOfFile:[thirdImageOnPath stringByExpandingTildeInPath]];
    NSImage *fourImageOff = [[NSImage alloc]initWithContentsOfFile:[fourImageOffPath stringByExpandingTildeInPath]];
    NSImage *fourImageOn = [[NSImage alloc]initWithContentsOfFile:[fourImageOnPath stringByExpandingTildeInPath]];
    
    [mainButton setImage:homeButtonImage]; 
    
    [firstButton setImage:firstImageOff];
    [firstButton setAlternateImage:firstImageOn];
    
    [secondButton setImage:secondImageOff];
    [secondButton setAlternateImage:secondImageOn];
    
    [thirdButton setImage:thirdImageOff];
    [thirdButton setAlternateImage:thirdImageOn];
    
    [fourthButton setImage:fourImageOff];
    [fourthButton setAlternateImage:fourImageOn];
    
    [firstImageOff release]; 
    [firstImageOn release]; 
    [secondImageOff release]; 
    [secondImageOn release]; 
    [thirdImageOff release]; 
    [thirdImageOn release]; 
    [fourImageOff release]; 
    [fourImageOn release]; 
    [homeButtonImage release]; 
    [firstURL retain]; 
    [secondURL retain]; 
    [thirdURL retain]; 
    [fourthURL retain]; 
    
    [self calculateUrlNumber];
    
}


-(void)calculateUrlNumber{
    if ([secondURL isEqualToString:@""]) {
        appNumber = 1; 
    }
    else if ([thirdURL isEqualToString:@""]){
        appNumber = 2; 
    }
    else if ([fourthURL isEqualToString:@""]){
        appNumber = 3;
    }
    else
    {
        appNumber = 4; 
    }
    
    
}

-(void)receiveNotification:(NSNotification *)notification
{
    [self updateTabsNumber];
}

//fired when main app button is clicked
-(IBAction)expandApp:(id)sender
{
    if (state == 0) {
        [self setSelectedButton];
        //[[totalTabsNumber animator]setAlphaValue:0.0];
        //[[badgeView animator]setAlphaValue:0.0];
        [[lightVIew animator]setAlphaValue:0.0];
        [[firstButton animator]setFrame:NSMakeRect(button_x, 166, button_w, button_h)];
        [[firstButtonNumber animator]setFrame:NSMakeRect(button_x, 150, button_w, number_h)];
        [firstButtonNumber setAlphaValue:1.0];
        [[firstButton animator]setAlphaValue:1.0]; 
        [[secondButton animator] setFrame:NSMakeRect(button_x, 116, button_w, button_h)]; 
        [[secondButtonNumber animator]setFrame:NSMakeRect(button_x, 100, button_w, number_h)];
        [[secondButtonNumber animator]setAlphaValue:1.0];
        [secondButton setAlphaValue:1.0];
        [[thirdButton animator]setFrame:NSMakeRect(button_x, 66, button_w, button_h)];
        [[thirdButtonNumber animator]setFrame:NSMakeRect(button_x, 50, button_w, number_h)];
        [[thirdButton animator]setAlphaValue:1.0];
        [thirdButtonNumber setAlphaValue:1.0];
        [[fourthButton animator]setFrame:NSMakeRect(button_x, 16, button_w, button_h)];
        [[fourfthButtonNumber animator]setFrame:NSMakeRect(button_x, 0, button_w, number_h)];
        [[fourthButton animator]setAlphaValue:1.0];
        [fourfthButtonNumber setAlphaValue:1.0];
        [firstButton setEnabled:YES];
        [secondButton setEnabled:YES];
        [thirdButton setEnabled:YES];
        [fourthButton setEnabled:YES];
        [[mainButton animator]setAlphaValue:1.0];
        [delegate itemDidExpand:self];
        //[delegate selectionDidChange:self];
        state = 1;

    
    //MainWindowController *mainWindow = [[sender window]windowController]; 
    }
    

}

//fired to retract app
-(IBAction)retractApp:(id)sender
{
    
    [[firstButton animator]setFrame:NSMakeRect(button_x, 196, button_w, button_h)]; 
    [[firstButton animator]setAlphaValue:0.0]; 
    
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    if (standardDefault) {
        if( totalTabs == 0 || [standardDefault integerForKey:OPPENED_TABS_BADGE] == 0)
        {
            //[[totalTabsNumber animator]setAlphaValue:0.0];
            //[[badgeView animator]setAlphaValue:0.0];
            [[lightVIew animator]setAlphaValue:0.0];
        }
        else
        {
            //[[totalTabsNumber animator]setAlphaValue:1.0];
            //[[badgeView animator]setAlphaValue:1.0];
            [[lightVIew animator]setAlphaValue:1.0];
        }
    }
    
    //[[totalTabsNumber animator]setFrame:NSMakeRect(badge_x-1, badge_y+1, badge_w, number_h)];
    //[[badgeView animator]setFrame:NSMakeRect(badge_x, badge_y, badge_w, badge_h)];
    [[lightVIew animator]setFrame:NSMakeRect(light_x, light_y , light_w, light_h)];
    [[firstButtonNumber animator]setFrame:NSMakeRect(button_x, 196, button_x, number_h)];
    [firstButtonNumber setAlphaValue:0.0];
    [[secondButton animator] setFrame:NSMakeRect(button_x, 196, button_w, button_h)]; 
    [[secondButton animator]setAlphaValue:0.0]; 
    [[secondButtonNumber animator]setFrame:NSMakeRect(button_x, 196, button_x, number_h)];
    [secondButtonNumber setAlphaValue:0.0];
    [[thirdButton animator]setFrame:NSMakeRect(button_x, 196, button_w, button_h)];
    [[thirdButton animator]setAlphaValue:0.0]; 
    [[thirdButtonNumber animator]setFrame:NSMakeRect(button_x, 196, button_x, number_h)];
    [thirdButtonNumber setAlphaValue:0.0];
    [[fourthButton animator]setFrame:NSMakeRect(button_x, 196, button_w, button_h)];
    [[fourthButton animator]setAlphaValue:0.0]; 
    [[fourfthButtonNumber animator]setFrame:NSMakeRect(button_x, 196, button_x, number_h)];
    [fourfthButtonNumber setAlphaValue:0.0];
    
    [firstButton setEnabled:NO];
    [secondButton setEnabled:NO];
    [thirdButton setEnabled:NO];
    [fourthButton setEnabled:NO];
    [[mainButton animator]setAlphaValue:0.5];
    //[delegate itemDidRetract:self];
    state = 0;
}


-(IBAction)firstItemClicked:(id)sender
{
    [self resetAllButton]; 
    [firstButton setState:1]; 
    RAMainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    if ([[firstNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 1 && mainWindow.myCurrentViewController == firstNavigatorView)) {
        [firstNavigatorView view];
        [firstNavigatorView setPassedUrl:firstURL];
        [firstNavigatorView addtabs:mainButton]; 
    }
    
    if (firstNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = firstNavigatorView;
        
    }
    [firstNavigatorView setMenu];
    
    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 1;
}

-(IBAction)secondItemClicked:(id)sender
{
    [self resetAllButton]; 
    [secondButton setState:1]; 
    RAMainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    if ([[SecondNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 2 && mainWindow.myCurrentViewController == SecondNavigatorView)) {
        [SecondNavigatorView view];
        [SecondNavigatorView setPassedUrl:secondURL];
        [SecondNavigatorView addtabs:mainButton]; 
    }    
        
    if (SecondNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = SecondNavigatorView;
        
    }
    [SecondNavigatorView setMenu];
    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 2;
}

-(IBAction)thirdItemClicked:(id)sender
{
    [self resetAllButton]; 
    [thirdButton setState:1]; 
    RAMainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    if ([[ThirdtNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 3 && mainWindow.myCurrentViewController == ThirdtNavigatorView)) {
        [ThirdtNavigatorView view];
        [ThirdtNavigatorView setPassedUrl:thirdURL];
        [ThirdtNavigatorView addtabs:mainButton]; 

    }    
    
    if (ThirdtNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = ThirdtNavigatorView;
        
    }
    [ThirdtNavigatorView setMenu];
    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 3;

}

-(IBAction)fourItemClicked:(id)sender
{
    [self resetAllButton]; 
    [fourthButton setState:1];
    RAMainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    
    if ([[FourthNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 4 && mainWindow.myCurrentViewController == FourthNavigatorView)) {
        [FourthNavigatorView view];
        [FourthNavigatorView setPassedUrl:fourthURL];
        [FourthNavigatorView addtabs:mainButton]; 
    }  
    
    if (FourthNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = FourthNavigatorView;
        
    }
    [FourthNavigatorView setMenu];
    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 4;
}

//select previously selected button when switching app
-(void)setSelectedButton
{
    switch (selectedButton) {
        case 1:
            [self firstItemClicked:firstButton];
            break;
        case 2:
            [self secondItemClicked:secondButton];
            break;
        case 3:
            [self thirdItemClicked:thirdButton];
            break;
        case 4:
            [self fourItemClicked:fourthButton];
            break;
            
        default:
            break;
    }
}

-(void)updateTabsNumber
{
     totalTabs = [[firstNavigatorView tabsArray]count] + [[SecondNavigatorView tabsArray]count] 
    +[[ThirdtNavigatorView tabsArray]count] + [[FourthNavigatorView tabsArray]count];
    //[totalTabsNumber setStringValue:[NSString stringWithFormat:@"%d", totalTabs]];
    [firstButtonNumber setStringValue:[self numberOfDotToDisplay:[firstNavigatorView.tabsArray count]]];
    [secondButtonNumber setStringValue:[self numberOfDotToDisplay:[SecondNavigatorView.tabsArray count]]];
    [thirdButtonNumber setStringValue:[self numberOfDotToDisplay:[ThirdtNavigatorView.tabsArray count]]];
    [fourfthButtonNumber setStringValue:[self numberOfDotToDisplay:[FourthNavigatorView.tabsArray count]]];
}


-(NSString *)numberOfDotToDisplay:(NSUInteger)numberOfTabs
{
    switch (numberOfTabs) {
        case 0:
            return @"";
            break;
        case 1:
            return @"•";
            break; 
        case 2:
            return @"••";
            break;
        case 3:
            return @"•••";
            break; 
        case 4:
            return @"••••";
            break; 
        default:
            return @"•••••";
            break;
    }
    
}
//reset all buttons state for image reset
-(void)resetAllButton
{
    
    [firstButton setState:0]; 
    [secondButton setState:0]; 
    [thirdButton setState:0]; 
    [fourthButton setState:0]; 


}

@end
