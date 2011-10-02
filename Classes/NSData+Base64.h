//
//  NSData+Encodings.h
//  Attassa
//
//  Created by Dwayne Mercredi on 1/12/09.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Base64)
	+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
	- (id) initWithBase64EncodedString:(NSString *) string;
    
	- (NSString *) base64Encoding;
	- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;
@end
