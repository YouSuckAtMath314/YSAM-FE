//
//  GameAnswer.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameAnswer : NSObject {
    NSString *playerID;
    
    NSTimeInterval timeInterval;
    BOOL succeeded;
    BOOL timedOut;
}

@property (nonatomic, copy) NSString *playerID;
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) BOOL succeeded;
@property (nonatomic) BOOL timedOut;

@end
