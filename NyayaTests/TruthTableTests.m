//
//  TruthTableTest.m
//  Nyaya
//
//  Created by Alexander Maringele on 24.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TruthTableTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "TruthTable.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Derivations.h"

@implementation TruthTableTests

- (void)testXandY {
    NyayaParser *parser = [NyayaParser parserWithString:@"x&y"];
    // NyayaParser *parser = [NyayaParser parserWithString:@"(x > y)"];
    
    NyayaNode *formula = [parser parseFormula];
    
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    
    STAssertEqualObjects(truthTable.formula, formula,nil);
    STAssertEqualObjects(truthTable.title, @"x ∧ y",nil);
    
    [truthTable setOrder:[NSArray arrayWithObjects:@"x", @"y",nil]];
    [truthTable evaluateTable];
    
    NSString *expected =
    @"| x | y | x ∧ y |\n"
    @"| F | F | F     |\n"
    @"| F | T | F     |\n"
    @"| T | F | F     |\n"
    @"| T | T | T     |";
    
    NSString *actual = truthTable.description;
    //NSLog(@"\n%@", actual);
    STAssertEqualObjects(actual, expected, [actual commonPrefixWithString:expected options:0]);
    
    [truthTable setOrder:[NSArray arrayWithObjects:@"y",nil]];
    [truthTable evaluateTable];
    
    expected =
    @"| y | x | x ∧ y |\n"
    @"| F | F | F     |\n"
    @"| F | T | F     |\n"
    @"| T | F | F     |\n"
    @"| T | T | T     |";
    
    actual = truthTable.description;
    //NSLog(@"\n%@", actual);
    STAssertEqualObjects(actual, expected, [actual commonPrefixWithString:expected options:0]);
    
}

- (void)testX2orX10 {
    NyayaParser *parser = [NyayaParser parserWithString:@"x10|x2"];
    // NyayaParser *parser = [NyayaParser parserWithString:@"(x > y)"];
    
    NyayaNode *formula = [parser parseFormula];
    
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    
    STAssertEqualObjects(truthTable.formula, formula,nil);
    STAssertEqualObjects(truthTable.title, @"x10 ∨ x2",nil);
    
    
    [truthTable evaluateTable];
    
    NSString *expected =
    @"| x2 | x10 | x10 ∨ x2 |\n"
    @"| F  | F   | F        |\n"
    @"| F  | T   | T        |\n"
    @"| T  | F   | T        |\n"
    @"| T  | T   | T        |";
    
    NSString *actual = truthTable.description;
    //NSLog(@"\n%@", actual);
    STAssertEqualObjects(actual, expected, [actual commonPrefixWithString:expected options:0]);
}

- (void)testXthenA {
    NyayaParser *parser = [NyayaParser parserWithString:@"x>a"];
    // NyayaParser *parser = [NyayaParser parserWithString:@"(x > y)"];
    
    NyayaNode *formula = [parser parseFormula];
    
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    
    STAssertEqualObjects(truthTable.formula, formula,nil);
    STAssertEqualObjects(truthTable.title, @"x → a",nil);
    
    
    [truthTable evaluateTable];
    
    NSString *expected =
    @"| a | x | x → a |\n"
    @"| F | F | T     |\n"
    @"| F | T | F     |\n"
    @"| T | F | T     |\n"
    @"| T | T | T     |";
    
    NSString *actual = truthTable.description;
    //NSLog(@"\n%@", actual);
    STAssertEqualObjects(actual, expected, [actual commonPrefixWithString:expected options:0]);
}

- (void)testXandTthenY {
    NyayaParser *parser = [NyayaParser parserWithString:@"x&T>y"];
    // NyayaParser *parser = [NyayaParser parserWithString:@"(x > y)"];
    
    NyayaNode *formula = [parser parseFormula];
    
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula compact:NO];
    
    STAssertEqualObjects(truthTable.formula, formula,nil);
    STAssertEqualObjects(truthTable.title, @"x ∧ T → y",nil);
    
    [truthTable setOrder:[NSArray arrayWithObjects:@"T",@"y",@"x",nil]];
    [truthTable evaluateTable];
    
    NSString *expected =
    @"| T | y | x | x ∧ T | x ∧ T → y |\n"
    @"| T | F | F | F     | T         |\n"
    @"| T | F | T | T     | F         |\n"
    @"| T | T | F | F     | T         |\n"
    @"| T | T | T | T     | T         |";
    
    NSString *actual = truthTable.description;
    //NSLog(@"\n%@", actual);
    STAssertEqualObjects(actual, expected, [actual commonPrefixWithString:expected options:0]);
}

