//
//  RAInstapaperSubmit.h
//  Raven
//
//  Created by Thomas Ricouard on 13/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTInstapaperAPI.h"
#import "EMKeychainItem.h"

@protocol RAInstapaperDelegate; 
@interface RAInstapaperSubmit : NSObject <LTInstapaperAPIDelegate>
{
    id<RAInstapaperDelegate>thisDelegate; 
    LTInstapaperAPI *localInsta; 
    NSString *_localTitle; 
    NSString *_localURL; 
}
-(void)setTitle:(NSString *)title URL:(NSString *)URL; 
-(void)submitToInsta;
-(void)succeeded;

@property (nonatomic, assign) id<RAInstapaperDelegate>thisDelegate; 
@property (nonatomic, copy) NSString *localTitle; 
@property (nonatomic, copy) NSString *localURL; 
@end

@protocol RAInstapaperDelegate 
-(void)didFinishAddingBookmarkToInstapaper:(RAInstapaperSubmit *)RAInstapaper; 
@end
