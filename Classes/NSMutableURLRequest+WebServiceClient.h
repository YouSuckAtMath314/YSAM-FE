//
//  NSMutableURLRequest+WebServiceClient.h
//  Attassa
//
//  Created by Dwayne Mercredi on 1/12/09.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLConnectionParameterList.h"

@interface NSMutableURLRequest (WebServiceClient) 

- (void) setFormPostParameters:(URLConnectionParameterList *)parameters;
- (void) setHTTPBasicID: (NSString *) userID password: (NSString *) password;

@end
