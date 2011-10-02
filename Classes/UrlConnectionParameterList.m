//
//  UrlConnectionParameterList.m
//  YouSendIt
//
//  Created by Dwayne Mercredi on 4/7/11.
//  Copyright 2011. All rights reserved.
//

#import "URLConnectionParameterList.h"

////////////////////////////////////////////////////////////////////////////////////
// class UrlConnectionParameter
////////////////////////////////////////////////////////////////////////////////////

@interface UrlConnectionParameter : NSObject {
@private
    NSString *parameterName;
    NSString *parameterValue;
}

@property (nonatomic, copy) NSString *parameterName;
@property (nonatomic, copy) NSString *parameterValue;

@end

@implementation UrlConnectionParameter

@synthesize parameterName, parameterValue;

- (id) init {
    self = [super init];
    
    return self;
}

- (void) dealloc {
    self.parameterName = nil;
    self.parameterValue = nil;
    
    [super dealloc];
}

@end

////////////////////////////////////////////////////////////////////////////////////
// class UrlConnectionParameterList
////////////////////////////////////////////////////////////////////////////////////

@implementation URLConnectionParameterList

- (id) init {
    self = [super init];
    
    if (self) {
        parameters = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc {
    [parameters release];
    
    [super dealloc];
}

- (void) addParameter: (NSString *) parameterValue forName: (NSString *) name {
    UrlConnectionParameter *parameter = [[[UrlConnectionParameter alloc] init] autorelease];
    
    parameter.parameterName = name;
    parameter.parameterValue = parameterValue;
    
    [parameters addObject: parameter];    
}

- (NSString *) formPostEncoded {
	NSMutableString *formPostParams = [[[NSMutableString alloc] init] autorelease];

	for (int i = 0; i < [parameters count]; i++) {
        UrlConnectionParameter *parameter = [parameters objectAtIndex: i];
		NSString *encodedValue = [((NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) parameter.parameterValue, NULL, CFSTR("=/:"), kCFStringEncodingUTF8)) autorelease];
		
		[formPostParams appendString: parameter.parameterName];
		[formPostParams appendString: @"="];
		[formPostParams appendString: encodedValue];
		
		if (i < ([parameters count] - 1)) {
			[formPostParams appendString: @"&"];
		}
    }
	
	return formPostParams;
}

@end
