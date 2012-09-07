//
//  ValuationTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 07.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "ValuationTests.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Valuation.h"

@implementation ValuationTests

- (void)testValuationTop {
    NyayaNode *top = [NyayaNode top];
    STAssertEquals(top.evaluationValue, YES, nil);
}

- (void)testValuationBottom {
    NyayaNode *bottom = [NyayaNode bottom];
    STAssertEquals(bottom.evaluationValue, NO, nil);
}

- (void)testValuationA {
    NyayaNode *a = [NyayaNode nodeWithFormula:@"a"];
    ((NyayaNodeVariable*)a).evaluationValue = YES;
    STAssertEquals(a.evaluationValue, YES, @"%d",a.evaluationValue);
    ((NyayaNodeVariable*)a).evaluationValue = NO;
    STAssertEquals(a.evaluationValue, NO, @"%d",a.evaluationValue);
}

@end