- (void)testTrueTop {
    NyayaParser *parser = [NyayaParser parserWithString:@"T"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    
    STAssertEqualObjects(truthTable.formula, formula,nil);
    STAssertEqualObjects(truthTable.title, @"T",nil);
    [truthTable evaluateTable];
    
    NSString *expected = @"| T |\n| T |";
    NSString *actual = truthTable.description;
    STAssertEqualObjects(actual, expected, [actual commonPrefixWithString:expected options:0]);
    
    
}

- (void)testFalseBottom {
    NyayaParser *parser = [NyayaParser parserWithString:@"F"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    
    STAssertEqualObjects(truthTable.formula, formula,nil);
    STAssertEqualObjects(truthTable.title, @"F",nil);
    [truthTable evaluateTable];
    
    NSString *expected = @"| F |\n| F |";
    NSString *actual = truthTable.description;
    STAssertEqualObjects(actual, expected, [actual commonPrefixWithString:expected options:0]);
    
    
}

- (void)xtestFormula {
    NyayaParser *parser = [NyayaParser parserWithString:@"!x|y>x<>!y"];
    
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [cnf dnf];
    
    NSArray *truthTables = [NSArray arrayWithObjects:
                            [[TruthTable alloc] initWithNode:ast],
                            [[TruthTable alloc] initWithNode:imf],
                            [[TruthTable alloc] initWithNode:nnf],
                            [[TruthTable alloc] initWithNode:cnf],
                            [[TruthTable alloc] initWithNode:dnf],
                            nil];
    
    for (TruthTable *truthTable in truthTables) {
        [truthTable evaluateTable];
    }
    
    
    NyayaNode *nast = [NyayaNode negation:ast];
    TruthTable *tt = [[TruthTable alloc] initWithNode:nast];
    [tt evaluateTable];
    TruthTable *aoa = [[TruthTable alloc] initWithNode:[NyayaNode disjunction:ast with:ast]];
    [aoa evaluateTable];
    
    TruthTable *aaa = [[TruthTable alloc] initWithNode:[NyayaNode conjunction:ast with:ast]];
    [aaa evaluateTable];
    
    NSUInteger expectedHash = [[truthTables objectAtIndex:0] hash];
    
    for (TruthTable *truthTable in truthTables) {
        STAssertEquals([truthTable hash], expectedHash, [truthTable.formula description]);
        STAssertEqualObjects(truthTable, [truthTables objectAtIndex:0],[truthTable.formula description]);
        STAssertTrue([[truthTables objectAtIndex:0] isEqual: truthTable], [truthTable.formula description]);
        
        STAssertEquals([truthTable hash], [aoa hash], [truthTable.formula description]);
        STAssertEqualObjects(aoa, [truthTables objectAtIndex:0],[truthTable.formula description]);
        STAssertTrue([aoa isEqual: truthTable], [truthTable.formula description]);
        
        STAssertEquals([truthTable hash], [aaa hash], [truthTable.formula description]);
        STAssertEqualObjects(aaa, [truthTables objectAtIndex:0],[truthTable.formula description]);
        STAssertTrue([aaa isEqual: truthTable], [truthTable.formula description]);
        
        STAssertFalse([tt hash] == expectedHash, [truthTable.formula description]);
        STAssertFalse([tt isEqual: truthTable], [truthTable.formula description]);
    }
    
                           
}

- (void)testDifferentTruthTable {
    NyayaParser *pand = [NyayaParser parserWithString:@"x&y"];
    NyayaParser *por = [NyayaParser parserWithString:@"x+y"];
    
    TruthTable *tand = [[TruthTable alloc] initWithNode:[pand parseFormula]];
    TruthTable *tor = [[TruthTable alloc] initWithNode:[por parseFormula]];
    
    [tand evaluateTable];
    [tor evaluateTable];
    
    STAssertFalse([tand isEqual:tor],nil);
    
    
    
}

- (void)testXdisjunctionNormalForm {
    NyayaParser *parser = [NyayaParser parserWithString:@"x^y"];
    NyayaNode *formula = [parser parseFormula];
    TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
    [truthTable evaluateTable];
    NyayaNode *imf = [formula imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    // NyayaNode *dnf = [nnf dnf];
    
    STAssertEqualObjects([nnf description], @"(x ∨ y) ∧ (¬x ∨ ¬y)", @"NNF");
    STAssertEqualObjects([cnf description], @"(x ∨ y) ∧ (¬x ∨ ¬y)", @"CNF");
    
    
    
    
}


@end
