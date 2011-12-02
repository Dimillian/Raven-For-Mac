//
//  historyObject.m
//  Raven
//
//  Created by Thomas Ricouard on 31/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAItemObject.h"


@implementation RAItemObject
@synthesize title = _title, url = _url, favico =_favico, date = _date, udid = _udid, type = _type; 

-(id)initWithName:(NSString *)n url:(NSString *)d favico:(NSImage *)v udid:(int)q;
{
    _udid = q;
    self.title = n; 
    self.url = d; 
    self.favico = v; 
    return self; 
}
-(id)initBookmarkAndFavoriteWithName:(NSString *)n url:(NSString *)d favico:(NSImage *)v udid:(int)q type:(int)t date:(NSDate *)da
{
  if (self = [super init]) {
      _udid = q;
      _type = t;
      self.title = n; 
      self.url = d; 
      self.favico = v; 
      self.date = da; 
  }
    return (self); 
}
//It is a metamorph, 2 in 1, bookmark + history item. Credit to me
-(id)initHistoryInitWithName:(NSString *)n url:(NSString *)d favico:(NSImage *)v date:(NSDate *)x udid:(int)q;
{
    if (self = [super init]) {
        _udid = q;
        self.title = n; 
        self.url = d; 
        self.favico = v; 
        self.date = x;
    }
    return (self); 
}

-(void)dealloc
{
    [_title release]; 
    [_url release];
    [_favico release]; 
    [_date release]; 
    [super dealloc]; 
}


@end
