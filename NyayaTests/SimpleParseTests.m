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
#import "NSSet+NyayaToken.h"

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
        XCTAssertEqualObjects([result description], input, @"%@", input);
        XCTAssertTrue([[result description] isEqual: input], @"%@", input);
    }
}

- (void)testInvalidInput {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"$", @"➽", @"⟫"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertFalse([[result description] isEqual: input], @"%@", input);
        XCTAssertTrue([parser hasErrors], @"%@", input);
    }
}

- (void)testTrue {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"T", @"1", @"⊤"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"T", @"%@", input);
    }
    
    for (NSString *input in [NSSet trueTokens]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"T", @"%@", input);
    }
}

- (void)testFalse {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"F", @"0", @"⊥"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"F", @"%@", input);
    }
    
    for (NSString *input in [NSSet falseTokens]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"F", @"%@", input);
    }
}


- (void)testNot {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"¬b", @"!b", @"NOT b"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"¬b", @"%@", input);
    }
    
    for (NSString *conn in [NSSet notTokens]) {
        NSString *input = [NSString stringWithFormat:@"%@ b",conn, nil];
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"¬b", @"%@", input);
    }
}

- (void)testAnd {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a∧b", @"a.b", @"a&b", @"a AND b", // @"a b"
         ]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a ∧ b", @"%@", input);
    }
    
    for (NSString *conn in [NSSet andTokens]) {
        NSString *input = [NSString stringWithFormat:@"a %@ b",conn, nil];
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a ∧ b", @"%@", input);
    }
}

- (void)testOr {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a∨b", @"a|b", @"a+b", @"a OR b"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a ∨ b", @"%@", input);
    }
}

- (void)testBic {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a=b", @"a<>b", @"a XNOR b"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a ↔ b", @"%@", input);
    }
    
    for (NSString *conn in [NSSet bicTokens]) {
        NSString *input = [NSString stringWithFormat:@"a %@ b",conn, nil];
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a ↔ b", @"%@", input);
    }
}

- (void)testImp {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a > b", @"a→b"]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a → b", @"%@", input);
    }
    
    for (NSString *conn in [NSSet impTokens]) {
        NSString *input = [NSString stringWithFormat:@"a %@ b",conn, nil];
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a → b", @"%@", input);
    }
}

- (void)testXor {
    NyayaParser *parser = nil;
    NyayaNode *result = nil;
    for (NSString *input in @[@"a⊻b", @"a ^ b", @" a XOR b" ]) {
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a ⊻ b", @"%@", input);
    }
    
    for (NSString *conn in [NSSet xorTokens]) {
        NSString *input = [NSString stringWithFormat:@"a %@ b",conn, nil];
        parser = [[NyayaParser alloc] initWithString:input];
        result = [parser parseFormula];
        XCTAssertEqualObjects([result description], @"a ⊻ b", @"%@", input);
    }
}

@end
