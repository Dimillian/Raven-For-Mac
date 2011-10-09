//
//  DatabaseController.h
//  Raven
//
//  Created by Thomas Ricouard on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "url.h"
#import <sqlite3.h>
#import "RAItemObject.h"


@interface RADatabaseController : NSObject {

     NSMutableArray *bookmarks;
     NSMutableArray *history;
     NSMutableArray *historySearch; 
     NSMutableArray *suggestion; 
     NSMutableArray *preciseSuggestion; 
     NSString *databasePath;
    NSString *archivePath;

}
@property (nonatomic, assign) NSMutableArray *bookmarks; 
@property (nonatomic, assign) NSMutableArray *history; 
@property (nonatomic, assign) NSMutableArray *suggestion; 
@property (nonatomic, assign) NSMutableArray *preciseSuggestion;
@property (nonatomic, assign) NSMutableArray *historySearch; 
+(RADatabaseController *)sharedUser;
-(void)checkAndCreateDatabase;
-(void)readBookmarkFromDatabase:(int)type order:(int)order; 
-(void)readHistoryFromDatabase; 
-(void)insertBookmark:(NSString *)title url:(NSString *)url data:(NSData *)data type:(int)ittype;
-(void)updateBookmarkFavicon:(NSData *)favicon forUrl:(NSString *)URL; 
-(void)insetHistoryItem:(NSString *)title url:(NSString *)url data:(NSData *)data date:(NSDate *)date;
-(void)editFavorite:(int)udid title:(NSString *)title url:(NSString *)url type:(int)type;
-(void)searchBookmark:(NSString *)title; 
-(void)deletefromDatabase:(int)udid; 
-(void)deleteHistoryItem:(int)udid;
-(void)suggestionForString:(NSString *)url;
-(void)historyForString:(NSString *)url; 
-(void)preciseSuggestionForString:(NSString *)url; 
-(void)deleteAllHistory; 
-(void)deleteAllBookmarks; 
-(void)deleteAllFavorites; 
-(void)purgeHistory;
-(void)removehistorySinceDate:(NSInteger)choice;
-(void)importBookmarkFromSafari;
-(void)importHistoryFromSafari; 
-(void)vacuum; 


@end
