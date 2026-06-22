//
//  UntitledIpodViewController.h
//  UntitledIpod
//
//  Created by Xander Gomez on 6/21/26.
//  Copyright __MyCompanyName__ 2026. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorController.h"

@interface UntitledIpodViewController : UIViewController {
	IBOutlet CalculatorController *myCalculator;
}

@property (nonatomic, retain) CalculatorController *myCalculator;
@end

