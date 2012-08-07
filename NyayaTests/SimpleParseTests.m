//
//  SimpleParseTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 07.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "SimpleParseTests.h"
#import "NyayaNode.h"
#import "NyayaParser.h"
#import "NyayaStore.h"
#import "NSString+NyayaToken.h"

@implementation SimpleParseTests

- (void)testLocalizedInput {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"_a",@"a_a",@"a_",@"ε",@"ǖ",@"Δ2",@"3Δ",@"1_Δ"
         ,@"007"
         ,@"ä ∧ ö"   // german
         ,@"αβ ∨ ¬Δ"    // greek
         ,@"ﺕجح ↔ ݘ"    // arabic
         ,@"דכּם ⊻ ﬣכﬦ"    // hebrew
         ,@"一互", @"人伸 → 丞京"   // hanja
         ,@"丶太卵", @"丈 → 再"  // kanji
         
          // Regen → Nass (google translate)
         ,@"雨 → 湿" // Regen → Nass (chinesisch vereinfacht)
         ]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertEqualObjects([result description], input, input);
        STAssertTrue([[result description] isEqual: input], input);
    }
}

- (void)testInvalidInput {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"$", @"➽", @"⟫"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertFalse([[result description] isEqual: input], input);
        STAssertTrue([parser hasErrors], input);
    }
}

- (void)testTrue {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"T", @"1", @"⊤"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertEqualObjects([result description], @"T", input);
    }
}

- (void)testFalse {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"F", @"0", @"⊥"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertEqualObjects([result description], @"F", input);
    }
}


- (void)testNot {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"¬b", @"!b", @"NOT b"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertEqualObjects([result description], @"¬b", input);
    }
}

- (void)testAnd {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a∧b", @"a.b", @"a&b", @"a AND b", // @"a b"
         ]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertEqualObjects([result description], @"a ∧ b", input);
    }
}

- (void)testOr {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a∨b", @"a|b", @"a+b", @"a OR b"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertEqualObjects([result description], @"a ∨ b", input);
    }
}

- (void)testXor {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a⊻b", @"a^b", @"a XOR b", // @"a b"
         ]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        STAssertEqualObjects([result description], @"a ⊻ b", input);
    }
}

@end
