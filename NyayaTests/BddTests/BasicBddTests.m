//
//  BasicBddTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 06.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BasicBddTests.h"
#include "NyayaParser.h"
#include "NyayaNode.h"
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
    TruthTable *truthTable = [[TruthTable alloc] initWithFormula:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode diagramWithTruthTable:truthTable];
    
    
    STAssertTrue(node.isLeaf,nil);
    STAssertEquals(node.id, 1, nil);
    
    NSLog(@"%@", [formula description]);
    NSLog(@"dnf (%@)", [[node cPaths1] componentsJoinedByString:@") ∨ ("]);
    NSLog(@"cnf (%@)", [[node dPaths0] componentsJoinedByString:@") ∧ ("]);
}

- (void)testContradiction {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a & (!a or b) & !b"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithFormula:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode diagramWithTruthTable:truthTable];
    STAssertTrue(node.isLeaf,nil);
    STAssertEquals(node.id, 0, nil);
    
    
    NSLog(@"%@", [formula description]);
    NSLog(@"dnf (%@)", [[node cPaths1] componentsJoinedByString:@") ∨ ("]);
    NSLog(@"cnf (%@)", [[node dPaths0] componentsJoinedByString:@") ∧ ("]);
}


- (void)testOr {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a | b)|(a|b)&(a|b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithFormula:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode diagramWithTruthTable:truthTable];
    
    STAssertTrue([node isMemberOfClass:[BddNode class]], nil);
    STAssertEquals(node.id, 3, nil);
    STAssertEqualObjects(node.name, @"a", nil);
    
    STAssertEquals(node.leftBranch.id, 2, nil);
    STAssertEqualObjects(node.leftBranch.name, @"b", nil);
    STAssertEquals(node.leftBranch.leftBranch.id, 0, nil);
    STAssertEquals(node.leftBranch.rightBranch.id, 1, nil);
    
    STAssertEquals(node.rightBranch.id, 1, nil);
    
    NSLog(@"%@", [formula description]);
    NSLog(@"dnf (%@)", [[node cPaths1] componentsJoinedByString:@") ∨ ("]);
    NSLog(@"cnf (%@)", [[node dPaths0] componentsJoinedByString:@") ∧ ("]);
}

- (void)testAnd {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a & b)&(a & b)|(a & b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithFormula:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode diagramWithTruthTable:truthTable];
    
    STAssertTrue([node isMemberOfClass:[BddNode class]], nil);
    STAssertEquals(node.id, 3, nil);
    STAssertEqualObjects(node.name, @"a", nil);
    
    STAssertEquals(node.rightBranch.id, 2, nil);
    STAssertEqualObjects(node.rightBranch.name, @"b", nil);
    STAssertEquals(node.rightBranch.leftBranch.id, 0, nil);
    STAssertEquals(node.rightBranch.rightBranch.id, 1, nil);
    
    STAssertEquals(node.leftBranch.id, 0, nil);
    
    NSLog(@"%@", [formula description]);
    NSLog(@"dnf (%@)", [[node cPaths1] componentsJoinedByString:@") ∨ ("]);
    NSLog(@"cnf (%@)", [[node dPaths0] componentsJoinedByString:@") ∧ ("]);
}

- (void)testXor {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a ^ b)|(a ^ b)&(a ^ b)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithFormula:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode diagramWithTruthTable:truthTable];
    
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
    
    
    
    NSLog(@"%@", [formula description]);
    NSLog(@"dnf (%@)", [[node cPaths1] componentsJoinedByString:@") ∨ ("]);
    NSLog(@"cnf (%@)", [[node dPaths0] componentsJoinedByString:@") ∧ ("]);
}

- (void)testAorBandC {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a|b&c)&(a|b&c)"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithFormula:formula];
    [truthTable evaluateTable];
    
    BddNode *node = [BddNode diagramWithTruthTable:truthTable];
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
    
    
    
    NSLog(@"%@", [formula description]);
    NSLog(@"dnf (%@)", [[node cPaths1] componentsJoinedByString:@") ∨ ("]);
    NSLog(@"cnf (%@)", [[node dPaths0] componentsJoinedByString:@") ∧ ("]);
}




@end
