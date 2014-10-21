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
    XCTAssertFalse(parser.hasErrors, @"%@",input);
    
    NyayaNode *imf = [ast deriveImf:NSIntegerMax];
    NyayaNode *nnf = [imf deriveNnf:NSIntegerMax];
    NyayaNode *cnf = [nnf deriveCnf:NSIntegerMax];
    NyayaNode *dnf = [nnf deriveDnf:NSIntegerMax];
    
    XCTAssertEqualObjects([ast description], [descs objectAtIndex:AST], @"%@",input);
    XCTAssertEqualObjects([imf description], [descs objectAtIndex:IMF], @"%@",input);
    XCTAssertEqualObjects([nnf description], [descs objectAtIndex:NNF], @"%@",input);
    XCTAssertEqualObjects([cnf description], [descs objectAtIndex:CNF], @"%@",input);
    XCTAssertEqualObjects([dnf description], [descs objectAtIndex:DNF], @"%@",input);
    
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
    
    XCTAssertEqualObjects([astTable description],tt, @"%@",input);
    XCTAssertEqualObjects(astTable, imfTable, @"%@",input);
    XCTAssertEqualObjects(astTable, nnfTable, @"%@",input);
    XCTAssertEqualObjects(astTable, cnfTable, @"%@",input);
    XCTAssertEqualObjects(astTable, dnfTable, @"%@",input);
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
        XCTAssertTrue([ast isImplicationFree], @"%@",input);
        XCTAssertTrue([ast isNegationNormalForm], @"%@",input);
        XCTAssertTrue([ast isConjunctiveNormalForm], @"%@",input);
        XCTAssertTrue([ast isDisjunctiveNormalForm], @"%@",input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@",input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@",input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@",input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@",input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@",input);
        XCTAssertTrue([imf isNegationNormalForm], @"%@",input);
        XCTAssertTrue([imf isConjunctiveNormalForm], @"%@",input);
        XCTAssertTrue([imf isDisjunctiveNormalForm], @"%@",input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@",input);
        XCTAssertFalse([imf isNnfTransformationNode], @"%@",input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@",input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@",input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@",input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@",input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@",input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@",input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@",input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@",input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@",input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@",input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@",input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@",input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@",input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@",input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@",input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@",input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@",input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@",input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@",input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@",input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@",input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@",input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@",input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@",input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@",input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@",input);
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
        XCTAssertTrue([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertTrue([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertFalse([imf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
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
        XCTAssertTrue([ast isImplicationFree], @"%@", input);
        XCTAssertTrue([ast isNegationNormalForm], @"%@", input);
        XCTAssertTrue([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertTrue([imf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
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
        XCTAssertTrue([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertTrue([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertFalse([imf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
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
        XCTAssertTrue([ast isImplicationFree], @"%@", input);
        XCTAssertTrue([ast isNegationNormalForm], @"%@", input);
        XCTAssertTrue([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertTrue([imf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
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
        XCTAssertTrue([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertTrue([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertFalse([imf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
    }
    
    // check node relations
    XCTAssertFalse(nnf == cnf);
    XCTAssertFalse(cnf == dnf);
    XCTAssertFalse(dnf == nnf);
    
    XCTAssertEqualObjects([nnf description], [cnf description]);
    XCTAssertEqualObjects([cnf description], [dnf description]);
    XCTAssertEqualObjects([dnf description], [nnf description]);
    
    
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
        XCTAssertFalse([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertTrue([imf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertTrue([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertTrue([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
        
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
        XCTAssertFalse([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertFalse([imf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertTrue([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertTrue([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
    }
    
    // check node relations
    
    XCTAssertFalse(nnf == dnf);
    
    NyayaNode *nal = [nnf valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode *nar = [nnf valueForKeyPath:@"secondNode.secondNode.firstNode"];
    NyayaNode *dal = [dnf valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode *dar = [dnf valueForKeyPath:@"secondNode.secondNode.firstNode"];
    
    XCTAssertTrue(nal == nar);
    XCTAssertTrue(nal == dal);
    XCTAssertTrue(nal == dar);
    XCTAssertTrue(nar == dal);
    XCTAssertTrue(nar == dar);
    XCTAssertTrue(dal == dar);
    
    XCTAssertTrue([nal isEqual: nar]);
    XCTAssertTrue([nal isEqual: dal]);
    XCTAssertTrue([nal isEqual: dar]);
    XCTAssertTrue([nar isEqual: dal]);
    XCTAssertTrue([nar isEqual: dar]);
    XCTAssertTrue([dal isEqual: dar]);
    
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
        XCTAssertFalse([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertTrue([imf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
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
        XCTAssertFalse([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertFalse([imf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
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
        XCTAssertFalse([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertTrue([imf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertTrue([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertTrue([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        // (a ∧ ¬a) ∨ (a ∧ ¬b) ∨ ((b ∧ ¬a) ∨ (b ∧ ¬b))
        XCTAssertFalse([dnf isCnfTransformationNode], @"%@", input);                          //                     ∨
        XCTAssertTrue([[dnf.nodes objectAtIndex:0] isCnfTransformationNode], @"%@", input);   //          ∨                      ∨
        XCTAssertTrue([[dnf.nodes objectAtIndex:1] isCnfTransformationNode], @"%@", input);   // (a ∧ ¬a)   (a ∧ ¬b)    (b ∧ ¬a)   (b ∧ ¬b)
        
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
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
        XCTAssertFalse([ast isImplicationFree], @"%@", input);
        XCTAssertFalse([ast isNegationNormalForm], @"%@", input);
        XCTAssertFalse([ast isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([ast isImfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([ast isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([imf isImplicationFree], @"%@", input);
        XCTAssertFalse([imf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([imf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([imf isImfTransformationNode], @"%@", input);
        XCTAssertTrue([imf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([imf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([nnf isImplicationFree], @"%@", input);
        XCTAssertTrue([nnf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([nnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([nnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([nnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isNnfTransformationNode], @"%@", input);
        XCTAssertTrue([nnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([nnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([cnf isImplicationFree], @"%@", input);
        XCTAssertTrue([cnf isNegationNormalForm], @"%@", input);
        XCTAssertTrue([cnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([cnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isNnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([cnf isDnfTransformationNode], @"%@", input);
        
        XCTAssertTrue([dnf isImplicationFree], @"%@", input);
        XCTAssertTrue([dnf isNegationNormalForm], @"%@", input);
        XCTAssertFalse([dnf isConjunctiveNormalForm], @"%@", input);
        XCTAssertTrue([dnf isDisjunctiveNormalForm], @"%@", input);
        XCTAssertFalse([dnf isImfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isNnfTransformationNode], @"%@", input);
        XCTAssertTrue([dnf isCnfTransformationNode], @"%@", input);
        XCTAssertFalse([dnf isDnfTransformationNode], @"%@", input);
    }
    
}

@end
