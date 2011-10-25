//
//  TextFieldController.m
//  Raven
//
//  Created by Thomas Ricouard on 20/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAAddressField.h"
#import "RAAddressFieldBox.h"


@implementation RAAddressField 
@synthesize tableViewEdit;


-(void)awakeFromNib
{
    ind = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil]; 
    //[tableview setAllowsEmptySelection:NO]; 
}

/*
-(BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    NSView *superview = [self superview];
    NSArray *subviews =[superview subviews];
    for (id view in subviews)
    {
        if ([view isKindOfClass:[RAAddressFieldBox class]]) {
            RAAddressFieldBox *box = view; 
            [box setFocusColor];
        }
    }
    return YES; 
}


-(BOOL)resignFirstResponder
{
    NSView *superview = [self superview];
    NSArray *subviews =[superview subviews];
    for (id view in subviews)
    {
        if ([view isKindOfClass:[RAAddressFieldBox class]]) {
            RAAddressFieldBox *box = view; 
            [box setNormalColor];
        }
    }
    [super resignFirstResponder];
    return YES;
}
*/

//log enter key and reset index
- (void)keyUp:(NSEvent *)theEvent
{
    NSUInteger event = [theEvent keyCode]; 
    switch (event) {
        case 36: 
                ind = 0;
                [self performClick:self];
            break; 
            default:
            return;
            
    }
}


-(void)windowDidResize:(NSNotification *)notification
{
    //[self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, [self window].frame.size.width /3, self.frame.size.height)];
}

- (void)moveLeft:(id)sender
{
    //get the current string length
    NSUInteger lenght = [[self stringValue]length];
    //access NSText of current NStextField
    NSText *currentEditor = [self currentEditor];
    //getting the current selection  (numer of chars selected) of the carret
    NSUInteger currentRange = currentEditor.selectedRange.length;
    //getting the current location of the carret
    NSUInteger currentLocation = currentEditor.selectedRange.location; 
    NSUInteger null = lenght - lenght;
    //now it is pretty obvious, if the total == the current selection then all is selected
    if (lenght == currentRange) {
        [currentEditor setSelectedRange:NSMakeRange(0, 0)];
    }
    else if (currentLocation > null)
    {
        [currentEditor setSelectedRange:NSMakeRange(currentEditor.selectedRange.location - 1.0, 0)];
    }
}

-(void)moveRight:(id)sender
{
    NSUInteger lenght = [[self stringValue]length];
    NSText *currentEditor = [self currentEditor];
    NSUInteger currentRange = currentEditor.selectedRange.length;
    NSUInteger currentLocation = currentEditor.selectedRange.location; 
    if (lenght == currentRange) {
        [currentEditor setSelectedRange:NSMakeRange(lenght, 0)];
    }
    else if (lenght > currentLocation)
    {
        [currentEditor setSelectedRange:NSMakeRange(currentEditor.selectedRange.location + 1.0, 0)];
    }
}

- (void)updateTrackingAreas
{
    for( NSTrackingArea * trackingArea in [self trackingAreas] )
    {
        [self removeTrackingArea:trackingArea];
    }
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                         options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow
                                                           owner:self
                                                        userInfo:nil];
    [self addTrackingArea:[area autorelease]];
}
- (void)mouseEntered:(NSEvent *)theEvent
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        if ([standardUserDefaults integerForKey:SELECT_URL_MOUSE_HOVER] == 1) {
    [self selectText:self];  
        }
    }
}

-(void)mouseExited:(NSEvent *)theEvent
{

}

-(void)moveUp:(id)sender
{
    if (ind >=0) {
        ind = ind -1;
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:ind];
        [tableview selectRowIndexes:indexSet byExtendingSelection:NO];
        [indexSet release]; 
    }
    else
    {
        [self becomeFirstResponder]; 
    }
    return;
}

-(void)moveDown:(id)sender  
{
    if (ind <= count) {
        ind = ind +1;
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:ind];
        [tableview selectRowIndexes:indexSet byExtendingSelection:NO];
        [indexSet release]; 
    }
    return; 

}

