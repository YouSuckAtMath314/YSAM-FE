//
//  NSMutableURLRequest+WebServiceClient.m
//  Attassa
//
//  Created by Dwayne Mercredi on 1/12/09.
//  Copyright 2009. All rights reserved.
//

#import "NSMutableURLRequest+WebServiceClient.h"
#import "NSData+Base64.h"

@implementation NSMutableURLRequest (WebServiceClient)

- (void) setFormPostParameters:(URLConnectionParameterList *)parameters {
	NSString *formPostParams = [parameters formPostEncoded];
	
	[self setHTTPBody: [formPostParams dataUsingEncoding: NSUTF8StringEncoding]];
	[self setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
}

- (void) setHTTPBasicID: (NSString *) userID password: (NSString *) password {
	NSString *combinedIDPassword = [NSString stringWithFormat: @"%@:%@", userID, password];
	
	NSString *credentialLine = [NSString stringWithFormat: @"Basic %@", [[combinedIDPassword dataUsingEncoding:NSUTF8StringEncoding] base64Encoding]];
	
	[self setValue: credentialLine forHTTPHeaderField: @"Authorization"];
}

@end
