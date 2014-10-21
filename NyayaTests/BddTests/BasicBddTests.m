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
    
    XCTAssertEqual(sum, (NSUInteger)45);
    
    
    
}

- (void)testTautology {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a | (!a and b) | !b"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    
    XCTAssertTrue(node.isLeaf);
    XCTAssertEqual(node.id, 1);
    
//    STAssertEqualObjects(node.CNF.description, @"1", nil);
//    STAssertEqualObjects([node dnfDescription], @"1", nil);
}

- (void)testContradiction {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a & (!a or b) & !b"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    XCTAssertTrue(node.isLeaf);
    XCTAssertEqual(node.id, 0);
    
    
    XCTAssertEqualObjects(node.cnfDescription, @"F");
//    STAssertEqualObjects([node dnfDescription], @"0", nil);
}


- (void)testOr {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a | b)|(a|b)&(a|b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    XCTAssertTrue([node isMemberOfClass:[BddNode class]]);
    XCTAssertEqual(node.id, 3);
    XCTAssertEqualObjects(node.name, @"a");
    
    XCTAssertEqual(node.leftBranch.id, 2);
    XCTAssertEqualObjects(node.leftBranch.name, @"b");
    XCTAssertEqual(node.leftBranch.leftBranch.id, 0);
    XCTAssertEqual(node.leftBranch.rightBranch.id, 1);
    
    XCTAssertEqual(node.rightBranch.id, 1);
    
    XCTAssertEqualObjects(node.cnfDescription, @"(a ∨ b)");
//    STAssertEqualObjects([node dnfDescription], @"(a) ∨ (¬a ∧ b)", nil);
}

- (void)testAnd {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a & b)&(a & b)|(a & b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    XCTAssertTrue([node isMemberOfClass:[BddNode class]]);
    XCTAssertEqual(node.id, 3);
    XCTAssertEqualObjects(node.name, @"a");
    
    XCTAssertEqual(node.rightBranch.id, 2);
    XCTAssertEqualObjects(node.rightBranch.name, @"b");
    XCTAssertEqual(node.rightBranch.leftBranch.id, 0);
    XCTAssertEqual(node.rightBranch.rightBranch.id, 1);
    
    XCTAssertEqual(node.leftBranch.id, 0);
    
    XCTAssertEqualObjects([node cnfDescription], @"(a ∧ b)");
    XCTAssertEqualObjects([node dnfDescription], @"(a ∧ b)");
}

- (void)testXor {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a ^ b)|(a ^ b)&(a ^ b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    XCTAssertEqual(node.id, 4);
    XCTAssertEqual(node.rightBranch.id, 3);
    XCTAssertEqual(node.leftBranch.id, 2);
    XCTAssertEqual(node.leftBranch.rightBranch.id, 1);   
    XCTAssertEqual(node.rightBranch.leftBranch.id, 1);
    XCTAssertEqual(node.leftBranch.leftBranch.id, 0);
    XCTAssertEqual(node.rightBranch.rightBranch.id, 0);
    
    XCTAssertEqualObjects(node.name, @"a");
    XCTAssertEqualObjects(node.leftBranch.name, @"b");
    XCTAssertEqualObjects(node.rightBranch.name, @"b");
    
    XCTAssertEqualObjects(node.cnfDescription, @"(a ∨ b) ∧ (¬a ∨ ¬b)");
    XCTAssertEqualObjects([node dnfDescription], @"(a ∧ ¬b) ∨ (¬a ∧ b)");
    
}

