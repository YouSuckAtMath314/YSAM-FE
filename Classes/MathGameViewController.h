//
//  MathGameViewController.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import "MathEquation.h"

@interface MathGameViewController : UIViewController {
	AVAudioPlayer *backgroundTrack;
    
    MathEquation *currentEquation;
    
    UILabel *equationStartLabel;
    UILabel *operatorLabel;
    UILabel *equationEndLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *equationStartLabel;
@property (nonatomic, retain) IBOutlet UILabel *operatorLabel;
@property (nonatomic, retain) IBOutlet UILabel *equationEndLabel;
@property (nonatomic, retain) MathEquation *currentEquation;

- (IBAction) addPressed;
- (IBAction) subtractPressed;
- (IBAction) dividePressed;
- (IBAction) multiplyPressed;

- (IBAction) cancelGame;

@end
