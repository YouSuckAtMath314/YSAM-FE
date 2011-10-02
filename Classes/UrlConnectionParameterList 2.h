//
//  UrlConnectionParameterList.h
//  YouSendIt
//
//  Created by Dwayne Mercredi on 4/7/11.
//  Copyright 2011 Invisible Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLConnectionParameterList : NSObject {
    NSMutableArray *parameters;
}

- (void) addParameter: (NSString *) parameter forName: (NSString *) name;
- (NSString *) formPostEncoded;

@end
