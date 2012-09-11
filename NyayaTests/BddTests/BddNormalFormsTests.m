//
//  BddNormalFormsTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 10.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BddNormalFormsTests.h"

@interface BddNode (Tests)
- (NSMutableSet*)pathsTo:(NSString*)name;
- (NSMutableSet*)disjunctiveSet;
- (NSMutableSet*)conjunctiveSet;
- (NSString*)dnfDescription;
- (NSString*)cnfDescription;
@end

@implementation BddNormalFormsTests

- (void)testPathsTo {
    NyayaNode *node = [NyayaNode nodeWithFormula:@"0"];
    BddNode *bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)0, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)0, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"F", nil);
    STAssertEqualObjects([bdd cnfDescription], @"F", nil);
    
    node = [NyayaNode nodeWithFormula:@"a"];
    bdd = [node OBDD:YES];
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)1, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a)", nil);
    
    
    node = [NyayaNode nodeWithFormula:@"a|b"];
    bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a) ∨ (¬a ∧ b)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a ∨ b)", nil);
    
    node = [NyayaNode nodeWithFormula:@"a&b"];
    bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)1, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a ∧ b)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a) ∧ (¬a ∨ b)", nil);
    
    node = [NyayaNode nodeWithFormula:@"a^b"];
    bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)2, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a ∧ ¬b) ∨ (¬a ∧ b)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a ∨ b) ∧ (¬a ∨ ¬b)", nil);
    
    node = [NyayaNode nodeWithFormula:@"a+b.c"];
    bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"c"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
//    STAssertEqualObjects([bdd dnfDescription], @"a ∨ (b ∧ c)", nil);
//    STAssertEqualObjects([bdd cnfDescription], @"(a ∨ b) ∧ (a ∨ c)", nil);
    
    
}

@end
