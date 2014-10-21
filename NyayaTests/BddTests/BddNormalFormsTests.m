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
    
    XCTAssertEqual([[bdd pathsTo:@"0"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"1"] count], (NSUInteger)0);
    
    XCTAssertEqual([[bdd conjunctiveSet] count], (NSUInteger)1);
    XCTAssertEqual([[bdd disjunctiveSet] count], (NSUInteger)0);
    
    XCTAssertEqualObjects([bdd dnfDescription], @"F");
    XCTAssertEqualObjects([bdd cnfDescription], @"F");
    
    node = [NyayaFormula formulaWithString:@"a"];
    bdd = [node OBDD:YES];
    XCTAssertEqual([[bdd pathsTo:@"0"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"1"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"a"] count], (NSUInteger)1);
    
    XCTAssertEqual([[bdd conjunctiveSet] count], (NSUInteger)1);
    XCTAssertEqual([[bdd disjunctiveSet] count], (NSUInteger)1);
    
    XCTAssertEqualObjects([bdd dnfDescription], @"(a)");
    XCTAssertEqualObjects([bdd cnfDescription], @"(a)");
    
    
    node = [NyayaFormula formulaWithString:@"a|b"];
    bdd = [node OBDD:YES];
    
    XCTAssertEqual([[bdd pathsTo:@"0"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"1"] count], (NSUInteger)2);
    XCTAssertEqual([[bdd pathsTo:@"a"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"b"] count], (NSUInteger)1);
    
    XCTAssertEqual([[bdd conjunctiveSet] count], (NSUInteger)1);
    XCTAssertEqual([[bdd disjunctiveSet] count], (NSUInteger)2);
    
    XCTAssertEqualObjects([bdd dnfDescription], @"(a ∨ b)");
    XCTAssertEqualObjects([bdd cnfDescription], @"(a ∨ b)");
    
    node = [NyayaFormula formulaWithString:@"a&b"];
    bdd = [node OBDD:YES];
    
    XCTAssertEqual([[bdd pathsTo:@"0"] count], (NSUInteger)2);
    XCTAssertEqual([[bdd pathsTo:@"1"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"a"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"b"] count], (NSUInteger)1);
    
    XCTAssertEqual([[bdd conjunctiveSet] count], (NSUInteger)2);
    XCTAssertEqual([[bdd disjunctiveSet] count], (NSUInteger)1);
    
    XCTAssertEqualObjects([bdd dnfDescription], @"(a ∧ b)");
    XCTAssertEqualObjects([bdd cnfDescription], @"(a ∧ b)");
    
    node = [NyayaFormula formulaWithString:@"a^b"];
    bdd = [node OBDD:YES];
    
    XCTAssertEqual([[bdd pathsTo:@"0"] count], (NSUInteger)2);
    XCTAssertEqual([[bdd pathsTo:@"1"] count], (NSUInteger)2);
    XCTAssertEqual([[bdd pathsTo:@"a"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"b"] count], (NSUInteger)2);
    
    XCTAssertEqual([[bdd conjunctiveSet] count], (NSUInteger)2);
    XCTAssertEqual([[bdd disjunctiveSet] count], (NSUInteger)2);
    
    XCTAssertEqualObjects([bdd dnfDescription], @"(a ∧ ¬b) ∨ (¬a ∧ b)");
    XCTAssertEqualObjects([bdd cnfDescription], @"(a ∨ b) ∧ (¬a ∨ ¬b)");
    
    node = [NyayaFormula formulaWithString:@"a+b.c"];
    bdd = [node OBDD:YES];
    
    XCTAssertEqual([[bdd pathsTo:@"0"] count], (NSUInteger)2);
    XCTAssertEqual([[bdd pathsTo:@"1"] count], (NSUInteger)2);
    XCTAssertEqual([[bdd pathsTo:@"a"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"b"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"c"] count], (NSUInteger)1);
    
    XCTAssertEqual([[bdd conjunctiveSet] count], (NSUInteger)2);
    XCTAssertEqual([[bdd disjunctiveSet] count], (NSUInteger)2);
    
//    STAssertEqualObjects([bdd dnfDescription], @"a ∨ (b ∧ c)", nil);
//    STAssertEqualObjects([bdd cnfDescription], @"(a ∨ b) ∧ (a ∨ c)", nil);
    
    
}

- (void)xtestBigXor {
    NyayaFormula *node = [NyayaFormula formulaWithString:@"a^b^c^d^e^f^g^h^i^j^k^l"]; //^l^m^n^o^p^q^r^s^t^u^v^w^x^y^z"];
    BddNode *bdd = [node OBDD:YES];
    XCTAssertEqual([[bdd pathsTo:@"a"] count], (NSUInteger)1);
    XCTAssertEqual([[bdd pathsTo:@"b"] count], (NSUInteger)2);
    XCTAssertEqual([[bdd pathsTo:@"c"] count], (NSUInteger)4);
    XCTAssertEqual([[bdd pathsTo:@"d"] count], (NSUInteger)8);
    XCTAssertEqual([[bdd pathsTo:@"e"] count], (NSUInteger)16);
    XCTAssertEqual([[bdd pathsTo:@"f"] count], (NSUInteger)32);
    XCTAssertEqual([[bdd pathsTo:@"g"] count], (NSUInteger)64);
    XCTAssertEqual([[bdd pathsTo:@"h"] count], (NSUInteger)128);
    XCTAssertEqual([[bdd pathsTo:@"i"] count], (NSUInteger)256);
    XCTAssertEqual([[bdd pathsTo:@"j"] count], (NSUInteger)512);
    XCTAssertEqual([[bdd pathsTo:@"k"] count], (NSUInteger)1024);
    XCTAssertEqual([[bdd pathsTo:@"l"] count], (NSUInteger)2048);
    XCTAssertEqual([[bdd pathsTo:@"0"] count], (NSUInteger)2048);
    XCTAssertEqual([[bdd pathsTo:@"1"] count], (NSUInteger)2048);
    
    
}

@end
