//
//  BasicTruthTableTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BasicTruthTableTests.h"
#import "NyayaNode.h"
#import "NyayaParser.h"
#import "NyayaTruthTable.h"

@implementation BasicTruthTableTests

- (void)testTruthTableA {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| a |\n"
    "| F |\n"
    "| T |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| F |\n"
    "| F |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableFandT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F&T"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| F | T | F ∧ T |\n"
    "| F | T | F     |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"T"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| T |\n"
    "| T |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableForT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F|T"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| F | T | F ∨ T |\n"
    "| F | T | T     |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableNot {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!x"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| x | ¬x |\n"
    "| F | T  |\n"
    "| T | F  |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableAnd {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x & y"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| x | y | x ∧ y |\n"
    "| F | F | F     |\n"
    "| F | T | F     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableOr {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x | y"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| x | y | x ∨ y |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | T     |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableBic {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x <> y"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| x | y | x ↔ y |\n"
    "| F | F | T     |\n"
    "| F | T | F     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableImp {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x > y"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| x | y | x → y |\n"
    "| F | F | T     |\n"
    "| F | T | T     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableXor {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x ^ y"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table = [[NyayaTruthTable alloc] initWithFormula:node];
    [table evaluateTable];
    NSString *expected = @""
    "| x | y | x ⊻ y |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    
    STAssertEqualObjects([table description], expected, nil);
}

- (void)testTruthTableXorEquals {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x ^ y"];
    NyayaNode *node = [parser parseFormula];
    NyayaTruthTable *table1 = [[NyayaTruthTable alloc] initWithFormula:node];
    parser = [[NyayaParser alloc] initWithString:@"a ^ b"];
    node = [parser parseFormula];
    NyayaTruthTable *table2 = [[NyayaTruthTable alloc] initWithFormula:node];
    [table1 evaluateTable];
    [table2 evaluateTable];
    NSString *expected1 = @""
    "| x | y | x ⊻ y |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    NSString *expected2 = @""
    "| a | b | a ⊻ b |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    
    STAssertEqualObjects([table1 description], expected1, nil);
    STAssertEqualObjects([table2 description], expected2, nil);
    STAssertFalse([table1 isEqual:table2], nil);
}

@end
