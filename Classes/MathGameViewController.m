    //
//  MathGameViewController.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathGameViewController.h"


@implementation MathGameViewController

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


- (void)dealloc {
	[backgroundTrack release];
	
    [super dealloc];
}


@end
