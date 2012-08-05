//
//  BasicNormalFormTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BasicNormalFormTests.h"
#import "NyayaNode.h"
#import "NyayaParser.h"
#import "NyayaTruthTable.h"

@implementation BasicNormalFormTests

- (void)testBicondition {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a↔b"];
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast imf];
    
    STAssertEqualObjects([ast description], @"a ↔ b", nil);
    STAssertEqualObjects([imf description], @"(¬a ∨ b) ∧ (¬b ∨ a)", nil);
    
    NyayaTruthTable *astTable = [[NyayaTruthTable alloc] initWithFormula:ast];
    NyayaTruthTable *imfTable = [[NyayaTruthTable alloc] initWithFormula:imf];
    [astTable evaluateTable];
    [imfTable evaluateTable];
    STAssertEqualObjects(astTable, imfTable, nil);
}

- (void)testImplication {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a→b"];
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast imf];
    
    STAssertEqualObjects([ast description], @"a → b", nil);
    STAssertEqualObjects([imf description], @"¬a ∨ b", nil);
    
    NyayaTruthTable *astTable = [[NyayaTruthTable alloc] initWithFormula:ast];
    NyayaTruthTable *imfTable = [[NyayaTruthTable alloc] initWithFormula:imf];
    [astTable evaluateTable];
    [imfTable evaluateTable];
    STAssertEqualObjects(astTable, imfTable, nil);
}

- (void)testXdisjunction {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a⊻b"];
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertEqualObjects([ast description], @"a ⊻ b", nil);
    STAssertEqualObjects([imf description], @"(a ∨ b) ∧ (¬a ∨ ¬b)", nil);
    STAssertEqualObjects([nnf description], @"(a ∨ b) ∧ (¬a ∨ ¬b)", nil);
    STAssertEqualObjects([cnf description], @"(a ∨ b) ∧ (¬a ∨ ¬b)", nil);
    STAssertEqualObjects([dnf description], @"(a ∧ ¬a) ∨ (a ∧ ¬b) ∨ ((b ∧ ¬a) ∨ (b ∧ ¬b))", nil);
    
    NyayaTruthTable *astTable = [[NyayaTruthTable alloc] initWithFormula:ast];
    NyayaTruthTable *imfTable = [[NyayaTruthTable alloc] initWithFormula:imf];
    NyayaTruthTable *nnfTable = [[NyayaTruthTable alloc] initWithFormula:nnf];
    NyayaTruthTable *cnfTable = [[NyayaTruthTable alloc] initWithFormula:cnf];
    NyayaTruthTable *dnfTable = [[NyayaTruthTable alloc] initWithFormula:dnf];
    
    [astTable evaluateTable];
    [imfTable evaluateTable];
    [nnfTable evaluateTable];
    [cnfTable evaluateTable];
    [dnfTable evaluateTable];
    
    NSString *tt = @""
    "| a | b | a ⊻ b |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    
    STAssertEqualObjects([astTable description],tt, nil);
    STAssertEqualObjects(astTable, imfTable, nil);
    STAssertEqualObjects(astTable, nnfTable, nil);
    STAssertEqualObjects(astTable, cnfTable, nil);
    STAssertEqualObjects(astTable, dnfTable, nil);
}

- (void)testNotXor {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!(a⊻b)"];
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertEqualObjects([ast description], @"¬(a ⊻ b)", nil);
    STAssertEqualObjects([imf description], @"¬((a ∨ b) ∧ (¬a ∨ ¬b))", nil);
    STAssertEqualObjects([nnf description], @"(¬a ∧ ¬b) ∨ (a ∧ b)", nil);
    STAssertEqualObjects([cnf description], @"(¬a ∨ a) ∧ (¬a ∨ b) ∧ ((¬b ∨ a) ∧ (¬b ∨ b))", nil);
    STAssertEqualObjects([dnf description], @"(¬a ∧ ¬b) ∨ (a ∧ b)", nil);
    
    NyayaTruthTable *astTable = [[NyayaTruthTable alloc] initWithFormula:ast];
    NyayaTruthTable *imfTable = [[NyayaTruthTable alloc] initWithFormula:imf];
    NyayaTruthTable *nnfTable = [[NyayaTruthTable alloc] initWithFormula:nnf];
    NyayaTruthTable *cnfTable = [[NyayaTruthTable alloc] initWithFormula:cnf];
    NyayaTruthTable *dnfTable = [[NyayaTruthTable alloc] initWithFormula:dnf];
    
    [astTable evaluateTable];
    [imfTable evaluateTable];
    [nnfTable evaluateTable];
    [cnfTable evaluateTable];
    [dnfTable evaluateTable];
    
    NSString *tt = @""
    "| a | b | a ⊻ b | ¬(a ⊻ b) |\n"
    "| F | F | F     | T        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | T     | F        |\n"
    "| T | T | F     | T        |";
    
    STAssertEqualObjects([astTable description],tt, nil);
    STAssertEqualObjects(astTable, imfTable, nil);
    STAssertEqualObjects(astTable, nnfTable, nil);
    STAssertEqualObjects(astTable, cnfTable, nil);
    STAssertEqualObjects(astTable, dnfTable, nil);
}

@end
