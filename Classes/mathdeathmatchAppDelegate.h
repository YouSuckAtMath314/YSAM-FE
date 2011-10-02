//
//  mathdeathmatchAppDelegate.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mathdeathmatchViewController;

@interface mathdeathmatchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

