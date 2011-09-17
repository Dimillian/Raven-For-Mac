//
//  DownloadViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadViewController.h"
#import "MyDownloadCell.h"


@implementation DownloadViewController
#define LISTVIEW_CELL_IDENTIFIER		@"MyDownloadCell"
-(void)awakeFromNib
{

    //set the view on the history view view
    [listView setCellSpacing:0.0f];
	[listView setAllowsEmptySelection:NO];
	[listView registerForDraggedTypes:[NSArray arrayWithObjects: NSStringPboardType, nil]];
	[self check:nil];
    
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(check:)
                                           userInfo:nil
                                            repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    selectedRowSave = 0; 
     
 
}


//Reload the tableview list from the database
-(void)check:(id)sender
{
    DownloadController *controler = [DownloadController sharedUser];
    //[controler writeDownloadInplist];
    count = [controler.downloadArray count];
    [listView reloadData]; 
    if (count > 0){
    [listView setSelectedRow:selectedRowSave];
         }
}

- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView
{
    return count;
}

- (PXListViewCell*)listView:(PXListView*)aListView cellForRow:(NSUInteger)row
{
	MyDownloadCell *cell = (MyDownloadCell*)[aListView dequeueCellWithReusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	
	if(!cell) {
		cell = [MyDownloadCell cellLoadedFromNibNamed:LISTVIEW_CELL_IDENTIFIER reusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	}
    
    // Set up the new cell:
    DownloadController *controler = [DownloadController sharedUser];
    //Get the bookmark at the index from the selected row
    DownloadObject *download = (DownloadObject *)[controler.downloadArray objectAtIndex:row]; 
     NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	[[cell titleLabel] setStringValue:[download name]];
    [[cell progressView]setDoubleValue:[download.progress doubleValue]];
    [[cell progressText]setStringValue:[NSString stringWithFormat:@"%@ of %@ downloaded",[self stringFromFileSize:[download.progressBytes intValue]],[self stringFromFileSize:[download.size intValue]]]]; 
    [[cell iconDownload]setImage:[workspace iconForFile:download.path]];
    [[cell openButton]setTarget:self]; 
    [[cell openButton]setAction:@selector(openFile:)];



    
	
	return cell;
}

- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row
{
	return 50;
}

- (void)listViewSelectionDidChange:(NSNotification*)aNotification
{
    selectedRowSave = [listView selectedRow]; 
    NSInteger row = [listView selectedRow]; 
    DownloadController *controller = [DownloadController sharedUser];
    DownloadObject *aDownload = (DownloadObject *)[controller.downloadArray objectAtIndex:row];
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace]; 
    //send the url to the class instancied webview
    [downloadPath setStringValue:aDownload.path];
    [source setStringValue:aDownload.downloadUrl]; 
    [size setStringValue:[self stringFromFileSize:[aDownload.size intValue]]]; 
    [name setStringValue:aDownload.name]; 
    NSImage *icon = [workspace iconForFile:aDownload.path]; 
    [icon setSize:NSMakeSize(150, 150)];
    [iconFile setImage:icon]; 
    [typeOfFile setStringValue:[self humanReadableFileType:[aDownload path]]]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attribute = [fileManager attributesOfItemAtPath:aDownload.path error:nil]; 
    if ([attribute objectForKey:NSFileModificationDate] != nil) {
    [date setStringValue:[formatter stringFromDate:[attribute objectForKey:NSFileModificationDate]]]; 
    }

    
}

-(void)openFile:(id)sender
{
    NSInteger row = [listView selectedRow]; 
    DownloadController *controller = [DownloadController sharedUser];
    DownloadObject *aDownload = (DownloadObject *)[controller.downloadArray objectAtIndex:row];
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace]; 
    [workspace selectFile:aDownload.path inFileViewerRootedAtPath:aDownload.path]; 
}

-(void)moveToTrash:(id)sender
{
    //NSInteger row = [listView selectedRow]; 
    //DownloadController *controller = [DownloadController sharedUser];
    //DownloadObject *aDownload = (DownloadObject *)[controller.downloadArray objectAtIndex:row];
    //NSWorkspace *workspace = [NSWorkspace sharedWorkspace]; 
}

-(NSString *)humanReadableFileType:(NSString *)path{
    NSString *kind = nil;
    NSURL *url = [NSURL fileURLWithPath:[path stringByExpandingTildeInPath]];
    LSCopyKindStringForURL((CFURLRef)url, (CFStringRef *)&kind);
    return kind ? [kind autorelease] : @"";
}


-(void)resetList:(id)sender
{
    NSInteger row = [listView selectedRow]; 
    DownloadController *controller = [DownloadController sharedUser]; 
    [controller.downloadArray removeObjectAtIndex:row]; 
    selectedRowSave = 0; 
    [self check:nil]; 
}

- (NSString *)stringFromFileSize:(int)theSize
{
	float floatSize = theSize;
	if (theSize<1023)
		return([NSString stringWithFormat:@"%i bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
	
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

- (void)dealloc
{

    [super dealloc];
}

@end
