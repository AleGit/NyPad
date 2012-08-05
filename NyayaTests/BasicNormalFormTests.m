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
    
    STAssertFalse([ast isImfFormula], nil);
    STAssertTrue([ast isImfTransformationNode], nil);
    
    STAssertFalse([ast isNnfFormula], nil);
    STAssertFalse([ast isNnfTransformationNode], nil);
    
    STAssertFalse([ast isCnfFormula], nil);
    STAssertFalse([ast isCnfTransformationNode], nil);
    
    STAssertFalse([ast isDnfFormula], nil);
    STAssertFalse([ast isDnfTransformationNode], nil);
    
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];

    STAssertEqualObjects([ast description], @"a ↔ b", nil);
    STAssertEqualObjects([imf description], @"(¬a ∨ b) ∧ (¬b ∨ a)", nil);
    STAssertEqualObjects([nnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)", nil);
    STAssertEqualObjects([cnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)", nil);
    STAssertEqualObjects([dnf description], @"(¬a ∧ ¬b) ∨ (¬a ∧ a) ∨ ((b ∧ ¬b) ∨ (b ∧ a))", nil);
    
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
    "| a | b | a ↔ b |\n"
    "| F | F | T     |\n"
    "| F | T | F     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    STAssertEqualObjects([astTable description],tt, nil);
    STAssertEqualObjects(astTable, imfTable, nil);
    STAssertEqualObjects(astTable, nnfTable, nil);
    STAssertEqualObjects(astTable, cnfTable, nil);
    STAssertEqualObjects(astTable, dnfTable, nil);
}

- (void)testNotBic {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"¬(a↔b)"];
    NyayaNode *ast = [parser parseFormula];
    
    STAssertFalse([ast isImfFormula], nil);
    STAssertFalse([ast isImfTransformationNode], nil);
    
    STAssertFalse([ast isNnfFormula], nil);
    STAssertFalse([ast isNnfTransformationNode], nil);
    
    STAssertFalse([ast isCnfFormula], nil);
    STAssertFalse([ast isCnfTransformationNode], nil);
    
    STAssertFalse([ast isDnfFormula], nil);
    STAssertFalse([ast isDnfTransformationNode], nil);
    
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertEqualObjects([ast description], @"¬(a ↔ b)", nil);
    STAssertEqualObjects([imf description], @"¬((¬a ∨ b) ∧ (¬b ∨ a))", nil);
    STAssertEqualObjects([nnf description], @"(a ∧ ¬b) ∨ (b ∧ ¬a)", nil);
    STAssertEqualObjects([cnf description], @"(a ∨ b) ∧ (a ∨ ¬a) ∧ ((¬b ∨ b) ∧ (¬b ∨ ¬a))", nil);
    STAssertEqualObjects([dnf description], @"(a ∧ ¬b) ∨ (b ∧ ¬a)", nil);
    
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
    "| a | b | a ↔ b | ¬(a ↔ b) |\n"
    "| F | F | T     | F        |\n"
    "| F | T | F     | T        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    STAssertEqualObjects([astTable description],tt, nil);
    STAssertEqualObjects(astTable, imfTable, nil);
    STAssertEqualObjects(astTable, nnfTable, nil);
    STAssertEqualObjects(astTable, cnfTable, nil);
    STAssertEqualObjects(astTable, dnfTable, nil);
}

- (void)testImplication {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a→b"];
    NyayaNode *ast = [parser parseFormula];
    
    STAssertFalse([ast isImfFormula], nil);
    STAssertTrue([ast isImfTransformationNode], nil);
    
    STAssertFalse([ast isNnfFormula], nil);
    STAssertFalse([ast isNnfTransformationNode], nil);
    
    STAssertFalse([ast isCnfFormula], nil);
    STAssertFalse([ast isCnfTransformationNode], nil);
    
    STAssertFalse([ast isDnfFormula], nil);
    STAssertFalse([ast isDnfTransformationNode], nil);
    
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertEqualObjects([ast description], @"a → b", nil);
    STAssertEqualObjects([imf description], @"¬a ∨ b", nil);
    STAssertEqualObjects([nnf description], @"¬a ∨ b", nil);
    STAssertEqualObjects([cnf description], @"¬a ∨ b", nil);
    STAssertEqualObjects([dnf description], @"¬a ∨ b", nil);
    
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
    "| a | b | a → b |\n"
    "| F | F | T     |\n"
    "| F | T | T     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    STAssertEqualObjects([astTable description],tt, nil);
    STAssertEqualObjects(astTable, imfTable, nil);
    STAssertEqualObjects(astTable, nnfTable, nil);
    STAssertEqualObjects(astTable, cnfTable, nil);
    STAssertEqualObjects(astTable, dnfTable, nil);
}

