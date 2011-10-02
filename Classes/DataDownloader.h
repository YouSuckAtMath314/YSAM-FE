//
//  DataFetcher.h
//
//  Created by Dwayne Mercredi on 12/27/10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDownloader : NSObject {
@private
    NSMutableURLRequest *request;
    NSURLResponse *response;
    NSURLConnection *connection;
    NSMutableData *responseData;
    id delegate;
    SEL didFinishSelector;
    SEL didFailSelector;
	id applicationData;
	
	BOOL complete;
}

- (void)downloadDataWithRequest:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector;

@property (nonatomic, readonly) NSData *responseData;
@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) NSURLResponse *response;

//
//
//
@property (nonatomic, retain) id applicationData;

- (void) cancel;

@end
