//
//  ReductionTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 06.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "ReductionTests.h"
#import "SenTestCase+NyayaTests.h"
#import "NyayaNode+Reductions.h"



@implementation ReductionTests


#pragma mark - basic reductions

- (void)testreduceToBottom {
    NyayaNode *expected = [self nodeWithFormula:@"F"];
    for (NSString *input in @[@"F", @"!T", @"T&F", @"F&T", @"F|F", @"!T&!T"
         , @"a&!a", @"!a&a", @"a&b&c&d&e&!a", @"a^a", @"a^a^a^a", @"a^a^a^a^a^a", @"T^T", @"F^F"
         ]) {
        NyayaNode *actual = [self nodeWithFormula:input];
        STAssertEqualObjects([actual reduce:1000], expected, [actual description]);
    }
}

- (void)testreduceToTop {
    NyayaNode *expected = [self nodeWithFormula:@"T"];
    for (NSString *input in @[@"!F", @"T", @"F|T", @"!F|!T", @"T|T" , @"T&T", @"!F&!F"
         , @"a|!a", @"!a|a", @"a|b|c|d|e|!a", @"a=a",
         //, @"F^T", @"T^F", @"a>a", @"a>a>a", @"a=a"
         //, @"(F|T)&(!F|!T)"
         ]) {
        NyayaNode *actual = [self nodeWithFormula:input];
        STAssertEqualObjects([actual reduce:1000], expected, [actual description]);
    }
}

- (void)testreduceToA {
    NyayaNode *expected = [self nodeWithFormula:@"a"];
    for (NSString *input in @[@"a", @"a|a", @"a&a", @"a|a|a", @"a&a|a", @"a^a^a", @"a^a^a^a^a", @"(a>a)>a", @"a|a&a", @"p∨¬q∨(¬p∨q)↔a"
         ]) {
        NyayaNode *actual = [self nodeWithFormula:input];
        STAssertEqualObjects([actual reduce:1000], expected, [actual description]);
    }
}

- (void)testreduceToNotA {
    NyayaNode *expected = [self nodeWithFormula:@"!a"];
    for (NSString *input in @[@"!!!a", @"!a|!!!a", @"!a&!!!a", @"!!!a|!a|!!!!!a", @"!!!a&!!!!!a|!!!!!!!a", @"a^T" // @"a|a&a", @"a^a^a", @"a^a^a^a^a"
         ]) {
        NyayaNode *actual = [self nodeWithFormula:input];
        STAssertEqualObjects([actual reduce:1000], expected, [actual description]);
    }
}

- (void)testreduceToAandB {
    NyayaNode *expected = [self nodeWithFormula:@"a&b"];
    for (NSString *input in @[@"a&b|b&a|a&b"
         ]) {
        NyayaNode *actual = [self nodeWithFormula:input];
        STAssertEqualObjects([actual reduce:1000], expected, [actual description]);
    }
}

- (void)testreduceToAordB {
    NyayaNode *expected = [self nodeWithFormula:@"a|b"];
    for (NSString *input in @[@"(a|a|b)&(b|a|b)&(a|a|b|b|b)"
         ]) {
        NyayaNode *actual = [self nodeWithFormula:input];
        STAssertEqualObjects([actual reduce:1000], expected, [actual description]);
    }
}

#pragma mark - reduce:1000 big formulas

- (void)xtestreduceBigXor {
    NyayaNode *formula = [self nodeWithFormula:@"a^b^c^d^f^g^h^i^j^k^l^m^n^o^p^q^r^s^t^u^v^w^x^y^z"];
    NSDate *begin = [NSDate date];
    
    NyayaNode *reducedFormula = [formula reduce:1000];
    
    NSDate *end = [NSDate date];
    
    STAssertEqualObjects(formula, reducedFormula, nil);
    STAssertTrue([end timeIntervalSinceDate:begin] < 0.001, nil);
    
}

