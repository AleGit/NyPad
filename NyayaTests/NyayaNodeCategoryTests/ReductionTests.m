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

#pragma mark - basic reductions

- (void)testReduceToBottom {
    NyayaNode *expected = [NyayaNode nodeWithFormula:@"F"];
    for (NSString *input in @[@"F", @"!T", @"T&F", @"F&T", @"F|F", @"!T&!T"
         , @"a&!a", @"!a&a", @"a&b&c&d&e&!a", @"a^a", @"a^a^a^a", @"a^a^a^a^a^a", @"T^T", @"F^F"
         ]) {
        NyayaNode *actual = [NyayaNode nodeWithFormula:input];
        STAssertEqualObjects([actual reduce], expected, [actual description]);
    }
}

- (void)testReduceToTop {
    NyayaNode *expected = [NyayaNode nodeWithFormula:@"T"];
    for (NSString *input in @[@"!F", @"T", @"F|T", @"!F|!T", @"T|T" , @"T&T", @"!F&!F"
         , @"a|!a", @"!a|a", @"a|b|c|d|e|!a", @"a=a",
         //, @"F^T", @"T^F", @"a>a", @"a>a>a", @"a=a"
         //, @"(F|T)&(!F|!T)"
         ]) {
        NyayaNode *actual = [NyayaNode nodeWithFormula:input];
        STAssertEqualObjects([actual reduce], expected, [actual description]);
    }
}

- (void)testReduceToA {
    NyayaNode *expected = [NyayaNode nodeWithFormula:@"a"];
    for (NSString *input in @[@"a", @"a|a", @"a&a", @"a|a|a", @"a&a|a", @"a^a^a", @"a^a^a^a^a", @"(a>a)>a", @"a|a&a", @"p∨¬q∨(¬p∨q)↔a"
         ]) {
        NyayaNode *actual = [NyayaNode nodeWithFormula:input];
        STAssertEqualObjects([actual reduce], expected, [actual description]);
    }
}

- (void)testReduceToNotA {
    NyayaNode *expected = [NyayaNode nodeWithFormula:@"!a"];
    for (NSString *input in @[@"!!!a", @"!a|!!!a", @"!a&!!!a", @"!!!a|!a|!!!!!a", @"!!!a&!!!!!a|!!!!!!!a", @"a^T" // @"a|a&a", @"a^a^a", @"a^a^a^a^a"
         ]) {
        NyayaNode *actual = [NyayaNode nodeWithFormula:input];
        STAssertEqualObjects([actual reduce], expected, [actual description]);
    }
}

- (void)testReduceToAandB {
    NyayaNode *expected = [NyayaNode nodeWithFormula:@"a&b"];
    for (NSString *input in @[@"a&b|b&a|a&b"
         ]) {
        NyayaNode *actual = [NyayaNode nodeWithFormula:input];
        STAssertEqualObjects([actual reduce], expected, [actual description]);
    }
}

- (void)testReduceToAordB {
    NyayaNode *expected = [NyayaNode nodeWithFormula:@"a|b"];
    for (NSString *input in @[@"(a|a|b)&(b|a|b)&(a|a|b|b|b)"
         ]) {
        NyayaNode *actual = [NyayaNode nodeWithFormula:input];
        STAssertEqualObjects([actual reduce], expected, [actual description]);
    }
}

#pragma mark - reduce big formulas

- (void)xtestReduceBigXor {
    NyayaNode *formula = [NyayaNode nodeWithFormula:@"a^b^c^d^f^g^h^i^j^k^l^m^n^o^p^q^r^s^t^u^v^w^x^y^z"];
    NSDate *begin = [NSDate date];
    
    NyayaNode *reducedFormula = [formula reduce];
    
    NSDate *end = [NSDate date];
    
    STAssertEqualObjects(formula, reducedFormula, nil);
    STAssertTrue([end timeIntervalSinceDate:begin] < 0.001, nil);
    
}

- (void)xtestReduceBigFormulas {
    for (NSString*input in @[@"(p&q)|r"
         ,@"(p&q)|r^pp^q^rr^ss^tt^pq^qr^rs^s"
         ]) {
    
        NyayaNode *formula = [NyayaNode nodeWithFormula:input];
        NSLog(@"%@",formula);
        NSDate *begin = [NSDate date];
        
        
        NyayaNode *reducedFormula = [formula reduce];
        
        NSDate *end = [NSDate date];
        NSLog(@"%@",reducedFormula);
        
        STAssertEqualObjects(formula, reducedFormula, nil);
        NSTimeInterval duration = [end timeIntervalSinceDate:begin];
        STAssertTrue(duration < 0.001, @"%f", duration);
                          
    }
    
}

- (void)xtestReduceBigOr {
    for (NSString*input in @[@"a|b|c|d" , @"a|b|c|d|e|(f|g|h|i)|(j|k|l)|m|n"
         ]) {
        
        NyayaNode *formula = [NyayaNode nodeWithFormula:input];
        NSLog(@"%@",formula);
        NSDate *begin = [NSDate date];
        
        
        NyayaNode *reducedFormula = [formula reduce];
        
        NSDate *end = [NSDate date];
        NSLog(@"%@",reducedFormula);
        
        NSTimeInterval duration = [end timeIntervalSinceDate:begin];
        STAssertTrue(duration < 0.001, @"%f %@", duration, input);
        
    }
    
}

#pragma mark - formulas with problems

//- (void)testE1 {
//    NyayaNode *n = [NyayaNode nodeWithFormula:@"p∨¬q∨(¬p∨q)↔s"];
//    NyayaNode *r = [n reduce];
//    
//    // STAssertEqualObjects(n.truthTable, r.truthTable, nil);
//}

#pragma mark - sets 
- (void)testConjunctiveSet {
    NyayaNode *a = [NyayaNode nodeWithFormula:@"a"];
    NyayaNode *b = [NyayaNode nodeWithFormula:@"b"];
    NyayaNode *c = [NyayaNode nodeWithFormula:@"c"];
    NyayaNode *d = [NyayaNode nodeWithFormula:@"d&b"];
    NyayaNode *e = [NyayaNode nodeWithFormula:@"e"];
    
    NyayaNode *n = [NyayaNode nodeWithFormula:@"a|b|a|c|a|b|(d&b)"];
    
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
    NyayaNode *a = [NyayaNode nodeWithFormula:@"a"];
    NyayaNode *b = [NyayaNode nodeWithFormula:@"b"];
    NyayaNode *c = [NyayaNode nodeWithFormula:@"c"];
    NyayaNode *d = [NyayaNode nodeWithFormula:@"d|b"];
    NyayaNode *e = [NyayaNode nodeWithFormula:@"e"];
    
    NyayaNode *n = [NyayaNode nodeWithFormula:@"a&b&a&c&a&b&(d|b)"];
    
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
