//
//  RAGoogleSuggestionsParser.m
//  Raven
//
//  Created by Thomas Ricouard on 07/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAGoogleSuggestionsParser.h"

@implementation RAGoogleSuggestionsParser
@synthesize delegate, URLToParse;

-(id)initWithDelegate:(id<RAGoogleSuggestionDelegate>)dgate
{
    if (self = [super init]) {
        self.delegate = dgate;
        suggestionResults = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)startParsing
{
    receivedData = [[NSMutableData alloc] init];
    [suggestionResults removeAllObjects];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:URLToParse] delegate:self];
    
    [urlConnection start];
    
}
                                      
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:receivedData];
    [parser setDelegate:self];
    [parser parse];
    
}


-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([attributeDict objectForKey:@"data"] != nil) {
        [suggestionResults addObject:[attributeDict objectForKey:@"data"]];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [delegate didFinishParsing:self];
}

-(NSMutableArray *)returnSuggestions
{
    return suggestionResults; 
}

-(void)dealloc
{
    [suggestionResults release];
    [URLToParse release];
    [super dealloc];
}

@end
