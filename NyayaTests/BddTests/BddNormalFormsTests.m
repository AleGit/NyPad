//
//  BddNormalFormsTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 10.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BddNormalFormsTests.h"
#import "NyayaFormula.h"

@interface BddNode (Tests)
- (NSMutableSet*)pathsTo:(NSString*)name;
- (NSMutableSet*)disjunctiveSet;
- (NSMutableSet*)conjunctiveSet;
- (NSString*)dnfDescription;
- (NSString*)cnfDescription;
@end

@implementation BddNormalFormsTests

- (void)testPathsTo {
    NyayaFormula *node = [NyayaFormula formulaWithString:@"0"];
    BddNode *bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)0, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)0, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"F", nil);
    STAssertEqualObjects([bdd cnfDescription], @"F", nil);
    
    node = [NyayaFormula formulaWithString:@"a"];
    bdd = [node OBDD:YES];
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)1, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a)", nil);
    
    
    node = [NyayaFormula formulaWithString:@"a|b"];
    bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a ∨ b)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a ∨ b)", nil);
    
    node = [NyayaFormula formulaWithString:@"a&b"];
    bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)1, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)1, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a ∧ b)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a ∧ b)", nil);
    
    node = [NyayaFormula formulaWithString:@"a^b"];
    bdd = [node OBDD:YES];
    
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)2, nil);
    
    STAssertEquals([[bdd conjunctiveSet] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd disjunctiveSet] count], (NSUInteger)2, nil);
    
    STAssertEqualObjects([bdd dnfDescription], @"(a ∧ ¬b) ∨ (¬a ∧ b)", nil);
    STAssertEqualObjects([bdd cnfDescription], @"(a ∨ b) ∧ (¬a ∨ ¬b)", nil);
    
    node = [NyayaFormula formulaWithString:@"a+b.c"];
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

- (void)testBigXor {
    NyayaFormula *node = [NyayaFormula formulaWithString:@"a^b^c^d^e^f^g^h^i^j^k^l"]; //^l^m^n^o^p^q^r^s^t^u^v^w^x^y^z"];
    BddNode *bdd = [node OBDD:YES];
    STAssertEquals([[bdd pathsTo:@"a"] count], (NSUInteger)1, nil);
    STAssertEquals([[bdd pathsTo:@"b"] count], (NSUInteger)2, nil);
    STAssertEquals([[bdd pathsTo:@"c"] count], (NSUInteger)4, nil);
    STAssertEquals([[bdd pathsTo:@"d"] count], (NSUInteger)8, nil);
    STAssertEquals([[bdd pathsTo:@"e"] count], (NSUInteger)16, nil);
    STAssertEquals([[bdd pathsTo:@"f"] count], (NSUInteger)32, nil);
    STAssertEquals([[bdd pathsTo:@"g"] count], (NSUInteger)64, nil);
    STAssertEquals([[bdd pathsTo:@"h"] count], (NSUInteger)128, nil);
    STAssertEquals([[bdd pathsTo:@"i"] count], (NSUInteger)256, nil);
    STAssertEquals([[bdd pathsTo:@"j"] count], (NSUInteger)512, nil);
    STAssertEquals([[bdd pathsTo:@"k"] count], (NSUInteger)1024, nil);
    STAssertEquals([[bdd pathsTo:@"l"] count], (NSUInteger)2048, nil);
    STAssertEquals([[bdd pathsTo:@"0"] count], (NSUInteger)2048, nil);
    STAssertEquals([[bdd pathsTo:@"1"] count], (NSUInteger)2048, nil);
    
    
}

@end
