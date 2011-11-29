//
//  historyObject.h
//  Raven
//
//  Created by Thomas Ricouard on 31/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>



@interface RAItemObject : NSObject  {
    
    int udid; 
    int type; 
    NSString *title; 
    NSString *url; 
    NSImage *favico; 
    NSDate *date;
}
@property int type; 
@property int udid; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *url; 
@property (nonatomic, retain) NSImage *favico; 
@property (nonatomic, retain) NSDate *date; 
-(id)initWithName:(NSString *)n url:(NSString *)d favico:(NSImage *)v udid:(int)q;
-(id)initBookmarkAndFavoriteWithName:(NSString *)n url:(NSString *)d favico:(NSImage *)v udid:(int)q type:(int)t date:(NSDate *)da;
-(id)initHistoryInitWithName:(NSString *)n url:(NSString *)d favico:(NSImage *)v date:(NSDate *)x udid:(int)q;
@end

