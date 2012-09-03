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

enum { AST, IMF, NNF, CNF, DNF };

@implementation BasicNormalFormTests

- (NSArray*)assert:(NSString*)input descriptions:(NSArray*)descs truthTable:(NSString*)tt {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
    NyayaNode *ast = [parser parseFormula];
    STAssertFalse(parser.hasErrors, input);
    
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertEqualObjects([ast description], [descs objectAtIndex:AST], input);
    STAssertEqualObjects([imf description], [descs objectAtIndex:IMF], input);
    STAssertEqualObjects([nnf description], [descs objectAtIndex:NNF], input);
    STAssertEqualObjects([cnf description], [descs objectAtIndex:CNF], input);
    STAssertEqualObjects([dnf description], [descs objectAtIndex:DNF], input);
    
    TruthTable *astTable = [[TruthTable alloc] initWithFormula:[ast copy] expanded:YES];
    TruthTable *imfTable = [[TruthTable alloc] initWithFormula:[imf copy] expanded:YES];
    TruthTable *nnfTable = [[TruthTable alloc] initWithFormula:[nnf copy] expanded:YES];
    TruthTable *cnfTable = [[TruthTable alloc] initWithFormula:[cnf copy] expanded:YES];
    TruthTable *dnfTable = [[TruthTable alloc] initWithFormula:[dnf copy] expanded:YES];
    
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
        STAssertTrue([ast isImfFormula], input);
        STAssertTrue([ast isNnfFormula], input);
        STAssertTrue([ast isCnfFormula], input);
        STAssertTrue([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertTrue([imf isNnfFormula], input);
        STAssertTrue([imf isCnfFormula], input);
        STAssertTrue([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertTrue([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertTrue([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertFalse([imf isNnfFormula], input);
        STAssertFalse([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertTrue([ast isImfFormula], input);
        STAssertTrue([ast isNnfFormula], input);
        STAssertTrue([ast isCnfFormula], input);
        STAssertTrue([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertTrue([imf isNnfFormula], input);
        STAssertTrue([imf isCnfFormula], input);
        STAssertTrue([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertTrue([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertTrue([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertFalse([imf isNnfFormula], input);
        STAssertFalse([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertTrue([ast isImfFormula], input);
        STAssertTrue([ast isNnfFormula], input);
        STAssertTrue([ast isCnfFormula], input);
        STAssertTrue([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertTrue([imf isNnfFormula], input);
        STAssertTrue([imf isCnfFormula], input);
        STAssertTrue([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertTrue([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertTrue([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertFalse([imf isNnfFormula], input);
        STAssertFalse([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertFalse([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertTrue([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertTrue([imf isNnfFormula], input);
        STAssertTrue([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertTrue([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertFalse([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertTrue([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertFalse([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertTrue([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertFalse([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertFalse([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
        
    }
    
    // check node realtions
    
    STAssertEquals([dnf valueForKeyPath:@"firstNode.parent"], dnf, nil);
    STAssertEquals([dnf valueForKeyPath:@"secondNode.parent"], dnf, nil);
    
    STAssertEquals([dnf valueForKeyPath:@"firstNode.firstNode.parent.parent"], dnf, nil);
    STAssertEquals([dnf valueForKeyPath:@"firstNode.secondNode.parent.parent"], dnf, nil);
    STAssertEquals([dnf valueForKeyPath:@"secondNode.firstNode.parent.parent"], dnf, nil);
    STAssertEquals([dnf valueForKeyPath:@"secondNode.secondNode.parent.parent"], dnf, nil);
    
    STAssertEquals([dnf valueForKeyPath:@"firstNode.firstNode.firstNode.parent.parent.parent"], dnf, nil);
    STAssertEquals([dnf valueForKeyPath:@"firstNode.firstNode.firstNode.firstNode.parent.parent.parent.parent"], dnf, nil);
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
        STAssertFalse([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertFalse([imf isNnfFormula], input);
        STAssertFalse([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertFalse([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertTrue([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertFalse([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertFalse([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertTrue([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
    // check node relations
    
    STAssertFalse(nnf == dnf, nil);
    NyayaNode *nfrst = [nnf valueForKeyPath:@"firstNode"];
    NyayaNode *nscnd = [nnf valueForKeyPath:@"secondNode"];
    
    NyayaNode *nal = [nnf valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode *nar = [nnf valueForKeyPath:@"secondNode.secondNode.firstNode"];
    NyayaNode *dal = [dnf valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode *dar = [dnf valueForKeyPath:@"secondNode.secondNode.firstNode"];
    
    STAssertEquals(nal.parent, nfrst, nil);
    STAssertEquals(nal.parent.parent, nnf, nil);
    
    STAssertEquals(nar.parent.parent, nscnd, nil);
    STAssertEquals(nar.parent.parent.parent, nnf, nil);
    
    STAssertFalse(nal == nar, nil);
    STAssertFalse(nal == dal, nil);
    STAssertFalse(nal == dar, nil);
    STAssertFalse(nar == dal, nil);
    STAssertFalse(nar == dar, nil);
    STAssertFalse(dal == dar, nil);
    
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
        STAssertFalse([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertTrue([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertTrue([imf isNnfFormula], input);
        STAssertTrue([imf isCnfFormula], input);
        STAssertTrue([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertFalse([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertFalse([imf isNnfFormula], input);
        STAssertFalse([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertTrue([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertTrue([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertFalse([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertTrue([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertTrue([imf isNnfFormula], input);
        STAssertTrue([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertFalse([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertTrue([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertTrue([nnf isCnfFormula], input);
        STAssertFalse([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertFalse([nnf isCnfTransformationNode], input);
        STAssertTrue([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertFalse([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertTrue([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertFalse([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
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
        STAssertFalse([ast isImfFormula], input);
        STAssertFalse([ast isNnfFormula], input);
        STAssertFalse([ast isCnfFormula], input);
        STAssertFalse([ast isDnfFormula], input);
        STAssertFalse([ast isImfTransformationNode], input);
        STAssertFalse([ast isNnfTransformationNode], input);
        STAssertFalse([ast isCnfTransformationNode], input);
        STAssertFalse([ast isDnfTransformationNode], input);
        
        STAssertTrue([imf isImfFormula], input);
        STAssertFalse([imf isNnfFormula], input);
        STAssertFalse([imf isCnfFormula], input);
        STAssertFalse([imf isDnfFormula], input);
        STAssertFalse([imf isImfTransformationNode], input);
        STAssertTrue([imf isNnfTransformationNode], input);
        STAssertFalse([imf isCnfTransformationNode], input);
        STAssertFalse([imf isDnfTransformationNode], input);
        
        STAssertTrue([nnf isImfFormula], input);
        STAssertTrue([nnf isNnfFormula], input);
        STAssertFalse([nnf isCnfFormula], input);
        STAssertTrue([nnf isDnfFormula], input);
        STAssertFalse([nnf isImfTransformationNode], input);
        STAssertFalse([nnf isNnfTransformationNode], input);
        STAssertTrue([nnf isCnfTransformationNode], input);
        STAssertFalse([nnf isDnfTransformationNode], input);
        
        STAssertTrue([cnf isImfFormula], input);
        STAssertTrue([cnf isNnfFormula], input);
        STAssertTrue([cnf isCnfFormula], input);
        STAssertFalse([cnf isDnfFormula], input);
        STAssertFalse([cnf isImfTransformationNode], input);
        STAssertFalse([cnf isNnfTransformationNode], input);
        STAssertFalse([cnf isCnfTransformationNode], input);
        STAssertFalse([cnf isDnfTransformationNode], input);
        
        STAssertTrue([dnf isImfFormula], input);
        STAssertTrue([dnf isNnfFormula], input);
        STAssertFalse([dnf isCnfFormula], input);
        STAssertTrue([dnf isDnfFormula], input);
        STAssertFalse([dnf isImfTransformationNode], input);
        STAssertFalse([dnf isNnfTransformationNode], input);
        STAssertTrue([dnf isCnfTransformationNode], input);
        STAssertFalse([dnf isDnfTransformationNode], input);
    }
    
}

@end
