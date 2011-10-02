    //
//  MathGameViewController.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathGameViewController.h"

@interface MathGameViewController ()

- (void) startAnotherRound;

- (void) updateUIToEquation;
- (MathEquation *) generateRandomEquation;

@end

@implementation MathGameViewController

@synthesize equationStartLabel, operatorLabel, equationEndLabel, currentEquation;

- (void) finishInitialization {
	NSURL *url = [[NSBundle mainBundle] URLForResource: @"matchtrack" withExtension: @"mp3"];
	backgroundTrack = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder: aDecoder];
	
	if (self) {
		[self finishInitialization];
	}
	
	return self;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self finishInitialization];
    }
    return self;
}

- (void)dealloc {
    self.equationEndLabel = nil;
    self.equationStartLabel = nil;
    self.operatorLabel = nil;
    self.currentEquation = nil;
    
	[backgroundTrack release];
	
    [super dealloc];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    self.currentEquation = [self generateRandomEquation];
    [self updateUIToEquation];

}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	
	[backgroundTrack play];
}

- (void) viewWillDisappear:(BOOL)animated {
	[backgroundTrack stop];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) startAnotherRound {

}

- (IBAction) addPressed {
    NSLog(@"Add Pressed");
    
    if (currentEquation.equationType == MathEquationTypeAddition) {
        // TODO: success!
        
        operatorLabel.textColor = [UIColor whiteColor];
    }
    else {
        // TODO: failure!

        operatorLabel.textColor = [UIColor redColor];
    }

    operatorLabel.hidden = NO;
}

- (IBAction) subtractPressed {
    NSLog(@"Subtract Pressed");

    if (currentEquation.equationType == MathEquationTypeSubtraction) {
        // TODO: success!
        operatorLabel.textColor = [UIColor whiteColor];
    }
    else {
        // TODO: failure!
        
        operatorLabel.textColor = [UIColor redColor];
    }

    operatorLabel.hidden = NO;
}

- (IBAction) dividePressed {
    NSLog(@"Divide Pressed");

    if (currentEquation.equationType == MathEquationTypeDivision) {
        // TODO: success!
        operatorLabel.textColor = [UIColor whiteColor];
    }
    else {
        // TODO: failure!
        
        operatorLabel.textColor = [UIColor redColor];
    }

    operatorLabel.hidden = NO;
}

- (IBAction) multiplyPressed {
    NSLog(@"Multiply Pressed");

    if (currentEquation.equationType == MathEquationTypeMultiplication) {
        // TODO: success!
        operatorLabel.textColor = [UIColor whiteColor];
    }
    else {
        // TODO: failure!
        
        operatorLabel.textColor = [UIColor redColor];
    }
    
    operatorLabel.hidden = NO;
}

- (IBAction) cancelGame {
    NSLog(@"Cancel");
    
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}

- (void) updateUIToEquation {
    if (!currentEquation) {
        equationStartLabel.hidden = YES;
        equationEndLabel.hidden = YES;
        operatorLabel.hidden = YES;
    }
    else {
        equationStartLabel.text = [NSString stringWithFormat: @"%d", currentEquation.firstTerm];
        equationEndLabel.text = [NSString stringWithFormat: @"%d = %d", currentEquation.secondTerm, currentEquation.equationResult];
        
        switch (currentEquation.equationType) {
            case MathEquationTypeAddition:
                operatorLabel.text = @"+";
                break;
            case MathEquationTypeSubtraction:
                operatorLabel.text = @"−";
                break;
            case MathEquationTypeDivision:
                operatorLabel.text = @"÷";
                break;
            case MathEquationTypeMultiplication:
            default:
                operatorLabel.text = @"×";
                break;
        }
            
        equationStartLabel.hidden = NO;
        equationEndLabel.hidden = NO;
    }
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

@end
