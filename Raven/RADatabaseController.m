//
//  DatabaseController.m
//  Raven
//
//  Created by Thomas Ricouard on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//*****THA Databae controller*****
// Ok, this use C API, but it is cool and optimized. It need a new layer to cache data and works directly in memory. 
// If you want to use CoreData, do it... 
//Also it is not very dynamic. FMDB anyone ? 
//*****YOU CAN START READING THE CODE IF YOU WANT*****

#import "RADatabaseController.h"
#import "NSString+Raven.h"

@implementation RADatabaseController
@synthesize history, bookmarks, suggestion, preciseSuggestion, historySearch; 
static RADatabaseController *sharedUserManager = nil;

#pragma mark init
+(RADatabaseController *)sharedUser
{
    if (sharedUserManager == nil) {
        sharedUserManager = [[super allocWithZone:NULL] init];
    }
    return sharedUserManager; 
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedUser] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}


-(void) checkAndCreateDatabase{
    // Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupport = [[NSString stringWithString:@"~/Library/Application Support/RavenApp"] stringByExpandingTildeInPath];
    NSString *favicon = [[NSString stringWithString:@"~/Library/Application Support/RavenApp/favicon"] stringByExpandingTildeInPath];
    NSString *skin = [[NSString stringWithString:@"~/Library/Application Support/RavenApp/skin"] stringByExpandingTildeInPath];
    NSString *bundle = [[NSString stringWithString:@"~/Library/Application Support/RavenApp/bundle"] stringByExpandingTildeInPath];
    //Check if exist, if not create the dir
    if ([fileManager fileExistsAtPath:applicationSupport] == NO)
        [fileManager createDirectoryAtPath:applicationSupport withIntermediateDirectories:YES attributes:nil error:nil];
    if ([fileManager fileExistsAtPath:favicon] == NO)
        [fileManager createDirectoryAtPath:favicon withIntermediateDirectories:YES attributes:nil error:nil];
    if ([fileManager fileExistsAtPath:skin] == NO)
        [fileManager createDirectoryAtPath:skin withIntermediateDirectories:YES attributes:nil error:nil];
    if ([fileManager fileExistsAtPath:bundle] == NO)
        [fileManager createDirectoryAtPath:bundle withIntermediateDirectories:YES attributes:nil error:nil];
    
    //Set the database path
    databasePath = [applicationSupport stringByAppendingPathComponent:databaseName]; 
    archivePath = [applicationSupport stringByAppendingPathComponent:defaultAppName];
    [databasePath retain]; 
    [archivePath retain]; 
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL successDatabase;
    BOOL successArchive; 
	// Check if the database has already been created in the users filesystem
    successDatabase = [fileManager fileExistsAtPath:databasePath];
    successArchive = [fileManager fileExistsAtPath:archivePath];
    
	// If the database already exists then return without doing anything
	if(successDatabase && successArchive) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
    NSString *pathDatabase = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName]; 
    NSString *archiveDatabase = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:defaultAppName];
	// Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:pathDatabase toPath:databasePath error:nil];
    [fileManager copyItemAtPath:archiveDatabase toPath:archivePath error:nil];
    
    fileManager = nil; 
	[fileManager release];
    
}

