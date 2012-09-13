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
#import "TruthTable.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Attributes.h"

enum { AST, IMF, NNF, CNF, DNF };

@implementation BasicNormalFormTests

- (NSArray*)assert:(NSString*)input descriptions:(NSArray*)descs truthTable:(NSString*)tt {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
    NyayaNode *ast = [parser parseFormula];
    STAssertFalse(parser.hasErrors, input);
    
    NyayaNode *imf = [ast deriveImf:NSIntegerMax];
    NyayaNode *nnf = [imf deriveNnf:NSIntegerMax];
    NyayaNode *cnf = [nnf deriveCnf:NSIntegerMax];
    NyayaNode *dnf = [nnf deriveDnf:NSIntegerMax];
    
    STAssertEqualObjects([ast description], [descs objectAtIndex:AST], input);
    STAssertEqualObjects([imf description], [descs objectAtIndex:IMF], input);
    STAssertEqualObjects([nnf description], [descs objectAtIndex:NNF], input);
    STAssertEqualObjects([cnf description], [descs objectAtIndex:CNF], input);
    STAssertEqualObjects([dnf description], [descs objectAtIndex:DNF], input);
    
    TruthTable *astTable = [[TruthTable alloc] initWithNode:[ast copy] compact:NO];
    TruthTable *imfTable = [[TruthTable alloc] initWithNode:[imf copy] compact:NO];
    TruthTable *nnfTable = [[TruthTable alloc] initWithNode:[nnf copy] compact:NO];
    TruthTable *cnfTable = [[TruthTable alloc] initWithNode:[cnf copy] compact:NO];
    TruthTable *dnfTable = [[TruthTable alloc] initWithNode:[dnf copy] compact:NO];
    
    [astTable evaluateTable];
    [imfTable evaluateTable];
    [nnfTable evaluateTable];
    [cnfTable evaluateTable];
    [dnfTable evaluateTable];
    
    STAssertEqualObjects([astTable description],tt, input);
    STAssertEqualObjects(astTable, imfTable, input);
    STAssertEqualObjects(astTable, nnfTable, input);
    STAssertEqualObjects(astTable, cnfTable, input);
    STAssertEqualObjects(astTable, dnfTable, input);
    return @[ast, imf, nnf, cnf, dnf];
}

