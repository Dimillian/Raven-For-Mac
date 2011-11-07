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
    NSURL *URLToParse;
    NSMutableArray *suggestionResults; 
    NSMutableData *receivedData;

}
-(id)initWithDelegate:(id<RAGoogleSuggestionDelegate>)dgate;;
-(void)startParsing; 
-(NSMutableArray *)returnSuggestions; 
@property (nonatomic, assign) id<RAGoogleSuggestionDelegate>delegate;
@property (retain) NSURL *URLToParse; 
@end
@protocol RAGoogleSuggestionDelegate
@optional
-(void)didFinishParsing:(RAGoogleSuggestionsParser *)parser;
@end