-(BOOL)textView:(NSTextView *)aTextView doCommandBySelector:
(SEL)aSelector{
    return [self tryToPerform:aSelector with:aTextView];
}


-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = [tableview selectedRow];
    RADatabaseController *controller = [RADatabaseController sharedUser];
    RAItemObject *bookmark = (RAItemObject *)[controller.suggestion objectAtIndex:row]; 
    [self setStringValue:bookmark.url]; 
    
}


-(void)closeSuggestionBox
{
    ind = -1; 
    [[self window] removeChildWindow:attachedWindow];
    [attachedWindow orderOut:self];
    [attachedWindow release], attachedWindow = nil;; 
}

-(void)textDidChange:(NSNotification *)notification
{
    //If the field is empty then hide the suggestion box
    if ([[self stringValue]isEqualToString:@""]) {
        [self closeSuggestionBox];
    }
    //else verify the user setting then launch check in an separated thread
    else
    {

        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults) {
            if ([standardUserDefaults integerForKey:SUGGESTION_BAR] == 1) {
                [self check:nil];
                
                
            }
        }
    }
}



-(void)textDidEndEditing:(NSNotification *)notification
{
    
    [self closeSuggestionBox];
    [super textDidEndEditing:notification];

}



-(void)check:(id)sender
{
    [self display];
    RADatabaseController *controller = [RADatabaseController sharedUser];
    [controller suggestionForString:[self stringValue]];
    count = [controller.suggestion count];
    if ([controller.suggestion count] != 0) {
        //set the view size 
        [tableview reloadData];
        //[attachedWindow setFrame:[scrollView frame] display:YES];
        if (!attachedWindow) {
            int side = 11;
            CGFloat x = self.superview.frame.origin.x;
            x = x + 190; 
            CGFloat y = self.superview.frame.origin.y; 
            y = y + 19;
            NSPoint buttonPoint = NSMakePoint(x,y);
            [NSBundle loadNibNamed:@"SuggestionBox" owner:self];
            attachedWindow = [[MAAttachedWindow alloc] initWithView:scrollView 
                                                    attachedToPoint:buttonPoint 
                                                           inWindow:[self window] 
                                                             onSide:side 
                                                         atDistance:14];
            [attachedWindow setBorderColor:[NSColor blackColor]];
            [attachedWindow setBackgroundColor:[NSColor blackColor]];
            [attachedWindow setAlphaValue:0];
            [attachedWindow setViewMargin:7];
            [attachedWindow setBorderWidth:2];
            [attachedWindow setCornerRadius:10];
            [attachedWindow setHasArrow:1];
            [attachedWindow setDrawsRoundCornerBesideArrow:1];
            [attachedWindow setArrowBaseWidth:30];
            [attachedWindow setArrowHeight:15];
            [[self window] addChildWindow:attachedWindow ordered:NSWindowAbove];
            [attachedWindow setAlphaValue:0.0];
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0.2];  
            [attachedWindow makeKeyAndOrderFront:self];
            [[attachedWindow animator] setAlphaValue:0.93];
            [NSAnimationContext endGrouping];
        }
        else
        {
            
        }
    }
    else
    {
        [self closeSuggestionBox];
        
    } 
}

//return the number of row to dislay
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return count; 
}



//Display the cell int he tableview
- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{   
    RADatabaseController *controller = [RADatabaseController sharedUser];
    if (row < count)
    {
        RAItemObject *bookmark = (RAItemObject *)[controller.suggestion objectAtIndex:row]; 
        if (tableColumn == titleColumn) {
            return bookmark.title;
        }
        if (tableColumn == urlColumn) {
            return bookmark.url; 
        }
        if (tableColumn == faviconColumn)
        {
            return bookmark.favico; 
        }
    }
    return nil;
}


//Load the selected row url into the browser
- (IBAction)LoadSelectedRow:(id)sender
{    
    NSInteger row = [tableview selectedRow];
    RADatabaseController *controller = [RADatabaseController sharedUser];
    RAItemObject *bookmark = (RAItemObject *)[controller.suggestion objectAtIndex:row]; 
    [self setStringValue:bookmark.url]; 
    [self performClick:self];
    [self closeSuggestionBox]; 
    
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}


@end