- (void)testNot {
    NSString *input = @"!a";
    
    NSString *tt = @""
    "| a | ¬a |\n"
    "| F | T  |\n"
    "| T | F  |";
    
    NSArray *descs = @[
    @"¬a",
    @"¬a",
    @"¬a",
    @"¬a",
    @"¬a"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertTrue([ast isImplicationFree], input);
        STAssertTrue([ast isNegationNormalForm], input);
        STAssertTrue([ast isConjunctiveNormalForm], input);
        STAssertTrue([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertTrue([imf isNegationNormalForm], input);
        STAssertTrue([imf isConjunctiveNormalForm], input);
        STAssertTrue([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
}

- (void)testNotNot {
    NSString *input = @"!!a";
    
    NSString *tt = @""
    "| a | ¬a | ¬¬a |\n"
    "| F | T  | F   |\n"
    "| T | F  | T   |";
    
    NSArray *descs = @[
    @"¬¬a",
    @"¬¬a",
    @"a",
    @"a",
    @"a"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertTrue([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertTrue([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertFalse([imf isNegationNormalForm], input);
        STAssertFalse([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
}

- (void)testAnd {
    NSString *input = @"a & b";
    
    NSString *tt = @""
    "| a | b | a ∧ b |\n"
    "| F | F | F     |\n"
    "| F | T | F     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    NSArray *descs = @[
    @"a ∧ b",
    @"a ∧ b",
    @"a ∧ b",
    @"a ∧ b",
    @"a ∧ b"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertTrue([ast isImplicationFree], input);
        STAssertTrue([ast isNegationNormalForm], input);
        STAssertTrue([ast isConjunctiveNormalForm], input);
        STAssertTrue([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertTrue([imf isNegationNormalForm], input);
        STAssertTrue([imf isConjunctiveNormalForm], input);
        STAssertTrue([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
}

- (void)testNotAnd {
    NSString *input = @"!(a & b)";
    
    NSString *tt = @""
    "| a | b | a ∧ b | ¬(a ∧ b) |\n"
    "| F | F | F     | T        |\n"
    "| F | T | F     | T        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    NSArray *descs = @[
    @"¬(a ∧ b)",
    @"¬(a ∧ b)",
    @"¬a ∨ ¬b",
    @"¬a ∨ ¬b",
    @"¬a ∨ ¬b"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertTrue([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertTrue([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertFalse([imf isNegationNormalForm], input);
        STAssertFalse([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
}

- (void)testOr {
    NSString *input = @"a | b";
    
    NSString *tt = @""
    "| a | b | a ∨ b |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | T     |";
    
    NSArray *descs = @[
    @"a ∨ b",
    @"a ∨ b",
    @"a ∨ b",
    @"a ∨ b",
    @"a ∨ b"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertTrue([ast isImplicationFree], input);
        STAssertTrue([ast isNegationNormalForm], input);
        STAssertTrue([ast isConjunctiveNormalForm], input);
        STAssertTrue([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertTrue([imf isNegationNormalForm], input);
        STAssertTrue([imf isConjunctiveNormalForm], input);
        STAssertTrue([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
}

- (void)testNotOr {
    NSString *input = @"!(a | b)";
    
    NSString *tt = @""
    "| a | b | a ∨ b | ¬(a ∨ b) |\n"
    "| F | F | F     | T        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | T     | F        |\n"
    "| T | T | T     | F        |";
    
    NSArray *descs = @[
    @"¬(a ∨ b)",
    @"¬(a ∨ b)",
    @"¬a ∧ ¬b",
    @"¬a ∧ ¬b",
    @"¬a ∧ ¬b"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertTrue([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertTrue([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertFalse([imf isNegationNormalForm], input);
        STAssertFalse([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
    // check node relations
    STAssertFalse(nnf == cnf, nil);
    STAssertFalse(cnf == dnf, nil);
    STAssertFalse(dnf == nnf, nil);
    
    STAssertEqualObjects([nnf description], [cnf description], nil);
    STAssertEqualObjects([cnf description], [dnf description], nil);
    STAssertEqualObjects([dnf description], [nnf description], nil);
    
    
}

- (void)testBic {
    NSString *input = @"a <> b";
    
    NSString *tt = @""
    "| a | b | a ↔ b |\n"
    "| F | F | T     |\n"
    "| F | T | F     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    NSArray *descs = @[
    @"a ↔ b",
    @"(¬a ∨ b) ∧ (¬b ∨ a)",
    @"(¬a ∨ b) ∧ (¬b ∨ a)",
    @"(¬a ∨ b) ∧ (¬b ∨ a)",
    @"(¬a ∧ ¬b) ∨ (¬a ∧ a) ∨ ((b ∧ ¬b) ∨ (b ∧ a))"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertFalse([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertTrue([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertTrue([imf isNegationNormalForm], input);
        STAssertTrue([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertTrue([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertFalse([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertTrue([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertFalse([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertTrue([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertFalse([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
        
    }
}

- (void)testNotBic {
    NSString *input = @"!(a<>b)";
    
    NSString *tt = @""
    "| a | b | a ↔ b | ¬(a ↔ b) |\n"
    "| F | F | T     | F        |\n"
    "| F | T | F     | T        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    NSArray *descs = @[
    @"¬(a ↔ b)",
    @"¬((¬a ∨ b) ∧ (¬b ∨ a))",
    @"(a ∧ ¬b) ∨ (b ∧ ¬a)",
    @"(a ∨ b) ∧ (a ∨ ¬a) ∧ ((¬b ∨ b) ∧ (¬b ∨ ¬a))",
    @"(a ∧ ¬b) ∨ (b ∧ ¬a)"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    {
        STAssertFalse([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertFalse([imf isNegationNormalForm], input);
        STAssertFalse([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertFalse([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertTrue([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertFalse([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertFalse([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertTrue([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
    // check node relations
    
    STAssertFalse(nnf == dnf, nil);
    
    NyayaNode *nal = [nnf valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode *nar = [nnf valueForKeyPath:@"secondNode.secondNode.firstNode"];
    NyayaNode *dal = [dnf valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode *dar = [dnf valueForKeyPath:@"secondNode.secondNode.firstNode"];
    
    STAssertTrue(nal == nar, nil);
    STAssertTrue(nal == dal, nil);
    STAssertTrue(nal == dar, nil);
    STAssertTrue(nar == dal, nil);
    STAssertTrue(nar == dar, nil);
    STAssertTrue(dal == dar, nil);
    
    STAssertTrue([nal isEqual: nar], nil);
    STAssertTrue([nal isEqual: dal], nil);
    STAssertTrue([nal isEqual: dar], nil);
    STAssertTrue([nar isEqual: dal], nil);
    STAssertTrue([nar isEqual: dar], nil);
    STAssertTrue([dal isEqual: dar], nil);
    
}

- (void)testImp {
    NSString *input = @"a > b";
    
    NSString *tt = @""
    "| a | b | a → b |\n"
    "| F | F | T     |\n"
    "| F | T | T     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    NSArray *descs = @[
    @"a → b",
    @"¬a ∨ b",
    @"¬a ∨ b",
    @"¬a ∨ b",
    @"¬a ∨ b"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertFalse([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertTrue([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertTrue([imf isNegationNormalForm], input);
        STAssertTrue([imf isConjunctiveNormalForm], input);
        STAssertTrue([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
}

- (void)testNotImp {
    NSString *input = @"!(a>b)";
    
    NSString *tt = @""
    "| a | b | a → b | ¬(a → b) |\n"
    "| F | F | T     | F        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    NSArray *descs = @[
    @"¬(a → b)",
    @"¬(¬a ∨ b)",
    @"a ∧ ¬b",
    @"a ∧ ¬b",
    @"a ∧ ¬b"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertFalse([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertFalse([imf isNegationNormalForm], input);
        STAssertFalse([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertTrue([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertTrue([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
}

- (void)testXor {
    NSString *input = @"a^b";
    
    NSString *tt = @""
    "| a | b | a ⊻ b |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    
    NSArray *descs = @[
    @"a ⊻ b",
    @"(a ∨ b) ∧ (¬a ∨ ¬b)",
    @"(a ∨ b) ∧ (¬a ∨ ¬b)",
    @"(a ∨ b) ∧ (¬a ∨ ¬b)",
    @"(a ∧ ¬a) ∨ (a ∧ ¬b) ∨ ((b ∧ ¬a) ∨ (b ∧ ¬b))"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertFalse([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertTrue([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertTrue([imf isNegationNormalForm], input);
        STAssertTrue([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertTrue([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertTrue([nnf isConjunctiveNormalForm], input);
        STAssertFalse([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertTrue([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertFalse([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertTrue([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertFalse([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        // (a ∧ ¬a) ∨ (a ∧ ¬b) ∨ ((b ∧ ¬a) ∨ (b ∧ ¬b))
        STAssertFalse([dnf isCnfTransformationNode], input);                          //                     ∨
        STAssertTrue([[dnf.nodes objectAtIndex:0] isCnfTransformationNode], input);   //          ∨                      ∨
        STAssertTrue([[dnf.nodes objectAtIndex:1] isCnfTransformationNode], input);   // (a ∧ ¬a)   (a ∧ ¬b)    (b ∧ ¬a)   (b ∧ ¬b)
        
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
}

- (void)testNotXor {
    NSString *input = @"!(a^b)";
    
    NSString *tt = @""
    "| a | b | a ⊻ b | ¬(a ⊻ b) |\n"
    "| F | F | F     | T        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | T     | F        |\n"
    "| T | T | F     | T        |";
    
    NSArray *descs = @[
    @"¬(a ⊻ b)",
    @"¬((a ∨ b) ∧ (¬a ∨ ¬b))",
    @"(¬a ∧ ¬b) ∨ (a ∧ b)",
    @"(¬a ∨ a) ∧ (¬a ∨ b) ∧ ((¬b ∨ a) ∧ (¬b ∨ b))",
    @"(¬a ∧ ¬b) ∨ (a ∧ b)"];
    
    NSArray *frms = [self assert:input descriptions:descs truthTable:tt];
    NyayaNode *ast = [frms objectAtIndex:AST];
    NyayaNode *imf = [frms objectAtIndex:IMF];
    NyayaNode *nnf = [frms objectAtIndex:NNF];
    NyayaNode *cnf = [frms objectAtIndex:CNF];
    NyayaNode *dnf = [frms objectAtIndex:DNF];
    
    // check properties of syntax trees and normal forms
    {
        STAssertFalse([ast isImplicationFree], input);
        STAssertFalse([ast isNegationNormalForm], input);
        STAssertFalse([ast isConjunctiveNormalForm], input);
        STAssertFalse([ast isDisjunctiveNormalForm], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImplicationFree], input);
        STAssertFalse([imf isNegationNormalForm], input);
        STAssertFalse([imf isConjunctiveNormalForm], input);
        STAssertFalse([imf isDisjunctiveNormalForm], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImplicationFree], input);
        STAssertTrue([nnf isNegationNormalForm], input);
        STAssertFalse([nnf isConjunctiveNormalForm], input);
        STAssertTrue([nnf isDisjunctiveNormalForm], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertTrue([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImplicationFree], input);
        STAssertTrue([cnf isNegationNormalForm], input);
        STAssertTrue([cnf isConjunctiveNormalForm], input);
        STAssertFalse([cnf isDisjunctiveNormalForm], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImplicationFree], input);
        STAssertTrue([dnf isNegationNormalForm], input);
        STAssertFalse([dnf isConjunctiveNormalForm], input);
        STAssertTrue([dnf isDisjunctiveNormalForm], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertTrue([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
}

@end