- (void)testAorBandC {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a|b&c)&(a|b&c)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode bddWithTruthTable:truthTable reduce:YES];
    XCTAssertEqual(node.id, 4);
    XCTAssertEqualObjects(node.name, @"a");
    XCTAssertEqual(node.leftBranch.id, 3);
    XCTAssertEqualObjects(node.leftBranch.name, @"b");
    XCTAssertEqual(node.leftBranch.rightBranch.id, 2);
    XCTAssertEqualObjects(node.leftBranch.rightBranch.name, @"c");
    
    XCTAssertEqual(node.rightBranch.id, 1);
    XCTAssertEqual(node.leftBranch.rightBranch.rightBranch.id, 1);
    
    XCTAssertEqual(node.leftBranch.leftBranch.id, 0);
    XCTAssertEqual(node.leftBranch.rightBranch.leftBranch.id, 0);
    
    XCTAssertEqualObjects(node.cnfDescription, @"(a ∨ ¬b ∨ c) ∧ (a ∨ b)");
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
    
    XCTAssertEqualObjects(bdd.name, @"a");
    
    XCTAssertEqualObjects(a0.name, @"b");
    XCTAssertEqualObjects(a1.name, @"1");
    
    XCTAssertEqualObjects(b0.name, @"0");
    XCTAssertEqualObjects(b1.name, @"c");
    
    XCTAssertEqualObjects(c0.name, @"0");
    XCTAssertEqualObjects(c1.name, @"1");
    
    XCTAssertEqual(a1, c1);
    XCTAssertEqual(b0, c0);
}

