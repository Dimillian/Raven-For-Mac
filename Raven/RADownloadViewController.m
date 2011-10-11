//
//  DownloadViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RADownloadViewController.h"
#import "RADownloadCell.h"


@implementation RADownloadViewController
#define LISTVIEW_CELL_IDENTIFIER		@"RADownloadCell"
-(void)awakeFromNib
{

    //set the view on the history view view
    [listView setCellSpacing:0.0f];
	[listView setAllowsEmptySelection:NO];
	[listView registerForDraggedTypes:[NSArray arrayWithObjects: NSStringPboardType, nil]];
	[self check:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:@"downloadDidUpdate" 
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(receiveNotification:) 
                                                name:@"downloadDidFinish" 
                                              object:nil];
    

    selectedRowSave = 0; 
     
 
}

-(void)receiveNotification:(NSNotification *)notification
{
    [self check:nil];
}


//Reload the tableview list from the database
-(void)check:(id)sender
{
    RADownloadController *controler = [[RADownloadController alloc]init];
    //[controler writeDownloadInplist];
    count = [controler.downloadArray count];
    [controler release];
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
	RADownloadCell *cell = (RADownloadCell*)[aListView dequeueCellWithReusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	
	if(!cell) {
		cell = [RADownloadCell cellLoadedFromNibNamed:LISTVIEW_CELL_IDENTIFIER reusableIdentifier:LISTVIEW_CELL_IDENTIFIER];
	}
    
    // Set up the new cell:
    RADownloadController *controler = [[RADownloadController alloc]init];
    //Get the bookmark at the index from the selected row
    RADownloadObject *download = (RADownloadObject *)[controler.downloadArray objectAtIndex:row]; 
     NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	[[cell titleLabel] setStringValue:[download name]];
    [[cell progressView]setDoubleValue:[download.progress doubleValue]];
    [[cell progressText]setStringValue:[NSString stringWithFormat:@"%@ of %@ downloaded",[self stringFromFileSize:[download.progressBytes intValue]],[self stringFromFileSize:[download.size intValue]]]]; 
    [[cell iconDownload]setImage:[workspace iconForFile:download.path]];
    [[cell openButton]setTarget:self]; 
    [[cell openButton]setAction:@selector(openFile:)];
    if (download.size == download.progressBytes) {
        [[cell progressText]setStringValue:@"Download complete!"];
    }
    [controler release];
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
    RADownloadController *controller = [[RADownloadController alloc]init];
    RADownloadObject *aDownload = (RADownloadObject *)[controller.downloadArray objectAtIndex:row];
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
    [controller release];

    
}

-(void)openFile:(id)sender
{
    NSInteger row = [listView selectedRow]; 
    RADownloadController *controller = [[RADownloadController alloc]init];
    RADownloadObject *aDownload = (RADownloadObject *)[controller.downloadArray objectAtIndex:row];
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace]; 
    [workspace selectFile:aDownload.path inFileViewerRootedAtPath:aDownload.path]; 
    [controller release];
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
    RADownloadController *controller = [[RADownloadController alloc]init]; 
    [controller.downloadArray removeObjectAtIndex:row]; 
    selectedRowSave = 0; 
    [self check:nil]; 
    [controller release];
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [super dealloc];
}

@end
