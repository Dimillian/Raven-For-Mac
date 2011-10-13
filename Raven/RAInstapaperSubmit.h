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

@interface RAInstapaperSubmit : NSObject <LTInstapaperAPIDelegate>
{
    LTInstapaperAPI *localInsta; 
    NSString *localeTitle; 
    NSString *localeURL; 
}
-(void)setTitle:(NSString *)title URL:(NSString *)URL; 
-(void)submitToInsta;
-(void)succeeded;

@end
