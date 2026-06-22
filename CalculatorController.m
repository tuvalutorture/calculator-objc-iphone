//
//  CalculatorController.m
//  shittyCalculator
//
//  Created by Xander Gomez on 20/06/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "CalculatorController.h"
#include <math.h>

@implementation CalculatorController
+ (id)addNumber:		(NSNumber*)num1 with:(NSNumber*)num2 { return [NSNumber numberWithDouble:[num1 doubleValue] + [num2 doubleValue]]; }
+ (id)subtractNumber:	(NSNumber*)num1 with:(NSNumber*)num2 { return [NSNumber numberWithDouble:[num1 doubleValue] - [num2 doubleValue]]; }
+ (id)divideNumber:		(NSNumber*)num1 with:(NSNumber*)num2 { return ([num2 doubleValue] == 0.0) ? [NSNumber numberWithDouble:INFINITY] : [NSNumber numberWithDouble: [num1 doubleValue] / [num2 doubleValue]]; }
+ (id)multiplyNumber:	(NSNumber*)num1 with:(NSNumber*)num2 { return [NSNumber numberWithDouble:[num1 doubleValue] * [num2 doubleValue]]; }

- (id)init {
	if (self = [super init]) {
		operators = [[NSDictionary alloc] initWithObjectsAndKeys:
			[NSValue valueWithPointer:@selector(addNumber:with:)		], [NSString stringWithUTF8String:"+"],
			[NSValue valueWithPointer:@selector(subtractNumber:with:)	], [NSString stringWithUTF8String:"-"],
			[NSValue valueWithPointer:@selector(divideNumber:with:)		], [NSString stringWithUTF8String:"÷"],
			[NSValue valueWithPointer:@selector(multiplyNumber:with:)	], [NSString stringWithUTF8String:"x"],
		nil];
		currentOperator = nil;
	}
	
	return self;
}

- (IBAction)invokeNumberButton:		(id)sender {
	NSString *value = [display text];
	if (wasLastButtonCalculation) { currentOperator = nil; priorBuffer = 0.0; }
	wasLastButtonCalculation = NO; 
	if ([value length] >= 18 && !clearable) return;
	if (([value isEqualToString:@"0"]) || clearable) {priorBuffer = [[display text] doubleValue]; [display setText:(value = ([[sender titleForState:UIControlStateNormal] isEqualToString:@"."]) ? @"0." : @"")];}
	if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"."] && [[value componentsSeparatedByString:@"."] count] > 1) return;
	clearable = NO;
	[display setText:[value stringByAppendingString:[sender titleForState:UIControlStateNormal]]];
	currentBuffer = [[display text] doubleValue];
}

- (IBAction)invokeOperatorButton:	(id)sender {
	if (!clearable && currentOperator != nil) [self performCalculation:sender]; 
	wasLastButtonCalculation = NO;
	clearable = YES; priorBuffer = [[display text] doubleValue];
	currentBuffer = priorBuffer;
	currentOperator = [sender titleForState:UIControlStateNormal];
}

- (IBAction)clearCalculation:		(id)sender {
	wasLastButtonCalculation = NO;
	currentBuffer = 0.0; priorBuffer = 0.0;
	[display setText:@"0"];
	currentOperator = nil; clearable = NO;
}

- (IBAction)performCalculation:		(id)sender {
	double numberOne, numberTwo, result;
	if (currentOperator == nil) {clearable = YES; return;}
	if (wasLastButtonCalculation) { numberOne = currentBuffer; numberTwo = priorBuffer; }
	else { numberOne = priorBuffer; numberTwo = currentBuffer; }
	SEL operation = [[operators objectForKey:currentOperator] pointerValue];
	result = [[[self class] performSelector:operation withObject:[NSNumber numberWithDouble:numberOne] withObject:[NSNumber numberWithDouble:numberTwo]] doubleValue];
	if (!wasLastButtonCalculation) priorBuffer = currentBuffer;
	currentBuffer = result;
	[display setText:[[NSNumber numberWithDouble:currentBuffer] stringValue]];
	clearable = YES; wasLastButtonCalculation = YES;
}

- (IBAction)flipSign:				(id)sender { [display setText:[[NSNumber numberWithDouble:[[display text] doubleValue] * -1] stringValue]]; }
- (IBAction)memoryClear:			(id)sender { wasLastButtonCalculation = NO; memory = 0.0; }
- (IBAction)memoryAdd:				(id)sender { wasLastButtonCalculation = NO; memory += [[display text] doubleValue]; }
- (IBAction)memorySubtract:			(id)sender { wasLastButtonCalculation = NO; memory -= [[display text] doubleValue]; }
- (IBAction)memoryRecall:			(id)sender { wasLastButtonCalculation = NO; [display setText:[[NSNumber numberWithDouble:memory] stringValue]]; clearable = YES; }

- (void)dealloc {
	[operators release];
	[super dealloc];
}
@end
