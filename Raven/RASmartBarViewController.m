//
//  RASmartBarViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASmartBarViewController.h"
#import "MainWindowController.h"


//button size and position
#define button_x 35
#define button_w 32
#define button_h 32

@implementation RASmartBarViewController
@synthesize folderName, appName, firstURL, secondURL, thirdURL, fourthURL, state, delegate, selectedButton; 


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
    
    [super dealloc];
}


-(void)awakeFromNib
{
    state = 0;
    selectedButton = 1; 
    firstNavigatorView = [[NavigatorViewController alloc]init];
    SecondNavigatorView = [[NavigatorViewController alloc]init];
    ThirdtNavigatorView = [[NavigatorViewController alloc]init];
    FourthNavigatorView = [[NavigatorViewController alloc]init];

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
    
}

//fired when main app button is clicked
-(IBAction)expandApp:(id)sender
{
    if (state == 0) {
         [self setSelectedButton];
        [[firstButton animator]setFrame:NSMakeRect(button_x, 166, button_w, button_h)];
        [[firstButton animator]setAlphaValue:1.0]; 
        [[secondButton animator] setFrame:NSMakeRect(button_x, 116, button_w, button_h)]; 
        [[secondButton animator]setAlphaValue:1.0];
        [[thirdButton animator]setFrame:NSMakeRect(button_x, 66, button_w, button_h)];
        [[thirdButton animator]setAlphaValue:1.0];
        [[fourthButton animator]setFrame:NSMakeRect(button_x, 16, button_w, button_h)];
        [[fourthButton animator]setAlphaValue:1.0];
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
    [[secondButton animator] setFrame:NSMakeRect(button_x, 196, button_w, button_h)]; 
    [[secondButton animator]setAlphaValue:0.0]; 
    [[thirdButton animator]setFrame:NSMakeRect(button_x, 196, button_w, button_h)];
    [[thirdButton animator]setAlphaValue:0.0]; 
    [[fourthButton animator]setFrame:NSMakeRect(button_x, 196, button_w, button_h)];
    [[fourthButton animator]setAlphaValue:0.0]; 
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
    MainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    if ([[firstNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 1 && mainWindow.myCurrentViewController == firstNavigatorView)) {
        [firstNavigatorView view];
        [firstNavigatorView setPassedUrl:firstURL];
        [firstNavigatorView addtabs:nil]; 
    }
    
    if (firstNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = firstNavigatorView;
        
    }
    
    
    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 1;
}

-(IBAction)secondItemClicked:(id)sender
{
    [self resetAllButton]; 
    [secondButton setState:1]; 
    MainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    if ([[SecondNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 2 && mainWindow.myCurrentViewController == SecondNavigatorView)) {
        [SecondNavigatorView view];
        [SecondNavigatorView setPassedUrl:secondURL];
        [SecondNavigatorView addtabs:nil]; 
    }    
        
    if (SecondNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = SecondNavigatorView;
        
    }

    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 2;
}

-(IBAction)thirdItemClicked:(id)sender
{
    [self resetAllButton]; 
    [thirdButton setState:1]; 
    MainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    if ([[ThirdtNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 3 && mainWindow.myCurrentViewController == ThirdtNavigatorView)) {
        [ThirdtNavigatorView view];
        [ThirdtNavigatorView setPassedUrl:thirdURL];
        [ThirdtNavigatorView addtabs:nil]; 
    }    
    
    if (ThirdtNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = ThirdtNavigatorView;
        
    }
    
    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 3;

}

-(IBAction)fourItemClicked:(id)sender
{
    [self resetAllButton]; 
    [fourthButton setState:1];
    MainWindowController *mainWindow = [[sender window]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    
    if ([[FourthNavigatorView tabsArray]count] == 0 || 
        (selectedButton == 4 && mainWindow.myCurrentViewController == FourthNavigatorView)) {
        [FourthNavigatorView view];
        [FourthNavigatorView setPassedUrl:fourthURL];
        [FourthNavigatorView addtabs:nil]; 
    }  
    
    if (FourthNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = FourthNavigatorView;
        
    }

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

//reset all buttons state for image reset
-(void)resetAllButton
{
    
    [firstButton setState:0]; 
    [secondButton setState:0]; 
    [thirdButton setState:0]; 
    [fourthButton setState:0]; 


}

@end
