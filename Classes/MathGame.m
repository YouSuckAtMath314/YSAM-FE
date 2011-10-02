//
//  MathGame.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathGame.h"
#import "GameAnswer.h"

#define DEFAULT_PLAYER_LIFE 10

@interface MathGame() 

- (MathEquation *) generateRandomEquation;
- (NSDictionary *) dictionaryForMathEquation: (MathEquation *) equation;
- (MathEquation *) matchEquationForDictionary: (NSDictionary *) dictionary;

@end

@implementation MathGame

@synthesize delegate, currentQuestion, player, opponent, gameState, gameID;

- (id) initWithPlayerAvatar: (GameAvatar *) avatar {
    self = [super init];
    
    if (self) {
        GamePlayer *currentPlayer = [[[GamePlayer alloc] init] autorelease];
        
        currentPlayer.playerID = [[UIDevice currentDevice] uniqueIdentifier];
        currentPlayer.avatar = avatar;
        currentPlayer.lifeRemaining = DEFAULT_PLAYER_LIFE;
        
        self.player = currentPlayer;
        
        pubnubConnection = [[CEPubnub alloc] initWithPublishKey: @"demo" subscribeKey: @"demo" secretKey: nil sslOn: NO origin: @"pubsub.pubnub.com"];    
    }
    
    return self;
}

- (void) dealloc {
    self.gameID = nil;
    self.delegate = nil;
    self.currentQuestion = nil;
    self.player = nil;
    self.opponent = nil;
    
    [responseTimeoutTimer release];
    
    [gameRegistration release];
    
    [pubnubConnection shutdown];
    [pubnubConnection release];
    
    [super dealloc];
}

- (NSString *) channelNameForPlayer: (GamePlayer *) p{
    return [NSString stringWithFormat: @"mathmax.%@", p.playerID];
}

- (NSString *) channelNameForQuestions {
    return [NSString stringWithFormat: @"mathmax.q.%@", gameID];
    
}

- (NSString *) channelNameForAnswers {
    return [NSString stringWithFormat: @"mathmax.a.%@", gameID];    
}

- (void) registrationComplete: (GamePlayer *) otherPlayer withGameID: (NSString *) game {
    otherPlayer.lifeRemaining = DEFAULT_PLAYER_LIFE;
    
    self.opponent = otherPlayer;
    self.gameID = game;
    
    NSLog(@"Have gameID %@ for opponent %@", gameID, opponent);
    
    [pubnubConnection subscribe: [self channelNameForQuestions] delegate: self];
    [pubnubConnection subscribe: [self channelNameForAnswers] delegate: self];
}

- (void) registrationError: (NSError *) error {
    NSLog(@"Registartion error %@", error);
}


- (void) startGame {
    gameState = MathGameRegisteringForGame;
    
    //
    // First, subscribe to a channel to reliably receive connection events from the opponent.
    //
    // wait for a notification that we're listening for events in pubnub:subscriptionDidStartListeningOnChannel:
    // before attempting to connect.
    //
    [pubnubConnection subscribe: [self channelNameForPlayer: player] delegate: self];
    
    
    /*
     //// waiting for opponent
     
     // join
     // poll for partner
     
     // (get back id of other player, and the game room ID)
     
     // send "start" message to other player's ID
     
     
     // "<nemesisID>", {"gameOwner": "<ownerid>" }
     
     // on receive start, if the game owner:
     
     //// asking question
     
     // generate question
     // send question to game room
     
     // "<gameid>.q" { "questionID" : "guid", "type" : <type>, "firstNumber": first, "secondNumber": second }
     
     // on response, give feedback and send response to response room
     
     // "<gameid>.r" { "questionID": "guid", "playerID": <id>, "time": timeInMilliseconds, "success": true }
     
     // on other response, if not sent, abort <fail>
     
     // on BOTH responses, give feedback
     

     
     */

}

