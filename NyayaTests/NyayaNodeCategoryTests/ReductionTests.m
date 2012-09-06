//
//  ReductionTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 06.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "ReductionTests.h"
#import "NyayaNode+Reductions.h"

@implementation ReductionTests

- (void)testReduceToBottom {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"F"];
    for (NSString *input in @[@"F", @"!T", @"a&!a", @"!a&a"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)testReduceToTop {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"T"];
    for (NSString *input in @[@"!F", @"T" , @"a|!a", @"!a|a"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)xtestReduceToA {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"a"];
    for (NSString *input in @[@"a", @"a|a", @"a&a", @"a&a|a" ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)testReduceBigXor {
    NyayaNode *formula = [NyayaNode formulaWithInput:@"a^b^c^d^f^g^h^i^j^k^l^m^n^o^p^q^r^s^t^u^v^w^x^y^z"];
    NSDate *begin = [NSDate date];
    
    NyayaNode *reducedFormula = formula.reducedFormula;
    
    NSDate *end = [NSDate date];
    
    STAssertEqualObjects(formula, reducedFormula, nil);
    STAssertTrue([end timeIntervalSinceDate:begin] < 0.001, nil);
    
}

- (void)testE1 {
    NyayaNode *n = [NyayaNode formulaWithInput:@"p∨¬q∨(¬p∨q)↔s"];
    NyayaNode *r = [n reduce];
    
    STAssertEqualObjects(n.truthTable, r.truthTable, nil);
}

@end
