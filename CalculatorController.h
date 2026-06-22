#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CalculatorController : NSObject {
	IBOutlet UITextField* display;
	NSDictionary *operators;
	double memory;
	NSString* currentOperator;
	double currentBuffer, priorBuffer;
	BOOL clearable;
	BOOL wasLastButtonCalculation;
}

+ (id)addNumber:		(NSNumber*)num1 with:(NSNumber*)num2;
+ (id)subtractNumber:	(NSNumber*)num1 with:(NSNumber*)num2;
+ (id)divideNumber:		(NSNumber*)num1 with:(NSNumber*)num2;
+ (id)multiplyNumber:	(NSNumber*)num1 with:(NSNumber*)num2;

- (IBAction)invokeNumberButton:		(id)sender;
- (IBAction)invokeOperatorButton:	(id)sender;

- (IBAction)clearCalculation:		(id)sender;

- (IBAction)performCalculation:		(id)sender;

- (IBAction)flipSign:				(id)sender;

- (IBAction)memoryClear:			(id)sender;
- (IBAction)memoryAdd:				(id)sender;
- (IBAction)memorySubtract:			(id)sender;
- (IBAction)memoryRecall:			(id)sender;
@end