- (void) cancelGame {
    // TODO!
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidStartListeningOnChannel:(NSString *)channel {
    if ([channel isEqualToString: [self channelNameForPlayer: player]]) {
        //
        // Now that we're listening, register for an opponent
        //
        gameRegistration = [[GameServerRegistration alloc] init];
        gameRegistration.delegate = self;
        gameRegistration.onComplete = @selector(registrationComplete:withGameID:);
        gameRegistration.onError = @selector(registrationError:);
        
        [gameRegistration findOpponentForPlayer: player];
    }
    else if ([channel isEqualToString: [self channelNameForQuestions]]) {
        listeningForQuestions = YES;
    }
    else if ([channel isEqualToString: [self channelNameForAnswers]]) {
        listeningForAnswers = YES;
    }
    
    if (listeningForQuestions && listeningForAnswers && MathGameRegisteringForGame == gameState) {
        //
        // Now that we're listening to the game channel, ping the opponent to start!
        //
        NSDictionary *readyMessage = [NSDictionary dictionaryWithObject: player.playerID forKey: @"opponentReady"];
        [pubnubConnection publish: [self channelNameForPlayer: opponent] message: readyMessage delegate: self];

        gameState = MathGameWaitingForOpponent;
        
        if (delegate) {
            [delegate onWaitingForOpponent];
        }
    }
}

- (BOOL) isQuestionPublisher {
    return [player.playerID compare: opponent.playerID] < 0;
}

- (void) publishQuestion {
    if ([self isQuestionPublisher]) {
        [pubnubConnection 
            publish: [self channelNameForQuestions] 
            message: [self dictionaryForMathEquation: [self generateRandomEquation]] 
            delegate: self];
    }
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidReceiveDictionary:(NSDictionary *)response onChannel:(NSString *)channel {
    if ([channel isEqualToString: [self channelNameForPlayer: player]]) {
        if ([[response objectForKey: @"opponentReady"] isEqualToString: opponent.playerID]) {
            gameState = MathGameWaitingForQuestion;
            
            if (delegate) {
                [delegate onWaitingForQuestion];
            }

            [self publishQuestion];
        }
    }
    else if ([channel isEqualToString: [self channelNameForQuestions]]) {
        MathEquation *equation = [self matchEquationForDictionary: response];
        
        gameState = MathGamePromptingAnswer;
        
        if (delegate) {
            [delegate onAskQuestion: equation];
        }
    }
    else if ([channel isEqualToString: [self channelNameForAnswers]]) {
        // process the answers
    }
}

- (void) postAnswerWithTime: (NSTimeInterval) time succeeded: (BOOL) succeeded timedOut: (BOOL) timedOut {
    // TODO
    //
    //
}

- (MathEquation *) generateRandomEquation {
    MathEquationType type = (MathEquationType) arc4random() % 4;
    
    int multiplyNumber1 = (arc4random() % 12) + 1;
    int multiplyNumber2 = (arc4random() % 12) + 1;
    
    int additionNumber1 = (arc4random() % 50) + 1;
    int additionNumber2 = (arc4random() % 50) + 1;
    
    switch (type) {
        case MathEquationTypeAddition:
            return [MathEquation additionWithNumber: additionNumber1 andNumber: additionNumber2];
            break;
        case MathEquationTypeSubtraction:
            return [MathEquation subtractionWithNumber: (additionNumber1 + additionNumber2) andNumber: additionNumber1];
            break;
        case MathEquationTypeDivision:
            return [MathEquation divisionWithDividend: (multiplyNumber1 * multiplyNumber2) divisor: multiplyNumber1];
            break;
        case MathEquationTypeMultiplication:
        default:
            return [MathEquation multiplicationWithMultiplier: multiplyNumber1 andMultiplier: multiplyNumber2];
            break;
    }
}

- (NSDictionary *) dictionaryForGameAnswer: (GameAnswer *) answer {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue: answer.playerID forKey: @"playerID"];
    [dictionary setValue: [NSNumber numberWithDouble: answer.timeInterval] forKey: @"timeInterval"];
    [dictionary setValue: [NSNumber numberWithBool: answer.succeeded] forKey: @"succeeded"];
    [dictionary setValue: [NSNumber numberWithBool: answer.timedOut] forKey: @"timedOut"];
    
    return dictionary;
}

- (GameAnswer *) gameAnswerForDictionary: (NSDictionary *) dictionary {
    GameAnswer *answer = [[[GameAnswer alloc] init] autorelease];
    
    answer.playerID = [dictionary objectForKey: @"playerID"];
    answer.timeInterval = [[dictionary objectForKey: @"timeInterval"] doubleValue];
    answer.succeeded = [[dictionary objectForKey: @"succeeded"] boolValue];
    answer.timedOut = [[dictionary objectForKey: @"timedOut"] boolValue];
    
    return answer;
}

- (NSDictionary *) dictionaryForMathEquation: (MathEquation *) equation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue: [NSNumber numberWithInt: equation.firstTerm] forKey: @"firstTerm"];
    [dictionary setValue: [NSNumber numberWithInt: equation.secondTerm] forKey: @"secondTerm"];
    [dictionary setValue: [NSNumber numberWithInt: equation.equationResult] forKey: @"equationResult"];
    [dictionary setValue: [NSNumber numberWithInt: equation.equationType] forKey: @"equationType"];
    
    return dictionary;
}

- (MathEquation *) matchEquationForDictionary: (NSDictionary *) dictionary {
    MathEquation *equation = [[[MathEquation alloc] init] autorelease];
    
    equation.firstTerm = [[dictionary objectForKey: @"firstTerm"] intValue];
    equation.secondTerm = [[dictionary objectForKey: @"secondTerm"] intValue];
    equation.equationResult = [[dictionary objectForKey: @"equationResult"] intValue];
    equation.equationType = [[dictionary objectForKey: @"equationType"] intValue];
    
    return equation;
}

- (void)pubnub:(CEPubnub *)pubnub subscriptionDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel {
	NSLog(@"FAILURE sub on channel: %@ - received: %@", channel, response);
    
    if (delegate) {
        [delegate onError: [NSError errorWithDomain: @"error" code:-1 userInfo:nil]];
    }
}

- (void)pubnub:(CEPubnub *)pubnub publishDidFailWithResponse:(NSString *)response onChannel:(NSString *)channel {
	NSLog(@"FAILURE publish on channel: %@ - received: %@", channel, response);
    
    if (delegate) {
        [delegate onError: [NSError errorWithDomain: @"error" code:-1 userInfo:nil]];
    }
}

@end
