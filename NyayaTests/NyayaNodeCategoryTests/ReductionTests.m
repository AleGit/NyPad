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
    for (NSString *input in @[@"F", @"!T", @"T&F", @"F&T", @"F|F", @"!T&!T"
         , @"a&!a", @"!a&a", @"a&b&c&d&e&!a", @"a^a", @"a^a^a^a", @"a^a^a^a^a^a", @"T^T", @"F^F"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)testReduceToTop {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"T"];
    for (NSString *input in @[@"!F", @"T", @"F|T", @"!F|!T", @"T|T" , @"T&T", @"!F&!F"
         , @"a|!a", @"!a|a", @"a|b|c|d|e|!a"
         //, @"F^T", @"T^F", @"a>a", @"a>a>a", @"a=a"
         //, @"(F|T)&(!F|!T)"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)testReduceToA {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"a"];
    for (NSString *input in @[@"a", @"a|a", @"a&a", @"a|a|a", @"a&a|a", @"a^a^a", @"a^a^a^a^a", @"(a>a)>a", @"a|a&a"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)testReduceToNotA {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"!a"];
    for (NSString *input in @[@"!!!a", @"!a|!!!a", @"!a&!!!a", @"!!!a|!a|!!!!!a", @"!!!a&!!!!!a|!!!!!!!a", @"a^T" // @"a|a&a", @"a^a^a", @"a^a^a^a^a"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)testReduceToAandB {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"a&b"];
    for (NSString *input in @[@"a&b|b&a|a&b"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)testReduceToAordB {
    NyayaNode *expected = [NyayaNode formulaWithInput:@"a|b"];
    for (NSString *input in @[@"(a|a|b)&(b|a|b)&(a|a|b|b|b)"
         ]) {
        NyayaNode *actual = [NyayaNode formulaWithInput:input];
        STAssertEqualObjects(actual.reducedFormula, expected, [actual description]);
    }
}

- (void)xtestReduceBigXor {
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

- (void)testConjunctiveSet {
    NyayaNode *a = [NyayaNode formulaWithInput:@"a"];
    NyayaNode *b = [NyayaNode formulaWithInput:@"b"];
    NyayaNode *c = [NyayaNode formulaWithInput:@"c"];
    NyayaNode *d = [NyayaNode formulaWithInput:@"d&b"];
    NyayaNode *e = [NyayaNode formulaWithInput:@"e"];
    
    NyayaNode *n = [NyayaNode formulaWithInput:@"a|b|a|c|a|b|(d&b)"];
    
    NSSet *set = [n disjunctiveSet];
    
    STAssertEquals([set count], (NSUInteger)4, nil);
    STAssertTrue([set containsObject:a],nil);
    STAssertTrue([set containsObject:b],nil);
    STAssertTrue([set containsObject:c],nil);
    STAssertTrue([set containsObject:d],nil);
    
    STAssertFalse([set containsObject:e],nil);
    STAssertFalse([set containsObject:n],nil);
    
    
}

- (void)testDisjunctiveSet {
    NyayaNode *a = [NyayaNode formulaWithInput:@"a"];
    NyayaNode *b = [NyayaNode formulaWithInput:@"b"];
    NyayaNode *c = [NyayaNode formulaWithInput:@"c"];
    NyayaNode *d = [NyayaNode formulaWithInput:@"d|b"];
    NyayaNode *e = [NyayaNode formulaWithInput:@"e"];
    
    NyayaNode *n = [NyayaNode formulaWithInput:@"a&b&a&c&a&b&(d|b)"];
    
    NSSet *set = [n conjunctiveSet];
    
    STAssertEquals([set count], (NSUInteger)4, nil);
    STAssertTrue([set containsObject:a],nil);
    STAssertTrue([set containsObject:b],nil);
    STAssertTrue([set containsObject:c],nil);
    STAssertTrue([set containsObject:d],nil);
    
    STAssertFalse([set containsObject:e],nil);
    STAssertFalse([set containsObject:n],nil);
    
    
}

@end
