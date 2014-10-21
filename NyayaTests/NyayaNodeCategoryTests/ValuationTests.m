//
//  ValuationTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 07.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "ValuationTests.h"
#import "SenTestCase+NyayaTests.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Valuation.h"
#import "NyayaFormula.h"

@implementation ValuationTests

- (void)testValuationTop {
    NyayaNode *top = [NyayaNode top];
    XCTAssertEqual(top.evaluationValue, YES);
}

- (void)testValuationBottom {
    NyayaNode *bottom = [NyayaNode bottom];
    XCTAssertEqual(bottom.evaluationValue, NO);
}

- (void)testValuationA {
    NyayaNode *a = [[NyayaFormula formulaWithString:@"a"] syntaxTree:NO];
    ((NyayaNodeVariable*)a).evaluationValue = YES;
    XCTAssertEqual(a.evaluationValue, YES, @"%d",a.evaluationValue);
    ((NyayaNodeVariable*)a).evaluationValue = NO;
    XCTAssertEqual(a.evaluationValue, NO, @"%d",a.evaluationValue);
}

@end
