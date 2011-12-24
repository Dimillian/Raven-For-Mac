//
//  RASmartBarViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RASmartBarItemViewController.h"
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

#define close_x 17
#define close_y 238
#define close_w 26
#define close_h 26

#define light_y 230
#define light_x 75
#define light_w 7
#define light_h 8

//Perfect place for the badge
//[[totalTabsNumber animator]setFrame:NSMakeRect(badge_x-1, badge_y+1, badge_w, number_h)];
//[[badgeView animator]setFrame:NSMakeRect(badge_x, badge_y, badge_w, badge_h)];

@implementation RASmartBarItemViewController
@synthesize state = _state, delegate, selectedButton = _selectedButton, smartBarItem = _smartBarItem;

#pragma mark -
#pragma mark init and dealloc
-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"RASmartBarItemViewController" bundle:nil]; 
    }
    
    return self; 
}

-(id)initWithDelegate:(id<RASmartBarViewItemControllerDelegate>)dgate 
   andRASmartBarItem:(RASmartBarItem *)item
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"RASmartBarItemViewController" bundle:nil]; 
        delegate = dgate;
        self.smartBarItem = item;
        buttonArray = [[NSMutableArray alloc]init];
        tabNumberFieldArray = [[NSMutableArray alloc]init];
    }
    
    return self;  
}

-(void)dealloc
{
    [buttonArray release]; 
    [tabNumberFieldArray release]; 
    [_smartBarItem release]; 
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}


-(void)awakeFromNib
{
    [self.view setWantsLayer:NO]; 
    [mainButton setImage:_smartBarItem.mainIcon]; 

    NSUInteger i = 0; 
    for (NSString *URL in _smartBarItem.URLArray) {
        RASmartBarButton *aButton = [[RASmartBarButton alloc]initWithFrame:NSMakeRect(button_x, button_x, button_w, button_h)];
        RADotTextField *aField = [[RADotTextField alloc]init]; 
        [aButton setImage:[_smartBarItem.buttonImageArrayOff objectAtIndex:i]]; 
        [aButton setAlternateImage:[_smartBarItem.buttonImageArrayOn objectAtIndex:i]]; 
        [aButton setTag:i];
        [aButton setTarget:self]; 
        [aButton setAction:@selector(onButtonClick:)]; 
        [aButton setButtonType:NSSwitchButton];
        [aButton setTitle:nil]; 
        [aButton setToolTip:_smartBarItem.appName]; 
        
        [self.view addSubview:aButton];
        [self.view addSubview:aField];
        [buttonArray addObject:aButton]; 
        [tabNumberFieldArray addObject:aField]; 
        [aButton release]; 
        [aField release]; 
        i++;
    }

    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:UPDATE_TAB_NUMBER 
                                              object:nil];

    _state = 0;
    _selectedButton = 0; 

    [mainButton setDelegate:self];
    [closeAppButton setAlphaValue:0.0]; 
    
}

#pragma mark -
#pragma mark animation

//fired when main app button is clicked
-(IBAction)onMainButtonClick:(id)sender
{
    
    if (_state == 0) {
        [self setSelectedButton];
        NSUInteger i = 0; 
        int h_button = 166; 
        int h_field =  150; 
        for (NSString *URL in _smartBarItem.URLArray) {
            RASmartBarButton *abutton = [buttonArray objectAtIndex:i]; 
            RADotTextField *aField = [tabNumberFieldArray objectAtIndex:i];
            [[abutton animator]setFrameOrigin:NSMakePoint(button_x, h_button)];            
            [[aField animator]setFrameOrigin:NSMakePoint(button_x, h_field)];
            [[abutton animator]setAlphaValue:1.0]; 
            [[aField animator]setAlphaValue:1.0];
            [abutton setEnabled:YES]; 
            h_button = h_button - 50; 
            h_field = h_field - 50; 
            i++; 
        }
        [delegate itemDidExpand:self];
        [[lightVIew animator]setAlphaValue:0.0];
        [[mainButton animator]setAlphaValue:1.0];
        [self hideCloseAppButton];
        //[delegate selectionDidChange:self];
        _state = 1;
    }
}

//fired to retract app
-(IBAction)onOtherAppClick:(id)sender
{   
    [self calculateTotalTab];
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    if (standardDefault) {
        if(totalTabs == 0 || [standardDefault integerForKey:OPPENED_TABS_BADGE] == 0)
        {
            [[lightVIew animator]setAlphaValue:0.0];
        }
        else
        {
            [[lightVIew animator]setAlphaValue:1.0];
        }
    }
    NSUInteger i = 0; 
    int h_button = 196; 
    int h_field =  196; 
    for (NSString *URL in _smartBarItem.URLArray) {
        RASmartBarButton *abutton = [buttonArray objectAtIndex:i]; 
        RADotTextField *aField = [tabNumberFieldArray objectAtIndex:i]; 
        [[abutton animator]setFrame:NSMakeRect(button_x, h_button, button_w, button_h)];
        [[aField animator]setFrame:NSMakeRect(button_x, h_field, button_w, number_h)];
        [abutton setEnabled:NO]; 
        [[abutton animator]setAlphaValue:0.0]; 
        [[aField animator]setAlphaValue:0.0]; 
        h_button = h_button - 50; 
        h_field = h_field - 50; 
        i++; 
    }
    [[closeAppButton animator]setFrame:NSMakeRect(close_x, close_y, close_w, close_h)];
    [[lightVIew animator]setFrame:NSMakeRect(light_x, light_y , light_w, light_h)];
    [[mainButton animator]setAlphaValue:0.5];
    
    [delegate itemDidRetract:self];
    _state = 0;
}

