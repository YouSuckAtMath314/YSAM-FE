//
//  GamePlayer.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameAvatar.h"

@interface GamePlayer: NSObject {
    NSString *playerID;
    GameAvatar *avatar;
    int lifeRemaining;
}

@property (nonatomic, copy) NSString *playerID;
@property (nonatomic, retain) GameAvatar *avatar;
@property (nonatomic) int lifeRemaining;

- (void) loseRound;

@end

