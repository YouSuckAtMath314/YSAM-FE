//
//  MathGame.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CEPubnub.h"

#import "MathEquation.h"

#import "GamePlayer.h"
#import "GameServerRegistration.h"

typedef enum MathGameState {
    MathGameRegisteringForGame,
    MathGameWaitingForOpponent,
    MathGameWaitingForQuestion, // times out to "aborted"
    MathGamePromptingAnswer, // with timer
    MathGameWaitingForOpponentResponse, // times out to "aborted"
    MathGameNotifyingUserOfResult, // times out
    MathGameFinished, // transitions to finish
    MathGameAborted
} MathGameState;

@protocol MathGameDelegate

- (void) onWaitingForOpponent;
- (void) onOpponentAvailable: (GamePlayer *) opponent;
- (void) onWaitingForQuestion;
- (void) onAskQuestion: (MathEquation *) equation;
- (void) onUserResponseTime: (NSTimeInterval) time Succeeded: (BOOL) succeeded timedOut: (BOOL) timedOut;
- (void) onOpponentResponseTime: (NSTimeInterval) time succeeded: (BOOL) succeeded timedOut: (BOOL) timedOut;

- (void) onOpponentNotResponding;
- (void) onError: (NSError *) error;

- (void) onFinishGame;

@end

@interface MathGame : NSObject <CEPubnubDelegate> {
    GameServerRegistration *gameRegistration;
    CEPubnub *pubnubConnection;
    
    MathEquation *currentQuestion;
    GamePlayer *player;
    GamePlayer *opponent;
    NSString *gameID;
    
    MathGameState gameState;
    BOOL listeningForQuestions;
    BOOL listeningForAnswers;
    
    NSTimer *responseTimeoutTimer;
}

- (id) initWithPlayerAvatar: (GameAvatar *) avatar;

- (void) startGame;

- (void) postAnswerWithTime: (NSTimeInterval) time succeeded: (BOOL) succeeded timedOut: (BOOL) timedOut;

- (void) cancelGame;

@property (nonatomic, assign) id<MathGameDelegate> delegate;

@property (nonatomic, retain) MathEquation *currentQuestion;
@property (nonatomic, retain) GamePlayer *player;
@property (nonatomic, copy) NSString *gameID;
@property (nonatomic, retain) GamePlayer *opponent;

@property (readonly) MathGameState gameState;

@end