- (void)xtestreduceBigFormulas {
    for (NSString*input in @[@"(p&q)|r"
         ,@"(p&q)|r^pp^q^rr^ss^tt^pq^qr^rs^s"
         ]) {
    
        NyayaNode *formula = [self nodeWithFormula:input];
        NSLog(@"%@",formula);
        NSDate *begin = [NSDate date];
        
        
        NyayaNode *reducedFormula = [formula reduce:1000];
        
        NSDate *end = [NSDate date];
        NSLog(@"%@",reducedFormula);
        
        STAssertEqualObjects(formula, reducedFormula, nil);
        NSTimeInterval duration = [end timeIntervalSinceDate:begin];
        STAssertTrue(duration < 0.001, @"%f", duration);
                          
    }
    
}

- (void)xtestreduceBigOr {
    for (NSString*input in @[@"a|b|c|d" , @"a|b|c|d|e|(f|g|h|i)|(j|k|l)|m|n"
         ]) {
        
        NyayaNode *formula = [self nodeWithFormula:input];
        NSLog(@"%@",formula);
        NSDate *begin = [NSDate date];
        
        
        NyayaNode *reducedFormula = [formula reduce:1000];
        
        NSDate *end = [NSDate date];
        NSLog(@"%@",reducedFormula);
        
        NSTimeInterval duration = [end timeIntervalSinceDate:begin];
        STAssertTrue(duration < 0.001, @"%f %@", duration, input);
        
    }
    
}

#pragma mark - formulas with problems

//- (void)testE1 {
//    NyayaNode *n = [self nodeWithFormula:@"p∨¬q∨(¬p∨q)↔s"];
//    NyayaNode *r = [n reduce:1000];
//    
//    // STAssertEqualObjects(n.truthTable, r.truthTable, nil);
//}

#pragma mark - sets 
- (void)testConjunctiveArray {
    NyayaNode *a = [self nodeWithFormula:@"a"];
    NyayaNode *b = [self nodeWithFormula:@"b"];
    NyayaNode *c = [self nodeWithFormula:@"c"];
    NyayaNode *d = [self nodeWithFormula:@"d&b"];
    NyayaNode *e = [self nodeWithFormula:@"e"];
    
    NyayaNode *n = [self nodeWithFormula:@"a|b|a|c|a|b|(d&b)"];
    
    NSArray *array = [n naryDisjunction];
    
    STAssertEquals([array count], (NSUInteger)4, nil);
    STAssertTrue([array containsObject:a],nil);
    STAssertTrue([array containsObject:b],nil);
    STAssertTrue([array containsObject:c],nil);
    STAssertTrue([array containsObject:d],nil);
    
    STAssertFalse([array containsObject:e],nil);
    STAssertFalse([array containsObject:n],nil);
    
    
}

- (void)testDisjunctiveArray {
    NyayaNode *a = [self nodeWithFormula:@"a"];
    NyayaNode *b = [self nodeWithFormula:@"b"];
    NyayaNode *c = [self nodeWithFormula:@"c"];
    NyayaNode *d = [self nodeWithFormula:@"d|b"];
    NyayaNode *e = [self nodeWithFormula:@"e"];
    
    NyayaNode *n = [self nodeWithFormula:@"a&b&a&c&a&b&(d|b)"];
    
    NSArray *array = [n naryConjunction];
    
    STAssertEquals([array count], (NSUInteger)4, nil);
    STAssertTrue([array containsObject:a],nil);
    STAssertTrue([array containsObject:b],nil);
    STAssertTrue([array containsObject:c],nil);
    STAssertTrue([array containsObject:d],nil);
    
    STAssertFalse([array containsObject:e],nil);
    STAssertFalse([array containsObject:n],nil);
    
    
}

- (void)testBigOr {
    
    NyayaNode *az = [self nodeWithFormula:@"a+b+c+d+e+f+g+h+i+j+k+m+n+p+q+r+s+t+u+v+w+x+y+z"];
    NSDate *begin = [NSDate date];
    NyayaNode *raz = [az reduce:NSIntegerMax];
    NSDate *end = [NSDate date];
    STAssertEqualObjects(az, raz, nil);
    NSTimeInterval duration = [end timeIntervalSinceDate:begin];
    STAssertTrue(duration < 0.001, @"%f", duration);
}

@end
