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
    for (NSString *input in @[@"a", @"a|a", @"a&a", @"a|a|a", @"a&a|a", @"a^a^a", @"a^a^a^a^a", @"(a>a)>a", @"a|a&a", @"p∨¬q∨(¬p∨q)↔a", @"a+(c.!c)", @"a.(c+!c)"
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

- (void)testXdisjunctiveArray {
    
    NSArray *abcArray = @[
    [self nodeWithFormula:@"(a+b+c)"],
    [self nodeWithFormula:@"(a+c+b)"],
    [self nodeWithFormula:@"(b+a+c)"],
    [self nodeWithFormula:@"(b+c+a)"],
    [self nodeWithFormula:@"(c+a+b)"],
    [self nodeWithFormula:@"(c+b+a)"]
    ];
    
    NyayaNode *n = [self nodeWithFormula:@"(a+b+c)^(a+c+b)^(b+a+c)"];
    
    NSMutableArray *array = [n naryXdisjunction];
    [array xorConsolidate];
    STAssertEquals([array count], (NSUInteger)1, nil);
    
    for (NyayaNode *abc in abcArray)
        STAssertTrue([array containsObject:abc],nil);
    
    STAssertEqualObjects([[array objectAtIndex:0] description], [[abcArray objectAtIndex:0] description], nil);
}

- (void)testBoconditionalArray {
    
    NSArray *abcArray = @[
    [self nodeWithFormula:@"(a+b+c)"],
    [self nodeWithFormula:@"(a+c+b)"],
    [self nodeWithFormula:@"(b+a+c)"],
    [self nodeWithFormula:@"(b+c+a)"],
    [self nodeWithFormula:@"(c+a+b)"],
    [self nodeWithFormula:@"(c+b+a)"]
    ];
    
    NyayaNode *n = [self nodeWithFormula:@"(a+b+c)=(a+c+b)=(b+a+c)"];
    
    NSArray *array = [n naryBiconditional];
    STAssertEquals([array count], (NSUInteger)1, nil);
    
    for (NyayaNode *abc in abcArray)
        STAssertTrue([array containsObject:abc],nil);
    
    STAssertEqualObjects([[array objectAtIndex:0] description], [[abcArray objectAtIndex:0] description], nil);
}


@end
