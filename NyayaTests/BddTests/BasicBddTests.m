//
//  BasicBddTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 06.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BasicBddTests.h"
#include "NyayaParser.h"
#include "NyayaNode+Creation.h"
#include "NyayaNode+Valuation.h"
#include "TruthTable.h"
#include "BddNode.h"

@implementation BasicBddTests

- (void)testNSUInteger {
    NSUInteger count = 10;
    NSUInteger sum = 0;
    
    for (NSUInteger idx = count-1; idx < count; idx--) {
        // -1 == NSUIntegerMax so "idx < count" is the correct statement to stop at "0" (inclusive)
        sum+=idx;
    }
    
    STAssertEquals(sum, (NSUInteger)45, nil);
    
    
    
}

- (void)testTautology {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a | (!a and b) | !b"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    
    STAssertTrue(node.isLeaf,nil);
    STAssertEquals(node.id, 1, nil);
    
//    STAssertEqualObjects(node.CNF.description, @"1", nil);
//    STAssertEqualObjects([node dnfDescription], @"1", nil);
}

- (void)testContradiction {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a & (!a or b) & !b"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    STAssertTrue(node.isLeaf,nil);
    STAssertEquals(node.id, 0, nil);
    
    
    STAssertEqualObjects(node.cnfDescription, @"F", nil);
//    STAssertEqualObjects([node dnfDescription], @"0", nil);
}


- (void)testOr {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a | b)|(a|b)&(a|b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    STAssertTrue([node isMemberOfClass:[BddNode class]], nil);
    STAssertEquals(node.id, 3, nil);
    STAssertEqualObjects(node.name, @"a", nil);
    
    STAssertEquals(node.leftBranch.id, 2, nil);
    STAssertEqualObjects(node.leftBranch.name, @"b", nil);
    STAssertEquals(node.leftBranch.leftBranch.id, 0, nil);
    STAssertEquals(node.leftBranch.rightBranch.id, 1, nil);
    
    STAssertEquals(node.rightBranch.id, 1, nil);
    
    STAssertEqualObjects(node.cnfDescription, @"(a ∨ b)", nil);
//    STAssertEqualObjects([node dnfDescription], @"(a) ∨ (¬a ∧ b)", nil);
}

- (void)testAnd {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a & b)&(a & b)|(a & b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    STAssertTrue([node isMemberOfClass:[BddNode class]], nil);
    STAssertEquals(node.id, 3, nil);
    STAssertEqualObjects(node.name, @"a", nil);
    
    STAssertEquals(node.rightBranch.id, 2, nil);
    STAssertEqualObjects(node.rightBranch.name, @"b", nil);
    STAssertEquals(node.rightBranch.leftBranch.id, 0, nil);
    STAssertEquals(node.rightBranch.rightBranch.id, 1, nil);
    
    STAssertEquals(node.leftBranch.id, 0, nil);
    
    STAssertEqualObjects([node cnfDescription], @"(a ∧ b)", nil);
    STAssertEqualObjects([node dnfDescription], @"(a ∧ b)", nil);
}

- (void)testXor {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a ^ b)|(a ^ b)&(a ^ b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    STAssertEquals(node.id, 4, nil);
    STAssertEquals(node.rightBranch.id, 3, nil);
    STAssertEquals(node.leftBranch.id, 2, nil);
    STAssertEquals(node.leftBranch.rightBranch.id, 1, nil);   
    STAssertEquals(node.rightBranch.leftBranch.id, 1, nil);
    STAssertEquals(node.leftBranch.leftBranch.id, 0, nil);
    STAssertEquals(node.rightBranch.rightBranch.id, 0, nil);
    
    STAssertEqualObjects(node.name, @"a", nil);
    STAssertEqualObjects(node.leftBranch.name, @"b", nil);
    STAssertEqualObjects(node.rightBranch.name, @"b", nil);
    
    STAssertEqualObjects(node.cnfDescription, @"(a ∨ b) ∧ (¬a ∨ ¬b)", nil);
    STAssertEqualObjects([node dnfDescription], @"(a ∧ ¬b) ∨ (¬a ∧ b)", nil);
    
}

