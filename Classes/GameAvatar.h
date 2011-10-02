//
//  GameAvatar.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface GameAvatar : NSObject {
    UIImage *avatar;
    NSString *name;
    NSString *avatarID;
}

@property (nonatomic, retain) UIImage *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatarID;

+ (GameAvatar *) avatarWithID: (NSString *) avatarID;

@end
