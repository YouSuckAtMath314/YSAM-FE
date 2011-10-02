//
//  GameAvatar.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameAvatar.h"

@implementation GameAvatar

@synthesize avatar, name, avatarID;

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
    self.name = nil;
    self.avatarID = nil;
    
    [super dealloc];
}

+ (GameAvatar *) avatarWithID: (NSString *) avatarID {
    GameAvatar *avatar = [[[GameAvatar alloc] init] autorelease];
    
    avatar.avatarID = avatarID;
    avatar.name = @"Einstein";
    
    return avatar;
}

- (NSString *) description {
    return name;
}

@end
