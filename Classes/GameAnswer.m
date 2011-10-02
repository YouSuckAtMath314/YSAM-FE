//
//  GameAnswer.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameAnswer.h"

@implementation GameAnswer

@synthesize playerID, timeInterval, succeeded, timedOut;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc {
    [playerID release];
    
    [super dealloc];
}
@end
