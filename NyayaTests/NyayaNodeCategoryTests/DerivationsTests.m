//
//  DerivationsTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DerivationsTests.h"
// #import "NyayaNode.h"
#import "NyayaNode+Derivations.h"

@implementation DerivationsTests

- (void)testSubNodeSet {
    
    NyayaNode *node = [NyayaNode nodeWithFormula:@"a"];
    NyayaNode *a = node;
    NSSet *set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)1, nil);
    
    node = [NyayaNode nodeWithFormula:@"a|a"];
    set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)2, nil);
    
    node = [NyayaNode nodeWithFormula:@"(a|b)&(a|b)"];
    set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)4, nil);
    
    node = [NyayaNode nodeWithFormula:@"(a>b)|((a>b)&c)"];
    set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)6, nil);
    
    
    STAssertTrue([set containsObject:a], nil);
    NSArray* array = [set allObjects];
    NSUInteger idx = [array indexOfObject:a];
    STAssertTrue(idx != NSNotFound, nil);
    NyayaNode *a2 = [array objectAtIndex:idx];
    STAssertFalse(a == a2, nil);
    STAssertTrue([a isEqual:a2], nil);
    
}

- (void)testAllreadyImplicationFree {
    for (NSString *input in @[@"!a", @"!a", @"a|b"
         ]) {
        NyayaNode *n = [NyayaNode nodeWithFormula:input];
        NyayaNode *i = [n imf];
        STAssertEqualObjects(i, n, nil);
    }
}

- (void)testImplicationImf {
    NyayaNode *n = [NyayaNode nodeWithFormula:@"a>b"];
    NyayaNode *i = [n imf];
    NyayaNode *e = [NyayaNode nodeWithFormula:@"!a|b"];
    STAssertEqualObjects(i, e, nil);
}

- (void)testBiconditionalImf {
    NyayaNode *n = [NyayaNode nodeWithFormula:@"a=b"];
    NyayaNode *i = [n imf];
    NyayaNode *e = [NyayaNode nodeWithFormula:@"(!a|b)&(!b|a)"];
    STAssertEqualObjects(i, e, nil);
}



- (void)testFxorT {
    NyayaNode *n = [NyayaNode nodeWithFormula:@"F^T"];
    NyayaNode *i = [n imf];
    NyayaNode *e = [NyayaNode nodeWithFormula:@"(F|T)&(!F|!T)"];
    STAssertEqualObjects(i, e, nil);
}


- (void)testXorImf {
    NyayaNode *n = [NyayaNode nodeWithFormula:@"a^b"];
    NyayaNode *i = [n imf];
    NyayaNode *e = [NyayaNode nodeWithFormula:@"(a|b)&(!a|!b) "];
    STAssertEqualObjects(i, e, nil);
    
    
}



@end
