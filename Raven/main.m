    //
//  main.m
//  Raven
//
//  Created by Thomas Ricouard on 25/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebIconDatabaseEnabled"];
    return NSApplicationMain(argc, (const char **)argv);
}
