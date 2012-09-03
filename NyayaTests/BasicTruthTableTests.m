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
#import "TruthTable.h"

@implementation BasicTruthTableTests

- (void) assert:(NSString*)input truthTable:(NSString*)tt tautology:(BOOL)isTautology contradiction: (BOOL)isContradiction {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
    NyayaNode *ast = [parser parseFormula];
    STAssertFalse(parser.hasErrors, input);
    TruthTable *astTable = [[TruthTable alloc] initWithFormula:ast expanded:YES];
    [astTable evaluateTable];
    STAssertEqualObjects([astTable description],tt, input);
    STAssertTrue([astTable isTautology] == isTautology, input);
    STAssertTrue([astTable isContradiction] == isContradiction, input);
    STAssertTrue([astTable isSatisfiable] != isContradiction, input);
}


- (void)testTruthTableFandT {
    NSString *tt = @""
    "| F | T | F ∧ T |\n"
    "| F | T | F     |";
    
    for (NSString *input in @[@"F&T"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:YES];
    }
}

- (void)testTruthTableForT {
    NSString *tt = @""
    "| F | T | F ∨ T |\n"
    "| F | T | T     |";
    
    for (NSString *input in @[@"F|T"]) {
        [self assert:input truthTable:tt tautology:YES contradiction:NO];
    }
}


- (void)testF {
    
    NSString *tt = @""
    "| F |\n"
    "| F |";
    
    for (NSString *input in @[@"F"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:YES];
    }
}

- (void)testNotF {
    
    NSString *tt = @""
    "| F | ¬F |\n"
    "| F | T  |";
    
    for (NSString *input in @[@"!F", @"¬F"]) {
        [self assert:input truthTable:tt tautology:YES contradiction:NO];
    }
}

- (void)testT {
    
    NSString *tt = @""
    "| T |\n"
    "| T |";
    
    for (NSString *input in @[@"T"]) {
        [self assert:input truthTable:tt tautology:YES contradiction:NO];
    }
}

- (void)testNotT {
    
    NSString *tt = @""
    "| T | ¬T |\n"
    "| T | F  |";
    
    for (NSString *input in @[@"!T", @"¬T"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:YES];
    }
}

- (void)testA {
    
    NSString *tt = @""
    "| a |\n"
    "| F |\n"
    "| T |";
    
    for (NSString *input in @[@"a"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testNot {
    
    NSString *tt = @""
    "| a | ¬a |\n"
    "| F | T  |\n"
    "| T | F  |";
    
    for (NSString *input in @[@"!a", @"¬a"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testNotNot {
    
    NSString *tt = @""
    "| a | ¬a | ¬¬a |\n"
    "| F | T  | F   |\n"
    "| T | F  | T   |";
    
    for (NSString *input in @[@"!!a", @"¬¬a"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testAnd {
    
    NSString *tt = @""
    "| a | b | a ∧ b |\n"
    "| F | F | F     |\n"
    "| F | T | F     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    for (NSString *input in @[@"a&b", @"a∧b"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testNotAnd {
    
    NSString *tt = @""
    "| a | b | a ∧ b | ¬(a ∧ b) |\n"
    "| F | F | F     | T        |\n"
    "| F | T | F     | T        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    for (NSString *input in @[@"!(a&b)", @"¬(a∧b)"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testOr {
    
    NSString *tt = @""
    "| a | b | a ∨ b |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | T     |";
    
    for (NSString *input in @[@"a|b", @"a∨b"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testNotOr {
    
    NSString *tt = @""
    "| a | b | a ∨ b | ¬(a ∨ b) |\n"
    "| F | F | F     | T        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | T     | F        |\n"
    "| T | T | T     | F        |";
    
    for (NSString *input in @[@"!(a|b)", @"¬(a∨b)"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testBic {
    
    NSString *tt = @""
    "| a | b | a ↔ b |\n"
    "| F | F | T     |\n"
    "| F | T | F     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    for (NSString *input in @[@"(a<>b)", @"a↔b"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testNotBic {
    
    NSString *tt = @""
    "| a | b | a ↔ b | ¬(a ↔ b) |\n"
    "| F | F | T     | F        |\n"
    "| F | T | F     | T        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    for (NSString *input in @[@"!(a<>b)", @"¬(a↔b)"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testImp {
    
    NSString *tt = @""
    "| a | b | a → b |\n"
    "| F | F | T     |\n"
    "| F | T | T     |\n"
    "| T | F | F     |\n"
    "| T | T | T     |";
    
    for (NSString *input in @[@"(a>b)",@"a→b"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testNotImp {
    
    NSString *tt = @""
    "| a | b | a → b | ¬(a → b) |\n"
    "| F | F | T     | F        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | F     | T        |\n"
    "| T | T | T     | F        |";
    
    for (NSString *input in @[@"!(a>b)", @"¬(a→b)"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testXor {
    
    NSString *tt = @""
    "| a | b | a ⊻ b |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    
    for (NSString *input in @[@"(a^b)", @"a⊻b"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)testNotXor {
    
    NSString *tt = @""
    "| a | b | a ⊻ b | ¬(a ⊻ b) |\n"
    "| F | F | F     | T        |\n"
    "| F | T | T     | F        |\n"
    "| T | F | T     | F        |\n"
    "| T | T | F     | T        |";
    
    for (NSString *input in @[@"!(a^b)", @"¬(a⊻b)"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:NO];
    }
}

- (void)xtestContradition {
    
    NSString *tt = @""
    "| a | ¬a | a ∧ ¬a |\n"
    "| F | T  | F      |\n"
    "| T | F  | F      |";
    
    for (NSString *input in @[@"a&!a"]) {
        [self assert:input truthTable:tt tautology:NO contradiction:YES];
    }
}

- (void)xtestTautology {
    
    NSString *tt = @""
    "| a | ¬a | a ∨ ¬a |\n"
    "| F | T  | T      |\n"
    "| T | F  | T      |";
    
    for (NSString *input in @[@"a|!a"]) {
        [self assert:input truthTable:tt tautology:YES contradiction:NO];
    }
}

#pragma mark - special tests

- (void)testTruthTableXorEquals {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x ^ y"];
    NyayaNode *node = [parser parseFormula];
    TruthTable *table1 = [[TruthTable alloc] initWithFormula:node];
    parser = [[NyayaParser alloc] initWithString:@"a ^ b"];
    node = [parser parseFormula];
    TruthTable *table2 = [[TruthTable alloc] initWithFormula:node];
    [table1 evaluateTable];
    [table2 evaluateTable];
    NSString *tt1 = @""
    "| x | y | x ⊻ y |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    NSString *tt2 = @""
    "| a | b | a ⊻ b |\n"
    "| F | F | F     |\n"
    "| F | T | T     |\n"
    "| T | F | T     |\n"
    "| T | T | F     |";
    
    STAssertEqualObjects([table1 description], tt1, nil);
    STAssertEqualObjects([table2 description], tt2, nil);
    STAssertFalse([table1 isEqual:table2], nil);
}

@end
