//
//  RASmartBarViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASmartBarViewController.h"
#import "MainWindowController.h"

@implementation RASmartBarViewController
@synthesize folderName, appName, firstURL, secondURL, thirdURL, fourthURL, state, delegate; 


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

-(void)awakeFromNib
{
    state = 0;
    selectedButton = 1; 
    firstNavigatorView = [[NavigatorViewController alloc]init];
    SecondNavigatorView = [[NavigatorViewController alloc]init];
    ThirdtNavigatorView = [[NavigatorViewController alloc]init];
    FourthNavigatorView = [[NavigatorViewController alloc]init];

    NSString *homeButtonPath = [NSString stringWithFormat:
                                @"~/Library/Application Support/RavenApp/app/%@/main.png", folderName];
    NSString *firstImageOffPath = [NSString stringWithFormat:
                                   @"~/Library/Application Support/RavenApp/app/%@/1_off.png", folderName];
    NSString *firstImageOnPath = [NSString stringWithFormat:
                                  @"~/Library/Application Support/RavenApp/app/%@/1_on.png", folderName];
    NSString *secondImageOffPath = [NSString stringWithFormat:
                                    @"~/Library/Application Support/RavenApp/app/%@/2_off.png", folderName]; 
    NSString *secondImageOnPath = [NSString stringWithFormat:
                                   @"~/Library/Application Support/RavenApp/app/%@/2_on.png", folderName]; 
    NSString *thirdImageOffPath = [NSString stringWithFormat:
                                   @"~/Library/Application Support/RavenApp/app/%@/3_off.png", folderName]; 
    NSString *thirdImageOnPath = [NSString stringWithFormat:
                                  @"~/Library/Application Support/RavenApp/app/%@/3_on.png", folderName]; 
    NSString *fourImageOffPath = [NSString stringWithFormat:
                                  @"~/Library/Application Support/RavenApp/app/%@/4_off.png", folderName]; 
    NSString *fourImageOnPath = [NSString stringWithFormat:
                                 @"~/Library/Application Support/RavenApp/app/%@/4_on.png", folderName];

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

-(IBAction)expandApp:(id)sender
{
    if (state == 0) {
         [self setSelectedButton];
        [[firstButton animator]setFrame:NSMakeRect(35, 166, 32, 32)];
        [[firstButton animator]setAlphaValue:1.0]; 
        [[secondButton animator] setFrame:NSMakeRect(35, 116, 32, 32)]; 
        [[secondButton animator]setAlphaValue:1.0];
        [[thirdButton animator]setFrame:NSMakeRect(35, 66, 32, 32)];
        [[thirdButton animator]setAlphaValue:1.0];
        [[fourthButton animator]setFrame:NSMakeRect(35, 16, 32, 32)];
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

-(IBAction)retractApp:(id)sender
{
    [[firstButton animator]setFrame:NSMakeRect(35, 196, 32, 32)]; 
    [[firstButton animator]setAlphaValue:0.0]; 
    [[secondButton animator] setFrame:NSMakeRect(35, 196, 32, 32)]; 
    [[secondButton animator]setAlphaValue:0.0]; 
    [[thirdButton animator]setFrame:NSMakeRect(35, 196, 32, 32)];
    [[thirdButton animator]setAlphaValue:0.0]; 
    [[fourthButton animator]setFrame:NSMakeRect(35, 196, 32, 32)];
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
    
    if (firstNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = firstNavigatorView;
        
    }
    
    if ([[firstNavigatorView tabsArray]count] == 0) {
        [firstNavigatorView view];
        [firstNavigatorView setPassedUrl:firstURL];
        [firstNavigatorView addtabs:nil]; 
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
    
    if (SecondNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = SecondNavigatorView;
        
    }
    
    if ([[SecondNavigatorView tabsArray]count] == 0) {
        [SecondNavigatorView view];
        [SecondNavigatorView setPassedUrl:secondURL];
        [SecondNavigatorView addtabs:nil]; 
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
    
    if (ThirdtNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = ThirdtNavigatorView;
        
    }
    
    if ([[ThirdtNavigatorView tabsArray]count] == 0) {
        [ThirdtNavigatorView view];
        [ThirdtNavigatorView setPassedUrl:thirdURL];
        [ThirdtNavigatorView addtabs:nil]; 
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
    
    if (FourthNavigatorView != nil)
    {
        mainWindow.myCurrentViewController = FourthNavigatorView;
        
    }

    if ([[FourthNavigatorView tabsArray]count] == 0) {
        [FourthNavigatorView view];
        [FourthNavigatorView setPassedUrl:fourthURL];
        [FourthNavigatorView addtabs:nil]; 
    }  
    [mainWindow.centeredView addSubview: [mainWindow.myCurrentViewController view]];
    [[mainWindow.myCurrentViewController view]setFrame:[mainWindow.centeredView bounds]];
    selectedButton = 4;
}

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

-(void)resetAllButton
{
    [firstButton setState:0]; 
    [secondButton setState:0]; 
    [thirdButton setState:0]; 
    [fourthButton setState:0]; 
}

@end
