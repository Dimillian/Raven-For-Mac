//
//  RAGrowlDispatcher.h
//  Raven
//
//  Created by Thomas Ricouard on 07/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Growl/Growl.h"
#import "Growl/GrowlApplicationBridge.h"

@interface RAGrowlDispatcher : NSObject <GrowlApplicationBridgeDelegate> {
    
}
-(void)receiveNotification:(NSNotification *)notification;
-(void)growlAlert:(NSString *)message title:(NSString *)title;

@end
