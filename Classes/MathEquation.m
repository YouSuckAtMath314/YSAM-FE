//
//  MathEquation.m
//  mathdeathmatch
//
//  Created by Dwayne Mercredi on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathEquation.h"

@implementation MathEquation

@synthesize firstTerm, secondTerm, equationType, equationResult;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithEquationType: (MathEquationType) type firstTerm: (int) term1 secondTerm: (int) term2 result: (int) result {
    self = [super init];
    
    if (self) {
        self.firstTerm = term1;
        self.secondTerm = term2;
        self.equationType = type;
        self.equationResult = result;
    }
    
    return self;
}

+(MathEquation *) divisionWithDividend: (int) dividend divisor: (int) divisor {
    return [[[MathEquation alloc] initWithEquationType: MathEquationTypeDivision firstTerm: dividend secondTerm: divisor result: dividend / divisor] autorelease];
}

+(MathEquation *) multiplicationWithMultiplier: (int) firstTerm andMultiplier: (int) secondTerm {
    return [[[MathEquation alloc] initWithEquationType: MathEquationTypeMultiplication firstTerm: firstTerm secondTerm: secondTerm result: firstTerm * secondTerm] autorelease];
}

+(MathEquation *) additionWithNumber: (int) number1 andNumber: (int) number2 {
    return [[[MathEquation alloc] initWithEquationType: MathEquationTypeAddition firstTerm: number1 secondTerm: number2 result: number1 + number2] autorelease];
}

+(MathEquation *) subtractionWithNumber: (int) number1 andNumber: (int) number2 {
    return [[[MathEquation alloc] initWithEquationType: MathEquationTypeSubtraction firstTerm: number1 secondTerm: number2 result: number1 - number2] autorelease];    
}

@end
