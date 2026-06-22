//
//  UntitledIpodAppDelegate.m
//  UntitledIpod
//
//  Created by Xander Gomez on 6/21/26.
//  Copyright __MyCompanyName__ 2026. All rights reserved.
//

#import "UntitledIpodAppDelegate.h"
#import "UntitledIpodViewController.h"

@implementation UntitledIpodAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