#pragma mark -
#pragma mark History management
//read the history table and load it in the history array
-(void)readHistoryFromDatabase
{
    /*
     //Sample if I port it to ENORMEGO database. Not so fast
     @synchronized(self){
     [history removeAllObjects]; 
     if( !history )
     {
     [history release], history = nil;
     }
     history = [[NSMutableArray alloc]init];
     EGODatabase* databasee = [EGODatabase databaseWithPath:databasePath];    
     EGODatabaseResult* result = [databasee executeQuery:@"SELECT * FROM History ORDER BY History_date DESC LIMIT 1500"];
     for(EGODatabaseRow* row in result) {
     int udid = [row intForColumnIndex:0];
     NSString *aTitle = [row stringForColumnIndex:1];
     NSString *aUrl = [row stringForColumnIndex:2];
     NSImage *image = [[NSImage alloc]initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/favicon/%@", [row stringForColumnIndex:3]]stringByExpandingTildeInPath]];
     int timesptamp = [row intForColumnIndex:4];
     NSDate *aDate = [[NSDate alloc]initWithTimeIntervalSince1970:timesptamp];
     //Create an history object
     RAItemObject *historyItem = [[RAItemObject alloc]initHistoryInitWithName:aTitle 
     url:aUrl 
     favico:image 
     date:aDate
     udid:udid]; 
     //add the created history object to our array
     [history addObject:historyItem];
     [historyItem release];
     [aDate release];
     [image release];
     
     }
     }
     */
    
    // Setup the database object
	sqlite3 *database;
    @synchronized(self){
        [history removeAllObjects]; 
        if( !history )
        {
            [history release], history = nil;
        }
        history = [[NSMutableArray alloc]init];
        // Open the database from the users filessytem
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            // Setup the SQL Statement and compile it for faster access
            const char *sqlStatement = "SELECT * FROM History ORDER BY History_date DESC LIMIT 1500";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
                // Loop through the results and add them to the feeds array
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Read the data from the result row
                    int udid = sqlite3_column_int(compiledStatement, 0);
                    NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                    NSString *aUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                    NSString *imagePath = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                    NSImage *image = [[NSImage alloc]initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/favicon/%@", imagePath]stringByExpandingTildeInPath]];
                    int timesptamp = sqlite3_column_int(compiledStatement, 4);
                    NSDate *aDate = [[NSDate alloc]initWithTimeIntervalSince1970:timesptamp];
                    //Create an history object
                    RAItemObject *historyItem = [[RAItemObject alloc]initHistoryInitWithName:aTitle 
                                                                                         url:aUrl 
                                                                                      favico:image 
                                                                                        date:aDate
                                                                                        udid:udid]; 
                    //add the created history object to our array
                    [history addObject:historyItem];
                    [historyItem release];
                    [aDate release];
                    [image release];
                }
            }
            // Release the compiled statement from memory
            sqlite3_finalize(compiledStatement);
            sqlite3_close(database); 
        }
    }
}

//insert an history item into the history table
-(void)insetHistoryItem:(NSString *)title url:(NSString *)url data:(NSData *)data date:(NSDate *)date
{
    int timestamp = [date timeIntervalSince1970];
    NSData *imagedata = [[NSData alloc]initWithData:data]; 
    int lengh = (int)[imagedata length];
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *querychar = "INSERT INTO History (History_title, History_url, History_image, History_date) VALUES (?, ?, ?, ?)";
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [url UTF8String], -1, SQLITE_TRANSIENT); 
            sqlite3_bind_blob(statement, 3, [imagedata bytes], lengh, NULL);
            sqlite3_bind_int(statement, 4, timestamp);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database);
    [imagedata release]; 
    
    
}


-(void)deleteHistoryItem:(int)udid
{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM History WHERE History_id = '%d'", udid];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database); 
}

//delete all history from database
-(void)deleteAllHistory
{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM History"];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain];
    }
    sqlite3_close(database);
    
}


-(void)removehistorySinceDate:(NSInteger)choice
{
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0]; 
    int timestamp = [currentDate timeIntervalSince1970];
    switch (choice) {
            //1 day
        case 0:
            timestamp = timestamp - 86400;
            break;
            //1 week
        case 1:
            timestamp = timestamp - 604800;
            break;
            //2 weeks
        case 2:
            timestamp = timestamp - 1209600;
            break;
            //1 month
        case 3:
            timestamp = timestamp - 2678400;
            break;
        case 4:
            //5 month
            timestamp = timestamp - 15634800;
            break;
        case 5:
            //1 Year
            timestamp = timestamp - 31536000;
            break;
        case 6:
            //No
            timestamp = 0;
            break;
        default:
            break;
    }
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM History WHERE History_date < '%d'", timestamp];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain];  
    }
    [currentDate release];
    sqlite3_close(database); 
}

