//
//  NSString+Raven.m
//  Raven
//
//  Created by Thomas Ricouard on 05/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+Raven.h"

@implementation NSString (customizedString)

-(NSString *)createFileNameFromString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"%" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"?" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"=" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    string = [string stringByPaddingToLength:253 withString: @"." startingAtIndex:0];
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];   
    
    return string;

}

@end
