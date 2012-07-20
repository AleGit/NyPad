//
//  NyayaFormulaTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaFormulaTests.h"
#import "NyayaNode.h"
#import "NyayaFormula.h"

@implementation NyayaFormulaTests

- (void)testAandBorC {
    NyayaFormula *formula = [NyayaFormula formulaWithString:@"a&b|c"];

    STAssertEqualObjects([[formula ndnf] description], @"(¬a ∧ ¬c) ∨ (¬b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula ncnf] description], @"(¬a ∨ ¬b) ∧ ¬c", nil);
    STAssertEqualObjects([[formula nnnf] description], @"(¬a ∨ ¬b) ∧ ¬c", nil);
    STAssertEqualObjects([[formula nimf] description], @"¬((a ∧ b) ∨ c)", nil);
    STAssertEqualObjects([[formula nast] description], @"¬((a ∧ b) ∨ c)", nil);
    
    STAssertEqualObjects([[formula dnf] description], @"(a ∧ b) ∨ c", nil);
    STAssertEqualObjects([[formula cnf] description], @"(a ∨ c) ∧ (b ∨ c)", nil);
    STAssertEqualObjects([[formula nnf] description], @"(a ∧ b) ∨ c", nil);
    STAssertEqualObjects([[formula imf] description], @"(a ∧ b) ∨ c", nil);
    STAssertEqualObjects([[formula ast] description], @"(a ∧ b) ∨ c", nil);
}

- (void)testNotAandBorC {
    NyayaFormula *formula = [NyayaFormula formulaWithString:@"!(a&b|c)"];
    
    STAssertEqualObjects([[formula dnf] description], @"(¬a ∧ ¬c) ∨ (¬b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula cnf] description], @"(¬a ∨ ¬b) ∧ ¬c", nil);
    STAssertEqualObjects([[formula nnf] description], @"(¬a ∨ ¬b) ∧ ¬c", nil);
    STAssertEqualObjects([[formula imf] description], @"¬((a ∧ b) ∨ c)", nil);
    STAssertEqualObjects([[formula ast] description], @"¬((a ∧ b) ∨ c)", nil);
    
    STAssertEqualObjects([[formula ndnf] description], @"(a ∧ b) ∨ c", nil);
    STAssertEqualObjects([[formula ncnf] description], @"(a ∨ c) ∧ (b ∨ c)", nil);
    STAssertEqualObjects([[formula nnnf] description], @"(a ∧ b) ∨ c", nil);
    STAssertEqualObjects([[formula nimf] description], @"(a ∧ b) ∨ c", nil);
    STAssertEqualObjects([[formula nast] description], @"(a ∧ b) ∨ c", nil);
}

- (void)testAthenBthenC {
    NyayaFormula *formula = [NyayaFormula formulaWithString:@"a>b>c"];
    
    STAssertEqualObjects([[formula dnf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula cnf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula nnf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula imf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula ast] description], @"a → b → c", nil);
    
    STAssertEqualObjects([[formula ndnf] description], @"a ∧ (b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula ncnf] description], @"a ∧ (b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula nnnf] description], @"a ∧ (b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula nimf] description], @"¬(¬a ∨ (¬b ∨ c))", nil);
    STAssertEqualObjects([[formula nast] description], @"¬(a → b → c)", nil);
}

- (void)testNotAthenBthenC {
    NyayaFormula *formula = [NyayaFormula formulaWithString:@"!(a>b>c)"];
    
    STAssertEqualObjects([[formula ndnf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula ncnf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula nnnf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula nimf] description], @"¬a ∨ (¬b ∨ c)", nil);
    STAssertEqualObjects([[formula nast] description], @"a → b → c", nil);
    
    STAssertEqualObjects([[formula dnf] description], @"a ∧ (b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula cnf] description], @"a ∧ (b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula nnf] description], @"a ∧ (b ∧ ¬c)", nil);
    STAssertEqualObjects([[formula imf] description], @"¬(¬a ∨ (¬b ∨ c))", nil);
    STAssertEqualObjects([[formula ast] description], @"¬(a → b → c)", nil);
}

@end
