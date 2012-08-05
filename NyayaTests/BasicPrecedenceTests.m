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

@implementation BasicPrecedenceTests

- (void)testNegationNegation {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!!a"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"¬¬a";
    NSString *expected2 = @"(¬(¬a))";
    STAssertEqualObjects([node description], expected, nil);
    STAssertEqualObjects([node treeDescription], expected2, nil);
}

- (void)testNegationAnd {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a&b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"¬a ∧ b";
    NSString *expected2 = @"((¬a)∧b)";
    STAssertEquals(node.type, (NyayaNodeType)NyayaConjunction, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaVariable, nil);
    STAssertEqualObjects([node description], expected, nil);
    STAssertEqualObjects([node treeDescription], expected2, nil);
}

- (void)testAndNegation {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a&!b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"a ∧ ¬b";
    NSString *expected2 = @"(a∧(¬b))";
    STAssertEquals(node.type, (NyayaNodeType)NyayaConjunction, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaVariable, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEqualObjects([node description], expected, nil);
    STAssertEqualObjects([node treeDescription], expected2, nil);
}

- (void)testNegationOr {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a|b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"¬a ∨ b";
    NSString *expected2 = @"((¬a)∨b)";
    STAssertEquals(node.type, (NyayaNodeType)NyayaDisjunction, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaVariable, nil);
    STAssertEqualObjects([node description], expected, nil);
    STAssertEqualObjects([node treeDescription], expected2, nil);
}

- (void)testOrNegation {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a|!b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"a ∨ ¬b";
    NSString *expected2 = @"(a∨(¬b))";
    STAssertEquals(node.type, (NyayaNodeType)NyayaDisjunction, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaVariable, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEqualObjects([node description], expected, nil);
    STAssertEqualObjects([node treeDescription], expected2, nil);
}

- (void)testComplex {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a^b→a↔b∨a∧!b"];
    NyayaNode *node = [parser parseFormula];
    NSString *expected = @"a ⊻ b → (a ↔ b ∨ (a ∧ ¬b))";
    NSString *expected2 = @"(a⊻(b→(a↔(b∨(a∧(¬b))))))";
    STAssertEquals(node.type, (NyayaNodeType)NyayaXdisjunction, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:0]).type, (NyayaNodeType)NyayaVariable, nil);
    STAssertEquals(((NyayaNode*)[node.nodes objectAtIndex:1]).type, (NyayaNodeType)NyayaImplication, nil);
    STAssertEqualObjects([node description], expected, [[node description] commonPrefixWithString:expected options:0]);
    STAssertEqualObjects([node treeDescription], expected2, nil);
}

@end