- (void)testAorBandC {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a|b&c)&(a|b&c)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    STAssertEquals(node.id, 4, nil);
    STAssertEqualObjects(node.name, @"a", nil);
    STAssertEquals(node.leftBranch.id, 3, nil);
    STAssertEqualObjects(node.leftBranch.name, @"b", nil);
    STAssertEquals(node.leftBranch.rightBranch.id, 2, nil);
    STAssertEqualObjects(node.leftBranch.rightBranch.name, @"c", nil);
    
    STAssertEquals(node.rightBranch.id, 1, nil);
    STAssertEquals(node.leftBranch.rightBranch.rightBranch.id, 1, nil);
    
    STAssertEquals(node.leftBranch.leftBranch.id, 0, nil);
    STAssertEquals(node.leftBranch.rightBranch.leftBranch.id, 0, nil);
    
    STAssertEqualObjects(node.cnfDescription, @"(a ∨ ¬b ∨ c) ∧ (a ∨ b)", nil);
//    STAssertEqualObjects([node dnfDescription], @"(a) ∨ (¬a ∧ b ∧ c)", nil);
    
    NSLog(@"%@", [formula description]);
}

- (void)testObddReduced {
    NSArray *variables = @[[NyayaNode atom:@"a"], [NyayaNode atom:@"b"], [NyayaNode atom:@"c"]];
    
    
    
    
    NyayaNode *node = [NyayaNode disjunction:variables[0] with:[NyayaNode conjunction:variables[1] with:variables[2]]];
    // a + b.c
    
    BddNode *bdd = [BddNode obddWithNode:node order:variables reduce:YES];
    //     a
    //    / \
    //   b   1
    //  / \
    // 0   c
    //    / \
    //   0   1
    
    BddNode *a0 = bdd.leftBranch;
    BddNode *a1 = bdd.rightBranch;
    BddNode *b0 = a0.leftBranch;
    BddNode *b1 = a0.rightBranch;
    BddNode *c0 = b1.leftBranch;
    BddNode *c1 = b1.rightBranch;
    
    STAssertEqualObjects(bdd.name, @"a", nil);
    
    STAssertEqualObjects(a0.name, @"b", nil);
    STAssertEqualObjects(a1.name, @"1", nil);
    
    STAssertEqualObjects(b0.name, @"0", nil);
    STAssertEqualObjects(b1.name, @"c", nil);
    
    STAssertEqualObjects(c0.name, @"0", nil);
    STAssertEqualObjects(c1.name, @"1", nil);
    
    STAssertEquals(a1, c1, nil);
    STAssertEquals(b0, c0, nil);
}