-(void)historyForString:(NSString *)url
{
    // Setup the database object
	sqlite3 *database;
    if( history )
    {
        [history release], history = nil;
    }
	history = [[[NSMutableArray alloc]init]retain];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM History WHERE History_title LIKE '?%@?' ORDER BY History_date DESC LIMIT 450", url]; 
        query = [query stringByReplacingOccurrencesOfString:@"?" withString:@"%"]; 
		const char *sqlStatement = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                int udid = sqlite3_column_int(compiledStatement, 0);
                NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 3) length:sqlite3_column_bytes(compiledStatement, 3)];
                NSString *decoded = [[NSString alloc]initWithData:data encoding:NSStringEncodingConversionAllowLossy];
                NSImage *image = [[NSImage alloc]initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/favicon/%@", decoded]stringByExpandingTildeInPath]];
                int timesptamp = sqlite3_column_int(compiledStatement, 4);
                NSDate *aDate = [[NSDate alloc]initWithTimeIntervalSince1970:timesptamp];
                //Create an history object
				RAItemObject *historyItem = [[RAItemObject alloc] initHistoryInitWithName:aTitle 
                                                                                      url:aUrl 
                                                                                   favico:image 
                                                                                     date:aDate
                                                                                     udid:udid]; 
                
                //add the created boomark object into our bookmark array
				[history addObject:historyItem];
                [historyItem release];
                [data release]; 
                [image release];
                [aDate release];
                [decoded release];
                
                
                
            }
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        sqlite3_close(database); 
	}
}

-(void)purgeHistory
{
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0]; 
    int timestamp = [currentDate timeIntervalSince1970] - 2678400; 
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM History WHERE History_date < '%d'", timestamp];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        NSString *secondQuery = [NSString stringWithFormat:@"DELETE FROM History WHERE History_title = ''"];
        const char *secondQuerychar = [secondQuery UTF8String]; 
        sqlite3_stmt *secondStatement; 
        if (sqlite3_prepare_v2(database, secondQuerychar, -1, &secondStatement, NULL) == SQLITE_OK)
        {
            sqlite3_step(secondStatement);
            sqlite3_finalize(secondStatement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        [databasePath retain]; 
        [databaseName retain];  
    }
    [currentDate release];
    sqlite3_close(database); 
}


#pragma mark -
#pragma mark Bookmark management
-(void)readBookmarkFromDatabase:(int)type order:(int)order {
	// Setup the database object
	sqlite3 *database;
    
    if( bookmarks )
    {
        [bookmarks release], bookmarks = nil;
    }
	bookmarks = [[NSMutableArray alloc]init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        NSString *query; 
        if (order == 1) {
            query = [NSString stringWithFormat:@"SELECT * FROM Bookmarks WHERE Bookmark_type = '%d' ORDER BY Bookmark_title ASC", type];
        }
        else
        {
            query = [NSString stringWithFormat:@"SELECT * FROM Bookmarks WHERE Bookmark_type = '%d' ORDER BY Bookmark_adddate DESC", type];
        }
		const char *sqlStatement = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                int udid = sqlite3_column_int(compiledStatement, 0);
				NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 3) length:sqlite3_column_bytes(compiledStatement, 3)];
                NSImage *image = [[NSImage alloc]initWithData:data];
                int type = sqlite3_column_int(compiledStatement, 4); 
                int timesptamp = sqlite3_column_int(compiledStatement, 5);
                NSDate *aDate = [[NSDate alloc]initWithTimeIntervalSince1970:timesptamp];
                [image setSize:NSMakeSize(16, 16)]; 
                
                //Create a bookmark object with the database lavue
				RAItemObject *bookmark = [[RAItemObject alloc] initBookmarkAndFavoriteWithName:aTitle 
                                                                                           url:aUrl 
                                                                                        favico:image 
                                                                                          udid:udid 
                                                                                          type:type
                                                                                          date:aDate]; 
                
                
                
                //add the created boomark object into our bookmark array
				[bookmarks addObject:bookmark];
                [bookmark release];
                [data release];
                [image release]; 
                [aDate release]; 
                
                
                
            }
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        sqlite3_close(database); 
        [databasePath retain]; 
        [databaseName retain]; 
        
        
	}
    
}

