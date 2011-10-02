//
//  EmbeddedBrowserAppViewController.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmbeddedBrowserAppViewController : UIViewController {
    UIWebView *webView;
    
    NSURL *initialURL;
}

@property (nonatomic, retain) NSURL *initialURL;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
