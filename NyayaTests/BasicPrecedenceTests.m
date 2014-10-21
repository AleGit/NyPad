//
//  BasicPrecedenceTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BasicPrecedenceTests.h"
#import "NyayaNode.h"
#import "NyayaParser.h"
#import "NyayaNode+Description.h"
#import "NyayaNode+Type.h"

@implementation BasicPrecedenceTests

- (void)testNegationNegation {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!!a"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"¬¬a";
    NSString *expected2 = @"(¬(¬a))";
    XCTAssertEqualObjects([node description], expected);
    XCTAssertEqualObjects([node strictDescription], expected2);
}

- (void)testNegationAnd {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a&b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"¬a ∧ b";
    NSString *expected2 = @"((¬a)∧b)";
    XCTAssertEqual(node.type, (NyayaNodeType)NyayaConjunction);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaNegation);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaVariable);
    XCTAssertEqualObjects([node description], expected);
    XCTAssertEqualObjects([node strictDescription], expected2);
}

- (void)testAndNegation {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a&!b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"a ∧ ¬b";
    NSString *expected2 = @"(a∧(¬b))";
    XCTAssertEqual(node.type, (NyayaNodeType)NyayaConjunction);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaVariable);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaNegation);
    XCTAssertEqualObjects([node description], expected);
    XCTAssertEqualObjects([node strictDescription], expected2);
}

- (void)testNegationOr {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a|b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"¬a ∨ b";
    NSString *expected2 = @"((¬a)∨b)";
    XCTAssertEqual(node.type, (NyayaNodeType)NyayaDisjunction);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaNegation);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaVariable);
    XCTAssertEqualObjects([node description], expected);
    XCTAssertEqualObjects([node strictDescription], expected2);
}

- (void)testOrNegation {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a|!b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"a ∨ ¬b";
    NSString *expected2 = @"(a∨(¬b))";
    XCTAssertEqual(node.type, (NyayaNodeType)NyayaDisjunction);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaVariable);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaNegation);
    XCTAssertEqualObjects([node description], expected);
    XCTAssertEqualObjects([node strictDescription], expected2);
}

- (void)testSequence {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a=b;a&b=c"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"a ↔ b; a ∧ b ↔ c";
    NSString *expected2 = @"((a↔b);((a∧b)↔c))";
    XCTAssertEqualObjects([node description], expected);
    XCTAssertEqualObjects([node strictDescription], expected2);
}

- (void)testComplex {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a^b→a↔b∨a∧!b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"(a ⊻ b → a) ↔ b ∨ (a ∧ ¬b)";
    NSString *expected2 = @"(((a⊻b)→a)↔(b∨(a∧(¬b))))";
    XCTAssertEqual(node.type, (NyayaNodeType)NyayaBicondition);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaImplication);
    XCTAssertEqual(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaDisjunction);
    XCTAssertEqualObjects([node description], expected, @"%@",[[node description] commonPrefixWithString:expected options:0]);
    XCTAssertEqualObjects([node strictDescription], expected2);
}

@end
