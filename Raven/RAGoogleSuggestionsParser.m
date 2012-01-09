//
//  RAGoogleSuggestionsParser.m
//  Raven
//
//  Created by Thomas Ricouard on 07/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RAGoogleSuggestionsParser.h"

@implementation RAGoogleSuggestionsParser
@synthesize urlConnection, asyncData, url, feedParser, currentElement, delegate, currentSuggestionString;

#pragma mark - init
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self; 
}

-(id)initWithUrl:(NSURL *)feedUrl
{
    self = [super init]; 
    if (self) {
        self.url = feedUrl; 
    }
    return self; 
}
#pragma mark - parser method
-(void)parse{
    
    [self reset]; 
    isParsing = YES; 
    [delegate feedParserDidStartParsing:self]; 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                                            timeoutInterval:60];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (urlConnection) {
        asyncData = [[NSMutableData alloc] init];
    }
    
    [request release]; 
    
}

-(void)reset{
    isParsing = NO;
    [self.feedParser abortParsing]; 
    // Stop downloading
    [urlConnection cancel];
    self.urlConnection = nil;
    self.asyncData = nil;
}

#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[asyncData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[asyncData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// Failed
	[self reset]; 
    
    [delegate feedParserDidFailParsingWithError:self];
    // Error
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	// Succeed
	// Parse
    [self startParsingWithData:asyncData]; 
    isParsing = YES; 
    // Cleanup
    self.urlConnection = nil;
    self.asyncData = nil;
    
}

#pragma mark - NSXMLParser delegate
-(void)startParsingWithData:(NSData *)data
{
    NSXMLParser *newFeedParser = [[NSXMLParser alloc] initWithData:data];
    self.feedParser = newFeedParser;
    [newFeedParser release];
    if (feedParser) { 
        self.feedParser.delegate = self;
        [self.feedParser setShouldProcessNamespaces:YES];
        [self.feedParser parse];
    }
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName; 
    //new item
    //else if ([currentElement isEqualToString:@"title"]){
    //    self.currentTitleString = [[NSString alloc]init]; 
   // }
    if ([attributeDict objectForKey:@"data"] != nil) {
        [delegate feedParserDidParseAnItem:[attributeDict objectForKey:@"data"]];
    }

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //else if ([elementName isEqualToString:@"title"]){
    //    self.currentTitleString = nil; 
   // }

    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //parse current item
   // if ([currentElement isEqualToString:@"title"]) {
      //  self.currentTitleString = [currentTitleString stringByAppendingString:string]; 
    //    aItem.title = currentTitleString; 
    //}
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [delegate feedParserDidFailParsingWithError:self]; 
    isParsing = NO; 
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [delegate feedParserDidFinishParsing:self]; 
    isParsing = NO; 
}

#pragma mark - Release
-(void)dealloc
{
    [urlConnection release]; 
    [asyncData release]; 
    [url release]; 
}


@end
