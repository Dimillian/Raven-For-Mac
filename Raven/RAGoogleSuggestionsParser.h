//
//  RAGoogleSuggestionsParser.h
//  Raven
//
//  Created by Thomas Ricouard on 07/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RAGoogleSuggestionDelegate;
@interface RAGoogleSuggestionsParser : NSObject <NSXMLParserDelegate>
{
    
    id<RAGoogleSuggestionDelegate> delegate;
    NSURLConnection *urlConnection;
	NSMutableData *asyncData;
	NSString *asyncTextEncodingName;
    NSURL *url; 
    NSString *currentSuggestionString;

	NSXMLParser *feedParser; 
    NSString *currentElement; 
    BOOL isParsing; 

}
-(id)initWithUrl:(NSURL *)feedUrl; 
-(void)startParsingWithData:(NSData *)data; 
-(void)parse; 
-(void)reset; 
@property (nonatomic, assign) id<RAGoogleSuggestionDelegate>delegate;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSMutableData *asyncData;
@property (nonatomic, retain) NSXMLParser *feedParser;
@property (nonatomic, copy) NSString *currentElement; 
@property (nonatomic, copy) NSString *currentSuggestionString; 

@end

@protocol RAGoogleSuggestionDelegate 
@optional
-(void)feedParserDidStartParsing:(RAGoogleSuggestionsParser *)parser; 
-(void)feedParserDidParseAnItem:(NSString *)item; 
-(void)feedParserDidFinishParsing:(RAGoogleSuggestionsParser *)parser; 
-(void)feedParserDidFailParsingWithError:(RAGoogleSuggestionsParser *)parser; 
@end

