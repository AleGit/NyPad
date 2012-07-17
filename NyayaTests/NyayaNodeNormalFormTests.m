//
//  NyayaNodeNormalFormTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeNormalFormTests.h"
#import "NyayaParser.h"

@implementation NyayaNodeNormalFormTests

- (void)testImf {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a>T"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node imf];
    
    STAssertEqualObjects(@"a → T", [node description], nil);
    STAssertEquals((NyayaBool)NyayaTrue, node.value,nil);
    STAssertEqualObjects(@"¬a ∨ T", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, imf.value,[imf description]);
    
    [parser resetWithString:@"!a > b | (!b > !F)"];
    node = [parser parseFormula];
    imf = [node imf];
    
    STAssertEqualObjects(@"¬a → b ∨ (¬b → ¬F)", [node description], nil);
    STAssertEquals((NyayaBool)NyayaTrue, node.value,nil);
    STAssertEqualObjects(@"¬¬a ∨ (b ∨ (¬¬b ∨ ¬F))", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, imf.value,[imf description]);
    
}

- (void)testNNF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!!F"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node nnf];
    
    STAssertEqualObjects(@"¬¬F", [node description], nil);
    STAssertEquals((NyayaBool)NyayaFalse, node.value,nil);
    STAssertEqualObjects(@"F", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, imf.value,[imf description]);
    
    [parser resetWithString:@"(!(P|(Q&!R)))"];
    node = [parser parseFormula];
    imf = [node nnf];
    
    STAssertEqualObjects(@"¬(P ∨ (Q ∧ ¬R))", [node description], nil);
    STAssertEquals((NyayaBool)NyayaUndefined, node.value,nil);
    STAssertEqualObjects(@"¬P ∧ (¬Q ∨ R)", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, imf.value,[imf description]);
    
}

- (void)testCNF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a&!b)|c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node cnf];
    
    STAssertEqualObjects(@"(a ∧ ¬b) ∨ c", [node description], nil);
    STAssertEqualObjects(@"(a ∨ c) ∧ (¬b ∨ c)", [imf description], nil);
    
    [parser resetWithString:@"a|(!b&c)"];
    node = [parser parseFormula];
    imf = [node cnf];
    
    STAssertEqualObjects(@"a ∨ (¬b ∧ c)", [node description], nil);
    STAssertEqualObjects(@"(a ∨ ¬b) ∧ (a ∨ c)", [imf description], nil);
    
}

- (void)testDNF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"(a|!b)&c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node dnf];
    
    STAssertEqualObjects(@"(a ∨ ¬b) ∧ c", [node description], nil);
    STAssertEqualObjects(@"(a ∧ c) ∨ (¬b ∧ c)", [imf description], nil);
    
    [parser resetWithString:@"a&(!b|c)"];
    node = [parser parseFormula];
    imf = [node dnf];
    
    STAssertEqualObjects(@"a ∧ (¬b ∨ c)", [node description], nil);
    STAssertEqualObjects(@"(a ∧ ¬b) ∨ (a ∧ c)", [imf description], nil);
    
}

@end