#pragma mark -
#pragma mark other
-(void)receiveNotification:(NSNotification *)notification
{
    [self updateTabsNumber];
}

-(void)updateStatusAndCleanMemory
{
    
}

#pragma mark -
#pragma mark inside button action

-(void)onButtonClick:(id)sender
{
    [self resetAllButton]; 
    RASmartBarButton *button = [buttonArray objectAtIndex:[sender tag]];
    RANavigatorViewController *navController = [_smartBarItem.navigatorViewControllerArray objectAtIndex:[sender tag]];
    [button setState:1];
    RAMainWindowController *mainWindow = [[NSApp keyWindow]windowController];
    if ([mainWindow.myCurrentViewController view] != nil)
		[[mainWindow.myCurrentViewController view] removeFromSuperview];
    
    if ([[navController tabsArray]count] == 0 || 
        (_selectedButton == [sender tag] && mainWindow.myCurrentViewController == navController)) {
        [navController view];
        [navController setPassedUrl:[_smartBarItem.URLArray objectAtIndex:[sender tag]]];
        [navController addtabs:mainButton]; 
    }
    
    if (navController != nil)
    {
        mainWindow.myCurrentViewController = navController;
    }
    [navController setMenu];
    
    
    
    /*
    [mainWindow.myCurrentViewController.view setWantsLayer:YES];
    transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    [transition setSubtype:kCATransitionFromTop];
    
    NSDictionary *ani = [NSDictionary dictionaryWithObject:transition 
                                                    forKey:@"subviews"];
    [mainWindow.myCurrentViewController.view setAnimations:ani]; 
    
    [self.view setAnimations:ani];
    */
    [mainWindow.centeredView addSubview:[mainWindow.myCurrentViewController view]];
    [mainWindow.myCurrentViewController.view setFrame:[mainWindow.centeredView bounds]];
    _selectedButton = [sender tag];
}

-(void)onCloseAppButtonClick:(id)sender
{
    if (_state == 1){
        RAMainWindowController *mainWindow = self.view.window.windowController;
        [mainWindow raven:nil];
    }
    [_smartBarItem cleanNavigatorController];
    [[lightVIew animator]setAlphaValue:0.0];
    [self hideCloseAppButton]; 
}


-(void)calculateTotalTab
{
    totalTabs = 0; 
    for (RANavigatorViewController *nav in self.smartBarItem.navigatorViewControllerArray) {
        totalTabs = totalTabs + nav.tabsArray.count; 
    }
}
-(void)updateTabsNumber
{
    [self calculateTotalTab];
    NSUInteger i = 0;
    for (NSTextField *aField in tabNumberFieldArray){
        RANavigatorViewController *nav = [_smartBarItem.navigatorViewControllerArray objectAtIndex:i]; 
        i++;
        [aField setStringValue:[self numberOfDotToDisplay:nav.tabsArray.count]]; 
    }
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
#pragma mark -
#pragma mark button management
//reset all buttons state for image reset
-(void)resetAllButton
{
    for (RASmartBarButton *button in buttonArray) {
        [button setState:0];
    }
}

-(void)hideCloseAppButton
{
    [[closeAppButton animator]setAlphaValue:0.0]; 
    [closeAppButton setEnabled:NO];
}

-(void)showCloseAppButton
{
    [self calculateTotalTab];
    for (RANavigatorViewController *nav in _smartBarItem.navigatorViewControllerArray) {
        if (nav.tabsArray.count >= 1) {
            [closeAppButton setEnabled:YES];
            [[closeAppButton animator]setAlphaValue:1.0]; 
        }
    }
}

-(void)hoverMainButton
{
    if (_state == 0) {
         [[mainButton animator]setAlphaValue:1.0];    
    }
}

-(void)hideHoverMainButton
{
    if (_state == 0){
        [[mainButton animator]setAlphaValue:0.5]; 
    }
}

//select previously selected button when switching app
-(void)setSelectedButton
{
    RASmartBarButton *button = [buttonArray objectAtIndex:_selectedButton]; 
    [self onButtonClick:button]; 
}

#pragma mark -
#pragma mark RASBAPPMainButtonDelegate

-(void)mouseDidEntered:(RASBAPPMainButton *)button
{
    [self hoverMainButton]; 
}

-(void)mouseDidExited:(RASBAPPMainButton *)button
{
    [self hideCloseAppButton]; 
    [self hideHoverMainButton]; 
}

-(void)shouldDisplayCloseButton:(RASBAPPMainButton *)button
{
    [self showCloseAppButton];
}

-(void)mouseDidScroll:(RASBAPPMainButton *)button
{
    [self hideCloseAppButton]; 
    [self hideHoverMainButton];
}

-(void)mouseDidClicked:(RASBAPPMainButton *)button
{
    [self hideCloseAppButton]; 
}

-(void)shouldDisplayHideButton:(RASBAPPMainButton *)button
{
    
}

-(void)shouldHideApp:(RASBAPPMainButton *)button
{
    RAlistManager *listManager = [RAlistManager sharedUser];
    RAMainWindowController *windowController = self.view.window.windowController; 
    if (_state == 1) {
        [windowController raven:nil];
    }
    [windowController hideAppAtIndex:_smartBarItem.index];
    [listManager changeStateOfAppAtIndex:_smartBarItem.index withState:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:SMART_BAR_UPDATE object:nil];
}

-(void)shouldCloseApp:(RASBAPPMainButton *)button
{
    [self onCloseAppButtonClick:self];
}

@end
