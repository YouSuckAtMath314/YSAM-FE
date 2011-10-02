//
//  GamePlayer.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GamePlayer.h"

@implementation GamePlayer

@synthesize playerID, avatar, lifeRemaining;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc {
    self.avatar = nil;
    
    [super dealloc];
}

- (void) loseRound {
    lifeRemaining--;
    
    if (lifeRemaining < 0) {
        lifeRemaining = 0;
    }
}

- (NSString *) description {
    return [NSString stringWithFormat: @"GamePlayer avatar [%@] playerID %@ lifeRemaining %d", avatar, playerID, lifeRemaining];
}

@end
