#import "CalculatorController.h"
#include <math.h>

@implementation CalculatorController
+ (id)addNumber:		(NSNumber*)num1 with:(NSNumber*)num2 { return [NSNumber numberWithDouble:[num1 doubleValue] + [num2 doubleValue]]; }
+ (id)subtractNumber:	(NSNumber*)num1 with:(NSNumber*)num2 { return [NSNumber numberWithDouble:[num1 doubleValue] - [num2 doubleValue]]; }
+ (id)divideNumber:		(NSNumber*)num1 with:(NSNumber*)num2 { return ([num2 doubleValue] == 0.0) ? [NSNumber numberWithDouble:INFINITY] : [NSNumber numberWithDouble: [num1 doubleValue] / [num2 doubleValue]]; }
+ (id)multiplyNumber:	(NSNumber*)num1 with:(NSNumber*)num2 { return [NSNumber numberWithDouble:[num1 doubleValue] * [num2 doubleValue]]; }

/* these are just wrappers to make porting between UIKit <-> AppKit super duper easy peasy, literally 4 lines and we're off to the races */
+ (NSString*)getButtonString:(id)button { return [button titleForState:UIControlStateNormal]; }
- (NSString*)displayText { return [display text]; }
- (void)setDisplayText:(NSString*)string { [display setText:string]; }
- (void)updateDisplay:(double)number { [display setText:[[NSNumber numberWithDouble:number] stringValue]]; currentBuffer = number; }

- (id)init {
	if (self = [super init]) {
		operators = [[NSDictionary alloc] initWithObjectsAndKeys:
			[NSValue valueWithPointer:@selector(addNumber:with:)		], [NSString stringWithUTF8String:"+"],
			[NSValue valueWithPointer:@selector(subtractNumber:with:)	], [NSString stringWithUTF8String:"-"],
			[NSValue valueWithPointer:@selector(divideNumber:with:)		], [NSString stringWithUTF8String:"÷"], /* this one right here is why i did it to all the others (for consistencies sake), otherwise this one'd warn me on xcode 2.5 */
			[NSValue valueWithPointer:@selector(multiplyNumber:with:)	], [NSString stringWithUTF8String:"x"],
		nil];
		currentOperator = nil;
	}
	
	return self;
}

- (IBAction)invokeNumberButton:		(id)sender {
	NSString *value = [self displayText];
	if (wasLastButtonCalculation) { currentOperator = nil; priorBuffer = 0.0; }
	wasLastButtonCalculation = NO; 
	// if ([value length] >= 20 && !clearable) return; /* unneeded on UIKit devices (can shrink down text) */ 
	if (([value isEqualToString:@"0"]) || clearable) {priorBuffer = [[self displayText] doubleValue]; [self setDisplayText:(value = ([[[self class] getButtonString:sender] isEqualToString:@"."]) ? @"0." : @"")];}
	if ([[[self class] getButtonString:sender] isEqualToString:@"."] && [[value componentsSeparatedByString:@"."] count] > 1) return;
	clearable = NO;
	[self setDisplayText:[value stringByAppendingString:[[self class] getButtonString:sender]]];
	currentBuffer = [[self displayText] doubleValue];
}

- (IBAction)invokeOperatorButton:	(id)sender {
	if (!clearable && currentOperator != nil) [self performCalculation:sender]; 
	wasLastButtonCalculation = NO; clearable = YES; 
	priorBuffer = [[self displayText] doubleValue]; currentBuffer = priorBuffer;
	currentOperator = [[self class] getButtonString:sender];
}

- (IBAction)clearCalculation:		(id)sender {
	[self updateDisplay:(priorBuffer = 0.0)];
	currentOperator = nil; wasLastButtonCalculation = NO; clearable = NO;
}

- (IBAction)performCalculation:		(id)sender {
	double numberOne, numberTwo;
	if (currentOperator == nil) {clearable = YES; return;}
	if (wasLastButtonCalculation) { numberOne = currentBuffer; numberTwo = priorBuffer; }
	else { numberOne = priorBuffer; numberTwo = currentBuffer; priorBuffer = currentBuffer; }
	[self updateDisplay:[[[self class] performSelector:[[operators objectForKey:currentOperator] pointerValue] withObject:[NSNumber numberWithDouble:numberOne] withObject:[NSNumber numberWithDouble:numberTwo]] doubleValue]]; /* square bracket hell */
	clearable = YES; wasLastButtonCalculation = YES;
}

- (IBAction)flipSign:				(id)sender { [self updateDisplay:[[self displayText] doubleValue] * -1]; }
- (IBAction)memoryClear:			(id)sender { wasLastButtonCalculation = NO; memory = 0.0; }
- (IBAction)memoryAdd:				(id)sender { wasLastButtonCalculation = NO; memory += [[self displayText] doubleValue]; }
- (IBAction)memorySubtract:			(id)sender { wasLastButtonCalculation = NO; memory -= [[self displayText] doubleValue]; }
- (IBAction)memoryRecall:			(id)sender { wasLastButtonCalculation = NO; [self updateDisplay:memory]; clearable = YES; }

- (void)dealloc {
	[operators release];
	[super dealloc];
}
@end
