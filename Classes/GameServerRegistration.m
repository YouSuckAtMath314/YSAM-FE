//
//  GameServerRegistration.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameServerRegistration.h"
#import "UrlConnectionParameterList.h"
#import "NSMutableURLRequest+WebServiceClient.h"
#import "SBJsonParser.h"

@implementation GameServerRegistration

@synthesize delegate, onComplete, onError;

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void) dealloc {
    [player release];
    [currentServerCall cancel];
    [currentServerCall release];
    
    self.delegate = nil;
    
    [super dealloc];
}

- (void) findOpponentForPlayer: (GamePlayer *) user {
    player = [user retain];
    
    currentServerCall = [[DataDownloader alloc] init];
    
    NSString *joinURL = [NSString stringWithFormat: @"http://deathmath.heroku.com/match/join/%@", player.playerID];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: joinURL]] autorelease];
    
    URLConnectionParameterList *parameterList = [[[URLConnectionParameterList alloc] init] autorelease];

    if (player.avatar.avatarID) {
        [parameterList addParameter: player.avatar.avatarID forName: @"avatarID"];
    }

    [request setHTTPMethod: @"POST"];
    [request setFormPostParameters: parameterList];
    
    [currentServerCall downloadDataWithRequest: request delegate: self didFinishSelector: @selector(onDownloadComplete:) didFailSelector: @selector(onDownloadFailed:error:)];
}

- (void) reportError: (NSError *) error {
    if (delegate && onError) {
        [delegate performSelector: onError withObject: error];
    }
    
}

- (void) onDownloadFailed: (DataDownloader *) downloader error: (NSError *) error {
    [self reportError: error];
}

- (void) onDownloadComplete: (DataDownloader *) downloader {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) downloader.response;

    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
        bool pollAgain = YES;
        
        [currentServerCall cancel];
        [currentServerCall autorelease];
        currentServerCall = nil;
        
        if (pollingForMatch) {
            SBJsonParser *parser = [SBJsonParser new];

            id jsonResponse = [parser objectWithData: downloader.responseData];
            
            if (![jsonResponse isKindOfClass: [NSDictionary class]]) {
                [self reportError: [NSError errorWithDomain: @"BadResponse" code:-1 userInfo:nil]];
            }
            else {
                NSDictionary *result = jsonResponse;
                
                if ([[result objectForKey: @"matched"] boolValue]) {
                    pollAgain = NO;
                    
                    NSString *opponentID = [result objectForKey: @"opponent_id"];
                    NSString *gameID = [result objectForKey: @"guid"];
                    NSString *avatarID = [[result objectForKey: @"opponent"] objectForKey: @"avatarID"];

                    NSLog(@"have data %@ opponentID %@, gameID %@, avatarID %@", result, opponentID, gameID, avatarID);

                    GameAvatar *avatar = nil;
                    if (avatarID && [avatarID length] > 0) {
                        avatar = [GameAvatar avatarWithID: avatarID];
                    }
                                        
                    GamePlayer *opponent = [[[GamePlayer alloc] init] autorelease];
                    
                    opponent.playerID = opponentID;
                    opponent.avatar = avatar;
                    
                    if (delegate && onComplete) {
                        [delegate performSelector: onComplete withObject: opponent withObject: gameID];
                    }
                }
                
            }
            
            NSString *json = [[[NSString alloc] initWithData: downloader.responseData encoding:NSUTF8StringEncoding] autorelease];
            
            NSLog(@"%@", json);
        }
        else {
            pollingForMatch = YES;
        }    
        
        if (pollAgain) {
            NSString *pollURL = [NSString stringWithFormat: @"http://deathmath.heroku.com/match/status/%@", player.playerID];
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: pollURL]] autorelease];
            
            currentServerCall = [[DataDownloader alloc] init];
            [currentServerCall downloadDataWithRequest: request delegate: self didFinishSelector: @selector(onDownloadComplete:) didFailSelector: @selector(onDownloadFailed:error:)];            
        }
    }
    else {
        [self reportError: [NSError errorWithDomain: @"HTTP" code: httpResponse.statusCode userInfo: nil]];
    }
}

@end