- (void)testAxorBReduced {
    NSArray *variables = @[[NyayaNode atom:@"a"], [NyayaNode atom:@"b"]];
    NyayaNode *node = [NyayaNode xdisjunction:variables[0] with:variables[1]];
    // a ^ b
    
    BddNode *bdd = [BddNode obddWithNode:node order:variables reduce:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [bdd fillStructure:dict];
    XCTAssertEqual([dict count], (NSUInteger)4);
    
    XCTAssertEqualObjects(bdd.name, @"a");
    //     a
    //    . \
    //   b   b
    //   | x |
    //   1   0
    
    BddNode *a0 = bdd.leftBranch;
    BddNode *a1 = bdd.rightBranch;
    XCTAssertEqualObjects(a0.name, @"b");
    XCTAssertEqualObjects(a1.name, @"b");
    
    BddNode *a0b1 = a0.rightBranch;
    BddNode *a1b0 = a1.leftBranch;
    XCTAssertEqualObjects(a0b1.name, @"1");
    XCTAssertEqualObjects(a1b0.name, @"1");
    XCTAssertEqual(a0b1, a1b0);
    
}

- (void)testXorReduced {
    NSArray *variables = @[[NyayaNode atom:@"a"], [NyayaNode atom:@"b"], [NyayaNode atom:@"c"]];
    
    
    
    
    NyayaNode *node = [NyayaNode xdisjunction:variables[0] with:[NyayaNode xdisjunction:variables[1] with:variables[2]]];
    // a ^ (b ^ c)
    
    BddNode *bdd = [BddNode obddWithNode:node order:variables reduce:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [bdd fillStructure:dict];
    XCTAssertEqual([dict count], (NSUInteger)5);
    
    XCTAssertEqualObjects(bdd.name, @"a");
    //     a
    //    . \
    //   b   b
    //   | x |
    //   c   c
    //   | x |
    //   0   1
    
    BddNode *a0 = bdd.leftBranch;
    BddNode *a1 = bdd.rightBranch;
    XCTAssertEqualObjects(a0.name, @"b");
    XCTAssertEqualObjects(a1.name, @"b");
    
    BddNode *a0b1 = a0.rightBranch;
    BddNode *a1b0 = a1.leftBranch;
    XCTAssertEqual(a0b1, a1b0);
    
    BddNode *a1b1 = a1.rightBranch;
    BddNode *a0b0 = a0.leftBranch;
    XCTAssertEqual(a1b1, a0b0);

}

- (void)testObbd {
    NSArray *variables = @[[NyayaNode atom:@"a"], [NyayaNode atom:@"b"], [NyayaNode atom:@"c"]];
    
    
    
    
    NyayaNode *node = [NyayaNode disjunction:variables[0] with:[NyayaNode conjunction:variables[1] with:variables[2]]];
    // a + b.c
    
    BddNode *bdd = [BddNode obddWithNode:node order:variables reduce:NO];
    XCTAssertEqual([bdd.names count], (NSUInteger)3);
    [variables enumerateObjectsUsingBlock:^(NyayaNode *obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqualObjects(obj.symbol, bdd.names[idx]);
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [bdd fillStructure:dict];
    XCTAssertEqual([dict count], (NSUInteger)5);
    
    
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
    
    XCTAssertEqual(bdd.id, 14);
    
    XCTAssertEqual(a0.id, 6);
    XCTAssertEqual(a1.id, 13);
    
    XCTAssertEqual(a00.id, 2);
    XCTAssertEqual(a01.id, 5);
    XCTAssertEqual(a10.id, 9);
    XCTAssertEqual(a11.id, 12);
    
    XCTAssertEqual(a000.id, 0);
    XCTAssertEqual(a001.id, 1);
    XCTAssertEqual(a010.id, 3);
    XCTAssertEqual(a011.id, 4);
    XCTAssertEqual(a100.id, 7);
    XCTAssertEqual(a101.id, 8);
    XCTAssertEqual(a110.id, 10);
    XCTAssertEqual(a111.id, 11);
   
        
    XCTAssertEqualObjects(bdd.name, @"a");
    
    XCTAssertEqualObjects(a0.name, @"b");
    XCTAssertEqualObjects(a1.name, @"b");
    
    XCTAssertEqualObjects(a00.name, @"c");
    XCTAssertEqualObjects(a01.name, @"c");
    XCTAssertEqualObjects(a00.name, @"c");
    XCTAssertEqualObjects(a01.name, @"c");
    
    XCTAssertEqualObjects(a000.name, @"0");
    XCTAssertEqualObjects(a001.name, @"0");
    XCTAssertEqualObjects(a010.name, @"0");
    XCTAssertEqualObjects(a011.name, @"1");
    XCTAssertEqualObjects(a100.name, @"1");
    XCTAssertEqualObjects(a101.name, @"1");
    XCTAssertEqualObjects(a110.name, @"1");
    XCTAssertEqualObjects(a111.name, @"1");
}


- (void)testIssue_20130420_1 {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"p&q^r&s"];
    NyayaNode *node = [parser parseFormula];
    
    NSArray *variables = [node.setOfVariables allObjects];
    NyayaNodeVariable *r = [variables objectAtIndex:0];
    NyayaNodeVariable *p = [variables objectAtIndex:1];
    NyayaNodeVariable *s = [variables objectAtIndex:2];
    NyayaNodeVariable *q = [variables objectAtIndex:3];
    
    XCTAssertEqualObjects(r.symbol, @"r", @"r");
    XCTAssertEqualObjects(p.symbol, @"p", @"p");
    XCTAssertEqualObjects(s.symbol, @"s", @"s");
    XCTAssertEqualObjects(q.symbol, @"q", @"q");
    BddNode *bddNode = [BddNode obddWithNode:node order:variables reduce:YES];
    

    XCTAssertEqualObjects(bddNode.name, r.symbol);
    XCTAssertEqualObjects(bddNode.leftBranch.name, @"p");
    XCTAssertEqualObjects(bddNode.leftBranch.leftBranch.name, @"0");
    XCTAssertEqualObjects(bddNode.leftBranch.rightBranch.name, @"q");
    XCTAssertEqualObjects(bddNode.leftBranch.rightBranch.leftBranch.name, @"0");
    XCTAssertEqualObjects(bddNode.leftBranch.rightBranch.rightBranch.name, @"1");
    
    
    XCTAssertEqualObjects(bddNode.rightBranch.rightBranch.name, @"s");
    XCTAssertEqualObjects(bddNode.rightBranch.rightBranch.leftBranch.name, @"q");
    XCTAssertEqualObjects(bddNode.rightBranch.rightBranch.leftBranch.leftBranch.name, @"0");
    XCTAssertEqualObjects(bddNode.rightBranch.rightBranch.leftBranch.rightBranch.name, @"1");
    XCTAssertEqualObjects(bddNode.rightBranch.rightBranch.rightBranch.name, @"q");
    XCTAssertEqualObjects(bddNode.rightBranch.rightBranch.rightBranch.leftBranch.name, @"1");
    XCTAssertEqualObjects(bddNode.rightBranch.rightBranch.rightBranch.rightBranch.name, @"0");


    XCTAssertEqualObjects(bddNode.rightBranch.leftBranch.name, @"s");
    XCTAssertEqualObjects(bddNode.rightBranch.leftBranch.leftBranch.name, @"0");
    XCTAssertEqualObjects(bddNode.rightBranch.leftBranch.rightBranch.name, @"1");
    
        
    // NSLog(@"%@", [formula description]);
}




@end
