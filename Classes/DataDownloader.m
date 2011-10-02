//
//  DataFetcher.m
//  memelogin
//
//  Created by Dwayne Mercredi on 12/27/10.
//  Copyright 2010. All rights reserved.
//

#import "DataDownloader.h"

@implementation DataDownloader

@synthesize responseData, request, response, applicationData;

- (id)init {
	[super init];
	responseData = [[NSMutableData alloc] init];
	
	return self;
}

- (void)dealloc {
	[applicationData release];
	[connection release];
	[response release];
	[responseData release];
	[request release];
	
	[super dealloc];
}

- (void) cancel {
	delegate = nil;
	didFinishSelector = NULL;
	didFailSelector = NULL;
	
	if (!complete) {
		[connection cancel];
	}
}

/* Protocol for async URL loading */
- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse {
	[response release];
	response = [aResponse retain];
	
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
	complete = YES;
	
	[delegate performSelector:didFailSelector withObject:self withObject:error];
	
	delegate = nil;
	didFinishSelector = NULL;
	didFailSelector = NULL;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	complete = YES;
	
	[delegate performSelector:didFinishSelector withObject:self];

	delegate = nil;
	didFinishSelector = NULL;
	didFailSelector = NULL;
}

- (void)downloadDataWithRequest:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector {
	[request release];
	request = [aRequest retain];
    delegate = aDelegate;
    didFinishSelector = finishSelector;
    didFailSelector = failSelector;
	
	connection = [[NSURLConnection alloc] initWithRequest: aRequest delegate: self startImmediately: YES];
}


@end
