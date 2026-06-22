//
//  UntitledIpodAppDelegate.h
//  UntitledIpod
//
//  Created by Xander Gomez on 6/21/26.
//  Copyright __MyCompanyName__ 2026. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UntitledIpodViewController;

@interface UntitledIpodAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UntitledIpodViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UntitledIpodViewController *viewController;

@end