//Insert the bookmark into the database
-(void)insertBookmark:(NSString *)title url:(NSString *)url data:(NSData *)data type:(int)ittype
{
    NSData *imagedata = [[NSData alloc]initWithData:data];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    int timestamp = [currentDate timeIntervalSince1970];
    int lengh = (int)[imagedata length];
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *querychar = "INSERT INTO Bookmarks (Bookmark_title, Bookmark_url, Bookmark_image, Bookmark_type, Bookmark_adddate) VALUES (?, ?, ?, ?, ?)";
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            //Bind value for SQlite
            sqlite3_bind_text(statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [url UTF8String], -1, SQLITE_TRANSIENT); 
            sqlite3_bind_blob(statement, 3, [imagedata bytes], lengh, NULL);
            sqlite3_bind_int(statement, 4, ittype); 
            sqlite3_bind_int(statement, 5, timestamp);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database);
    [imagedata release]; 
    [currentDate release]; 
    
}


//Delete a bookmark from database
-(void)deletefromDatabase:(int)udid
{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM Bookmarks WHERE Bookmark_id = '%d'", udid];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database);
    
}

-(void)deleteAllFavorites
{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM Bookmarks where Bookmark_type = 0"];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database);
}

-(void)deleteAllBookmarks
{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM Bookmarks where Bookmark_type = 1"];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database);
}


-(void)editFavorite:(int)udid title:(NSString *)title url:(NSString *)url type:(int)type
{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"UPDATE Bookmarks set Bookmark_title = '%@', Bookmark_url = '%@', Bookmark_type = '%d' WHERE Bookmark_id = '%d';",title, url, type, udid];
        const char *querychar = [query UTF8String]; 
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database); 
    
    
}

-(void)updateBookmarkFavicon:(NSData *)favicon forUrl:(NSString *)URL
{
    NSData *imagedata = [[NSData alloc]initWithData:favicon]; 
    int lengh = (int)[imagedata length];
    
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *querychar = "UPDATE Bookmarks set Bookmark_image = ? WHERE Bookmark_url = ?";
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(statement, 2, [URL UTF8String], -1, SQLITE_TRANSIENT); 
            sqlite3_bind_blob(statement, 1, [imagedata bytes], lengh, NULL);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database); 
    [imagedata release]; 
}


#pragma mark -
#pragma mark Other

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error movingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSLog(@"%@", error);
    return YES;
}
-(void)loadAsynchImage:(NSImage *)image
{
    
}
    




-(void)searchBookmark:(NSString *)title
{

    
}

//used to fill up the suggestion box under the address bar
-(void)suggestionForString:(NSString *)url
{
    url = [url stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    // Setup the database object
	sqlite3 *database;
    if( suggestion )
    {
        [suggestion release], suggestion = nil;
    }
	suggestion = [[NSMutableArray alloc]init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT (History_url), History_title, History_image FROM History WHERE History_title LIKE '%@?'OR History_url LIKE 'http://%@?' OR History_url LIKE 'https://%@?' OR History_url LIKE 'http://www.%@?' OR History_url LIKE 'https://www.%@?' ORDER BY LENGTH(History_url) ASC LIMIT 10", url, url, url, url, url]; 
        query = [query stringByReplacingOccurrencesOfString:@"?" withString:@"%"]; 
		const char *sqlStatement = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                int udid = sqlite3_column_int(compiledStatement, 0);
				NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *imagePath = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSImage *image = [[NSImage alloc]initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/favicon/%@", imagePath]stringByExpandingTildeInPath]];
                [image setSize:NSMakeSize(16, 16)]; 
                //Create a bookmark object with the database lavue
				RAItemObject *aSuggestion = [[RAItemObject alloc] initWithName:aTitle url:aUrl favico:image udid:udid]; 
                
                //add the created boomark object into our bookmark array
				[suggestion addObject:aSuggestion];
                [aSuggestion release];
                [image release];
                
            }
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        sqlite3_close(database); 
	}
}

-(void)preciseSuggestionForString:(NSString *)url
{
    // Setup the database object
	sqlite3 *database;
    if( preciseSuggestion )
    {
        [preciseSuggestion release], preciseSuggestion = nil;
    }
	preciseSuggestion = [[NSMutableArray alloc]init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM History WHERE History_url LIKE '?%@?/' ORDER BY History_title ASC LIMIT 1", url]; 
        query = [query stringByReplacingOccurrencesOfString:@"?" withString:@"%"];
		const char *sqlStatement = [query UTF8String]; 
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                int udid = sqlite3_column_int(compiledStatement, 0);
				NSString *aTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 3) length:sqlite3_column_bytes(compiledStatement, 3)];
                NSString *decoded = [[NSString alloc]initWithData:data encoding:NSStringEncodingConversionAllowLossy];
                NSImage *image = [[NSImage alloc]initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/RavenApp/favicon/%@", decoded]stringByExpandingTildeInPath]];
                [image setSize:NSMakeSize(16, 16)]; 
                
                //Create a bookmark object with the database lavue
				RAItemObject *aSuggestion = [[RAItemObject alloc] initWithName:aTitle url:aUrl favico:image udid:udid]; 
                
                //add the created boomark object into our bookmark array
				[preciseSuggestion addObject:aSuggestion];
                [aSuggestion release];
                [data release];
                [image release]; 
                [decoded release];
                
                
                
            }
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        sqlite3_close(database);  
	}
    
}



