//
//  GameServer.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GamePlayer.h"
#import "DataDownloader.h"


@interface GameServerRegistration : NSObject {
    DataDownloader *currentServerCall;
    
    GamePlayer *player;
    
    id<NSObject> delegate;
    SEL onComplete;
    SEL onError;
    
    BOOL pollingForMatch;
}

- (void) findOpponentForPlayer: (GamePlayer *) user;

@property (nonatomic, assign) id<NSObject> delegate;

// onComplete: (GamePlayer *) opponent gameID: (NSString *) gameID;
@property (nonatomic) SEL onComplete;

// onError: (NSError *) error;
@property (nonatomic) SEL onError;

@end
