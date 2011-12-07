//
//  NSString+Raven.m
//  Raven
//
//  Created by Thomas Ricouard on 05/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//******NO********
#import "NSString+Raven.h"

@implementation NSString (customizedString)

-(NSString *)createFileNameFromString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"http" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"https" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"www" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"%" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"?" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"=" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (string.length > 16) {
            string = [string substringToIndex:15];
    }

    
    return string;

}

@end
