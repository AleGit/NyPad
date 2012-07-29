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
#import "NyayaTruthTable.h"

@implementation TruthTableTests

- (void)testXandY {
    NyayaParser *parser = [NyayaParser parserWithString:@"x&y"];
    // NyayaParser *parser = [NyayaParser parserWithString:@"(x > y)"];
    
    NyayaNode *formula = [parser parseFormula];
    
    NyayaTruthTable *truthTable = [[NyayaTruthTable alloc] initWithFormula:formula];
    
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
    
    NyayaTruthTable *truthTable = [[NyayaTruthTable alloc] initWithFormula:formula];
    
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
    
    NyayaTruthTable *truthTable = [[NyayaTruthTable alloc] initWithFormula:formula];
    
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
    
    NyayaTruthTable *truthTable = [[NyayaTruthTable alloc] initWithFormula:formula];
    
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

@end
