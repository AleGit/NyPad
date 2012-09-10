//
//  BddNormalFormsTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 10.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BddNormalFormsTests.h"

@implementation BddNormalFormsTests

- (void)testPathsTo {
    NyayaNode *node = [NyayaNode nodeWithFormula:@"0"];
    BddNode *bdd = node.binaryDecisionDiagram;
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)0, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)0, nil);
    
    STAssertEqualObjects([bdd disjunctiveDescription], @"F", nil);
    STAssertEqualObjects([bdd conjunctiveDescription], @"F", nil);
    
    node = [NyayaNode nodeWithFormula:@"a"];
    bdd = node.binaryDecisionDiagram;
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)1, nil);
    
    STAssertEqualObjects([bdd disjunctiveDescription], @"a", nil);
    STAssertEqualObjects([bdd conjunctiveDescription], @"a", nil);
    
    
    node = [NyayaNode nodeWithFormula:@"a|b"];
    bdd = node.binaryDecisionDiagram;
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
    STAssertEqualObjects([bdd disjunctiveDescription], @"a ∨ b", nil);
    STAssertEqualObjects([bdd conjunctiveDescription], @"a ∨ b", nil);
    
    node = [NyayaNode nodeWithFormula:@"a&b"];
    bdd = node.binaryDecisionDiagram;
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)1, nil);
    
    STAssertEqualObjects([bdd disjunctiveDescription], @"a ∧ b", nil);
    STAssertEqualObjects([bdd conjunctiveDescription], @"a ∧ b", nil);
    
    node = [NyayaNode nodeWithFormula:@"a^b"];
    bdd = node.binaryDecisionDiagram;
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)2, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
    STAssertEqualObjects([bdd disjunctiveDescription], @"(a ∧ ¬b) ∨ (¬a ∧ b)", nil);
    STAssertEqualObjects([bdd conjunctiveDescription], @"(a ∨ b) ∧ (¬a ∨ ¬b)", nil);
    
    node = [NyayaNode nodeWithFormula:@"a+b.c"];
    bdd = node.binaryDecisionDiagram;
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"c"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
//    STAssertEqualObjects([bdd disjunctiveDescription], @"a ∨ (b ∧ c)", nil);
//    STAssertEqualObjects([bdd conjunctiveDescription], @"(a ∨ b) ∧ (a ∨ c)", nil);
    
    
}

@end