- (void)testNotImp {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!(a→b)"];
    NyayaNode *ast = [parser parseFormula];
    
    STAssertFalse([ast isImfFormula], nil);
    STAssertFalse([ast isImfTransformationNode], nil);
    
    STAssertFalse([ast isNnfFormula], nil);
    STAssertFalse([ast isNnfTransformationNode], nil);
    
    STAssertFalse([ast isCnfFormula], nil);
    STAssertFalse([ast isCnfTransformationNode], nil);
    
    STAssertFalse([ast isDnfFormula], nil);
    STAssertFalse([ast isDnfTransformationNode], nil);
    
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertEqualObjects([ast description], @"¬(a → b)", nil);
    STAssertEqualObjects([imf description], @"¬(¬a ∨ b)", nil);
    STAssertEqualObjects([nnf description], @"a ∧ ¬b", nil);
    STAssertEqualObjects([cnf description], @"a ∧ ¬b", nil);
    STAssertEqualObjects([dnf description], @"a ∧ ¬b", nil);
    
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
    "| a | b | a → b | ¬(a → b) |\n"
    "| F | F | T     | F        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    STAssertEqualObjects([astTable description],tt, nil);
    STAssertEqualObjects(astTable, imfTable, nil);
    STAssertEqualObjects(astTable, nnfTable, nil);
    STAssertEqualObjects(astTable, cnfTable, nil);
    STAssertEqualObjects(astTable, dnfTable, nil);
}



- (void)testXor {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a⊻b"];
    NyayaNode *ast = [parser parseFormula];
    
    STAssertFalse([ast isImfFormula], nil);
    STAssertTrue([ast isImfTransformationNode], nil);
    
    STAssertFalse([ast isNnfFormula], nil);
    STAssertFalse([ast isNnfTransformationNode], nil);
    
    STAssertFalse([ast isCnfFormula], nil);
    STAssertFalse([ast isCnfTransformationNode], nil);
    
    STAssertFalse([ast isDnfFormula], nil);
    STAssertFalse([ast isDnfTransformationNode], nil);
    
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertFalse([dnf isCnfFormula], nil);
    STAssertFalse([cnf isDnfFormula], nil);
    
    STAssertTrue([cnf isCnfFormula], nil);
    STAssertTrue([dnf isDnfFormula], nil);
    STAssertTrue([cnf isNnfFormula], nil);
    STAssertTrue([dnf isNnfFormula], nil);
    STAssertTrue([cnf isImfFormula], nil);
    STAssertTrue([dnf isImfFormula], nil);
    
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
    
    STAssertFalse([ast isImfFormula], nil);
    STAssertFalse([ast isImfTransformationNode], nil);
    
    STAssertFalse([ast isNnfFormula], nil);
    STAssertFalse([ast isNnfTransformationNode], nil);
    
    STAssertFalse([ast isCnfFormula], nil);
    STAssertFalse([ast isCnfTransformationNode], nil);
    
    STAssertFalse([ast isDnfFormula], nil);
    STAssertFalse([ast isDnfTransformationNode], nil);
    
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertFalse([dnf isCnfFormula], nil);
    STAssertFalse([cnf isDnfFormula], nil);
    
    STAssertTrue([cnf isCnfFormula], nil);
    STAssertTrue([dnf isDnfFormula], nil);
    STAssertTrue([cnf isNnfFormula], nil);
    STAssertTrue([dnf isNnfFormula], nil);
    STAssertTrue([cnf isImfFormula], nil);
    STAssertTrue([dnf isImfFormula], nil);
    
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
