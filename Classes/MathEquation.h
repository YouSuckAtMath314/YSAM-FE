//
//  MathEquation.h
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MathEquationType {
    MathEquationTypeAddition,
    MathEquationTypeSubtraction,
    MathEquationTypeDivision,
    MathEquationTypeMultiplication,    
} MathEquationType;

@interface MathEquation : NSObject {
    MathEquationType equationType;
    int firstTerm;
    int secondTerm;
    int equationResult;
}

@property (nonatomic) int firstTerm;
@property (nonatomic) int secondTerm;
@property (nonatomic) int equationResult;
@property (nonatomic) MathEquationType equationType;

- (id) initWithEquationType: (MathEquationType) type firstTerm: (int) firstTerm secondTerm: (int) secondTerm result: (int) result;

+(MathEquation *) divisionWithDividend: (int) divident divisor: (int) divisor;
+(MathEquation *) multiplicationWithMultiplier: (int) firstTerm andMultiplier: (int) secondTerm;
+(MathEquation *) additionWithNumber: (int) number1 andNumber: (int) number2;
+(MathEquation *) subtractionWithNumber: (int) number1 andNumber: (int) number2;

@end
