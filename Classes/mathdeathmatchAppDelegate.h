//
//  mathdeathmatchAppDelegate.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEPubnub.h"
#import "StartScreenViewController.h"

@class mathdeathmatchViewController;

@interface mathdeathmatchAppDelegate : NSObject <UIApplicationDelegate, CEPubnubDelegate> {
    UIWindow *window;
	StartScreenViewController *viewController;
	
	CEPubnub *pn;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