-(void)importBookmarkFromSafari
{
    NSString *path = [@"~/Library/Safari/Bookmarks.plist" stringByExpandingTildeInPath];
    NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *folders = [[dict objectForKey:@"Children"]copy];
    NSDictionary *bookmarksBar;
    for (NSDictionary *folder in folders)
    {
        if ([[folder objectForKey:@"Title"] isEqualToString:@"BookmarksBar"])  
            
        {
            bookmarksBar = folder;
        }
    }
    NSArray *items = [[bookmarksBar objectForKey:@"Children"]copy];
    NSMutableArray *bookmarksItemURL = [[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *bookmarksItemTitleTemp = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary *dict in items)
    {
        if ([[dict objectForKey:@"WebBookmarkType"]isEqualToString:@"WebBookmarkTypeList"] ) {
            NSArray *itemsSub = [[dict objectForKey:@"Children"]copy];
            for (NSDictionary *dictSub in itemsSub)
            {
                if (![[dictSub objectForKey:@"WebBookmarkType"]isEqualToString:@"WebBookmarkTypeList"] ) 
                {
                [bookmarksItemURL addObject:[dictSub objectForKey:@"URLString"]];
                [bookmarksItemTitleTemp addObject:[dictSub objectForKey:@"URIDictionary"]]; 
                }
                else
                {
                    
                }
            }
            [itemsSub release];
        }
        else
        {
            [bookmarksItemURL addObject:[dict objectForKey:@"URLString"]];
            [bookmarksItemTitleTemp addObject:[dict objectForKey:@"URIDictionary"]];
        }
        
    }
    NSMutableArray *bookmarksItemTitle = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary *dictTitle in bookmarksItemTitleTemp)
    {
        [bookmarksItemTitle addObject:[dictTitle objectForKey:@"title"]];
    }
    for (int i=0; i<bookmarksItemURL.count; i++) {
    sqlite3 *database;
    NSImage *image = [NSImage imageNamed:@"MediumSiteIcon.png"];
    NSData *imagedata =  [image TIFFRepresentation]; 
    int lengh = (int)[imagedata length];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *querychar = "INSERT INTO Bookmarks (Bookmark_title, Bookmark_url, Bookmark_image, Bookmark_type) VALUES (?, ?, ?, ?)";
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            //Bind value for SQlite
            sqlite3_bind_text(statement, 1, [[bookmarksItemTitle objectAtIndex:i]UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [[bookmarksItemURL objectAtIndex:i]UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(statement, 3, [imagedata bytes], lengh, NULL);
            sqlite3_bind_int(statement, 4, 0); 
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database);
    }
    [folders release];
    [items release];
}

-(void)importHistoryFromSafari
{
    
}

//fired at each launch to clean database from blank
-(void)vacuum
{
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *querychar = "vacuum";
        sqlite3_stmt *statement; 
        if (sqlite3_prepare_v2(database, querychar, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Error"); 
        }
        
        [databasePath retain]; 
        [databaseName retain]; 
    }
    sqlite3_close(database); 

}
- (void)dealloc
{
    [history release];
    [suggestion release];
    [bookmarks release];
    [preciseSuggestion release];
    [databasePath release]; 
    [super dealloc];
}

@end