- (void)testAxorBReduced {
    NSArray *variables = @[[NyayaNode atom:@"a"], [NyayaNode atom:@"b"]];
    NyayaNode *node = [NyayaNode xdisjunction:variables[0] with:variables[1]];
    // a ^ b
    
    BddNode *bdd = [BddNode obddWithNode:node order:variables reduce:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [bdd fillStructure:dict];
    STAssertEquals([dict count], (NSUInteger)4, nil);
    
    STAssertEqualObjects(bdd.name, @"a", nil);
    //     a
    //    . \
    //   b   b
    //   | x |
    //   1   0
    
    BddNode *a0 = bdd.leftBranch;
    BddNode *a1 = bdd.rightBranch;
    STAssertEqualObjects(a0.name, @"b", nil);
    STAssertEqualObjects(a1.name, @"b", nil);
    
    BddNode *a0b1 = a0.rightBranch;
    BddNode *a1b0 = a1.leftBranch;
    STAssertEqualObjects(a0b1.name, @"1", nil);
    STAssertEqualObjects(a1b0.name, @"1", nil);
    STAssertEquals(a0b1, a1b0, nil);
    
}

- (void)testXorReduced {
    NSArray *variables = @[[NyayaNode atom:@"a"], [NyayaNode atom:@"b"], [NyayaNode atom:@"c"]];
    
    
    
    
    NyayaNode *node = [NyayaNode xdisjunction:variables[0] with:[NyayaNode xdisjunction:variables[1] with:variables[2]]];
    // a ^ (b ^ c)
    
    BddNode *bdd = [BddNode obddWithNode:node order:variables reduce:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [bdd fillStructure:dict];
    STAssertEquals([dict count], (NSUInteger)5, nil);
    
    STAssertEqualObjects(bdd.name, @"a", nil);
    //     a
    //    . \
    //   b   b
    //   | x |
    //   c   c
    //   | x |
    //   0   1
    
    BddNode *a0 = bdd.leftBranch;
    BddNode *a1 = bdd.rightBranch;
    STAssertEqualObjects(a0.name, @"b", nil);
    STAssertEqualObjects(a1.name, @"b", nil);
    
    BddNode *a0b1 = a0.rightBranch;
    BddNode *a1b0 = a1.leftBranch;
    STAssertEquals(a0b1, a1b0, nil);
    
    BddNode *a1b1 = a1.rightBranch;
    BddNode *a0b0 = a0.leftBranch;
    STAssertEquals(a1b1, a0b0, nil);

}

- (void)testObbd {
    NSArray *variables = @[[NyayaNode atom:@"a"], [NyayaNode atom:@"b"], [NyayaNode atom:@"c"]];
    
    
    
    
    NyayaNode *node = [NyayaNode disjunction:variables[0] with:[NyayaNode conjunction:variables[1] with:variables[2]]];
    // a + b.c
    
    BddNode *bdd = [BddNode obddWithNode:node order:variables reduce:NO];
    STAssertEquals([bdd.names count], (NSUInteger)3, nil);
    [variables enumerateObjectsUsingBlock:^(NyayaNode *obj, NSUInteger idx, BOOL *stop) {
        STAssertEqualObjects(obj.symbol, bdd.names[idx], nil);
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [bdd fillStructure:dict];
    STAssertEquals([dict count], (NSUInteger)5, nil);
    
    
    //               a:14
    //           /         \
    //       b:6             b:13
    //      /   \           /    \
    //   c:2     c:5     c:9      c:12
    //  /   \   /   \   /   \    /   \
    // 0:0 0:1 0:3 1:4 1:7 1:8 1:10 1:11
    // 
    
    BddNode *a0 = bdd.leftBranch;
    BddNode *a1 = bdd.rightBranch;
    
    BddNode *a00 = a0.leftBranch;
    BddNode *a01 = a0.rightBranch;
    BddNode *a10 = a1.leftBranch;
    BddNode *a11 = a1.rightBranch;
    
    BddNode *a000 = a00.leftBranch;
    BddNode *a001 = a00.rightBranch;
    BddNode *a010 = a01.leftBranch;
    BddNode *a011 = a01.rightBranch;
    
    BddNode *a100 = a10.leftBranch;
    BddNode *a101 = a10.rightBranch;
    BddNode *a110 = a11.leftBranch;
    BddNode *a111 = a11.rightBranch;
    
    STAssertEquals(bdd.id, 14, nil);
    
    STAssertEquals(a0.id, 6, nil);
    STAssertEquals(a1.id, 13, nil);
    
    STAssertEquals(a00.id, 2, nil);
    STAssertEquals(a01.id, 5, nil);
    STAssertEquals(a10.id, 9, nil);
    STAssertEquals(a11.id, 12, nil);
    
    STAssertEquals(a000.id, 0, nil);
    STAssertEquals(a001.id, 1, nil);
    STAssertEquals(a010.id, 3, nil);
    STAssertEquals(a011.id, 4, nil);
    STAssertEquals(a100.id, 7, nil);
    STAssertEquals(a101.id, 8, nil);
    STAssertEquals(a110.id, 10, nil);
    STAssertEquals(a111.id, 11, nil);
   
        
    STAssertEqualObjects(bdd.name, @"a", nil);
    
    STAssertEqualObjects(a0.name, @"b", nil);
    STAssertEqualObjects(a1.name, @"b", nil);
    
    STAssertEqualObjects(a00.name, @"c", nil);
    STAssertEqualObjects(a01.name, @"c", nil);
    STAssertEqualObjects(a00.name, @"c", nil);
    STAssertEqualObjects(a01.name, @"c", nil);
    
    STAssertEqualObjects(a000.name, @"0", nil);
    STAssertEqualObjects(a001.name, @"0", nil);
    STAssertEqualObjects(a010.name, @"0", nil);
    STAssertEqualObjects(a011.name, @"1", nil);
    STAssertEqualObjects(a100.name, @"1", nil);
    STAssertEqualObjects(a101.name, @"1", nil);
    STAssertEqualObjects(a110.name, @"1", nil);
    STAssertEqualObjects(a111.name, @"1", nil);
}


- (void)testIssue_20130420_1 {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"p&q^r&s"];
    NyayaNode *node = [parser parseFormula];
    
    NSArray *variables = [node.setOfVariables allObjects];
    NyayaNodeVariable *r = [variables objectAtIndex:0];
    NyayaNodeVariable *p = [variables objectAtIndex:1];
    NyayaNodeVariable *s = [variables objectAtIndex:2];
    NyayaNodeVariable *q = [variables objectAtIndex:3];
    
    STAssertEqualObjects(r.symbol, @"r", @"r");
    STAssertEqualObjects(p.symbol, @"p", @"p");
    STAssertEqualObjects(s.symbol, @"s", @"s");
    STAssertEqualObjects(q.symbol, @"q", @"q");
    BddNode *bddNode = [BddNode obddWithNode:node order:variables reduce:YES];
    

    STAssertEqualObjects(bddNode.name, r.symbol, nil);
    STAssertEqualObjects(bddNode.leftBranch.name, @"p", nil);
    STAssertEqualObjects(bddNode.leftBranch.leftBranch.name, @"0", nil);
    STAssertEqualObjects(bddNode.leftBranch.rightBranch.name, @"q", nil);
    STAssertEqualObjects(bddNode.leftBranch.rightBranch.leftBranch.name, @"0", nil);
    STAssertEqualObjects(bddNode.leftBranch.rightBranch.rightBranch.name, @"1", nil);
    
    
    STAssertEqualObjects(bddNode.rightBranch.rightBranch.name, @"s", nil);
    STAssertEqualObjects(bddNode.rightBranch.rightBranch.leftBranch.name, @"q", nil);
    STAssertEqualObjects(bddNode.rightBranch.rightBranch.leftBranch.leftBranch.name, @"0", nil);
    STAssertEqualObjects(bddNode.rightBranch.rightBranch.leftBranch.rightBranch.name, @"1", nil);
    STAssertEqualObjects(bddNode.rightBranch.rightBranch.rightBranch.name, @"q", nil);
    STAssertEqualObjects(bddNode.rightBranch.rightBranch.rightBranch.leftBranch.name, @"1", nil);
    STAssertEqualObjects(bddNode.rightBranch.rightBranch.rightBranch.rightBranch.name, @"0", nil);


    STAssertEqualObjects(bddNode.rightBranch.leftBranch.name, @"s", nil);
    STAssertEqualObjects(bddNode.rightBranch.leftBranch.leftBranch.name, @"0", nil);
    STAssertEqualObjects(bddNode.rightBranch.leftBranch.rightBranch.name, @"1", nil);
    
        
    // NSLog(@"%@", [formula description]);
}




@end
