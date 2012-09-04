//
//  NyayaNodeNormalFormTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeNormalFormTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Display.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Attributes.h"

@implementation NyayaNodeNormalFormTests

- (void)testImf {
    NyayaParser *parser = [NyayaParser parserWithString:@"a>T"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node imf];
    
    STAssertEqualObjects(@"a → T", [node description], nil);
    STAssertEquals((NyayaBool)NyayaTrue, node.displayValue,nil);
    STAssertEqualObjects(@"¬a ∨ T", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, imf.displayValue,[imf description]);
    
    parser = [NyayaParser parserWithString:@"!a > b | (!b > !F)"];
    node = [parser parseFormula];
    imf = [node imf];
    
    STAssertEqualObjects(@"¬a → b ∨ (¬b → ¬F)", [node description], nil);
    STAssertEquals((NyayaBool)NyayaTrue, node.displayValue,nil);
    STAssertEqualObjects([imf description], @"¬¬a ∨ (b ∨ (¬¬b ∨ ¬F))", nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, imf.displayValue,[imf description]);
    
    parser = [NyayaParser parserWithString:@"a <> ¬b"];
    node = [parser parseFormula];
    imf = [node imf];
    
    STAssertEqualObjects(@"a ↔ ¬b", [node description], nil);
    STAssertEquals((NyayaBool)NyayaUndefined, node.displayValue,nil);
    STAssertEqualObjects([imf description], @"(¬a ∨ ¬b) ∧ (¬¬b ∨ a)", nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, imf.displayValue,[imf description]);
    
}

- (void)testNnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"!!F"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node nnf];
    
    STAssertEqualObjects(@"¬¬F", [node description], nil);
    STAssertEquals((NyayaBool)NyayaFalse, node.displayValue,nil);
    STAssertEqualObjects(@"F", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, imf.displayValue,[imf description]);
    
    parser = [NyayaParser parserWithString:@"(!(P|(Q&!R)))"];
    node = [parser parseFormula];
    imf = [node nnf];
    
    STAssertEqualObjects(@"¬(P ∨ (Q ∧ ¬R))", [node description], nil);
    STAssertEquals((NyayaBool)NyayaUndefined, node.displayValue,nil);
    STAssertEqualObjects(@"¬P ∧ (¬Q ∨ R)", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, imf.displayValue,[imf description]);
    
}

- (void)testCnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"(a&!b)|c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node cnf];
    
    STAssertEqualObjects(@"(a ∧ ¬b) ∨ c", [node description], nil);
    STAssertEqualObjects(@"(a ∨ c) ∧ (¬b ∨ c)", [imf description], nil);
    
    parser = [NyayaParser parserWithString:@"a|(!b&c)"];
    node = [parser parseFormula];
    imf = [node cnf];
    
    STAssertEqualObjects(@"a ∨ (¬b ∧ c)", [node description], nil);
    STAssertEqualObjects(@"(a ∨ ¬b) ∧ (a ∨ c)", [imf description], nil);
    
}

- (void)testDnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"(a|!b)&c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node dnf];
    
    STAssertEqualObjects(@"(a ∨ ¬b) ∧ c", [node description], nil);
    STAssertEqualObjects(@"(a ∧ c) ∨ (¬b ∧ c)", [imf description], nil);
    
    parser = [NyayaParser parserWithString:@"a&(!b|c)"];
    node = [parser parseFormula];
    imf = [node dnf];
    
    STAssertEqualObjects(@"a ∧ (¬b ∨ c)", [node description], nil);
    STAssertEqualObjects(@"(a ∧ ¬b) ∨ (a ∧ c)", [imf description], nil);
    
}

- (void)testBicondition {
    NyayaParser *parser = [NyayaParser parserWithString:@"a<>b"];
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    STAssertEqualObjects([ast description], @"a ↔ b",nil);
    STAssertEqualObjects([imf description], @"(¬a ∨ b) ∧ (¬b ∨ a)",nil);
    STAssertEqualObjects([nnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)",nil);
    STAssertEqualObjects([cnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)",nil);
    STAssertEqualObjects([dnf description], @"(¬a ∧ ¬b) ∨ (¬a ∧ a) ∨ ((b ∧ ¬b) ∨ (b ∧ a))",nil);
    
    parser = [NyayaParser parserWithString:@"!a<>b"];
    ast = [parser parseFormula];
    imf = [ast imf];
    nnf = [imf nnf];
    cnf = [nnf cnf];
    dnf = [nnf dnf];
    STAssertEqualObjects([ast description], @"¬a ↔ b",nil);
    STAssertEqualObjects([imf description], @"(¬¬a ∨ b) ∧ (¬b ∨ ¬a)",nil);
    STAssertEqualObjects([nnf description], @"(a ∨ b) ∧ (¬b ∨ ¬a)",nil);
    STAssertEqualObjects([cnf description], @"(a ∨ b) ∧ (¬b ∨ ¬a)",nil);
    STAssertEqualObjects([dnf description], @"(a ∧ ¬b) ∨ (a ∧ ¬a) ∨ ((b ∧ ¬b) ∨ (b ∧ ¬a))",nil);
    
    
    
    
}

- (void)testNormalForms {
    NyayaParser *parser = [NyayaParser parserWithString:@"a>b&!a&b>b|a|(a>b)|!(!a>a)"];
    
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf cnf];
    NyayaNode *dnf = [nnf dnf];
    
    STAssertFalse([ast isImfFormula], nil);
    STAssertFalse([ast isNnfFormula], nil);
    STAssertFalse([ast isCnfFormula], nil);
    STAssertFalse([ast isDnfFormula], nil);
    
    STAssertTrue([imf isImfFormula], nil);
    STAssertFalse([imf isNnfFormula], nil);
    STAssertFalse([imf isCnfFormula], nil);
    STAssertFalse([imf isDnfFormula], nil);
    
    STAssertTrue([nnf isImfFormula], nil);                 // ¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))
    STAssertTrue([nnf isNnfFormula], nil);
    STAssertFalse([nnf isCnfFormula], nil);                // is not cnf
    STAssertTrue([nnf isDnfFormula], nil);                 // is allready dnf
    
    STAssertTrue([cnf isImfFormula], nil);                 // (¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a))) ∧ (¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a)))
    STAssertTrue([cnf isNnfFormula], nil);
    STAssertTrue([cnf isCnfFormula], nil);
    STAssertFalse([cnf isDnfFormula], nil);
    
    STAssertTrue([dnf isImfFormula], nil);                 // ¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))
    STAssertTrue([dnf isNnfFormula], nil);
    STAssertFalse([dnf isCnfFormula], nil);
    STAssertTrue([dnf isDnfFormula], nil);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSArray arrayWithObjects: [ast description], @"a → b ∧ ¬a ∧ b → b ∨ a ∨ (a → b) ∨ ¬(¬a → a)",
                           nil], @"ast",
                          [NSArray arrayWithObjects: [imf description], 
                           // @"¬a ∨ ¬(b ∧ ¬a ∧ b) ∨ b ∨ a ∨ ¬a ∨ b ∨ ¬(¬¬a ∨ a)",
                           @"¬a ∨ (¬(b ∧ ¬a ∧ b) ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬(¬¬a ∨ a)))",
                           nil], @"imf",
                          [NSArray arrayWithObjects: [nnf description], 
                           // @"¬a ∨ ¬b ∨ a ∨ ¬b ∨ b ∨ a ∨ ¬a ∨ b ∨ (¬a ∧ ¬a)",
                           @"¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))",
                           nil], @"nnf",
                          [NSArray arrayWithObjects: [cnf description], 
                           // @"(¬a ∨ ¬b ∨ a ∨ ¬b ∨ b ∨ a ∨ ¬a ∨ b ∨ ¬a) ∧ (¬a ∨ ¬b ∨ a ∨ ¬b ∨ b ∨ a ∨ ¬a ∨ b ∨ ¬a)",
                           @"(¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a))) ∧ (¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a)))",
                           nil], @"cnf",
                          [NSArray arrayWithObjects: [dnf description], 
                           // @"¬a ∨ ¬b ∨ a ∨ ¬b ∨ b ∨ a ∨ ¬a ∨ b ∨ (¬a ∧ ¬a)",
                           @"¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))",
                           nil], @"dnf",
                          nil];
    
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *array, BOOL *stop) {
        NSString *actual = [array objectAtIndex:0];
        NSString *expected = [array objectAtIndex:1];
        
        NSString *common = [actual commonPrefixWithString:expected options:0];
        NSString *wrong = nil; 
        NSString *missing=nil;
        if ([expected length] > [common length])
            wrong = [expected substringFromIndex:[common length]];
        if ([actual length] > [common length])
            missing = [actual substringFromIndex:[common length]];
    
        NSString *message = [NSString stringWithFormat:@"\n k:%@ \n c:%@ \n m:%@ \n w:%@ ", key, common, missing, wrong];
        
        STAssertEqualObjects(actual, expected, message);

    
    }];
    
    
}

- (void)testNotImplicationFree {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a>b"];
    
    NyayaNode *node = [parser parseFormula];
    NyayaNode *a = [NyayaNode atom:@"a"];
    NyayaNode *b = [NyayaNode atom:@"b"];
    NyayaNode *c = [NyayaNode negation:b];
    
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             node, 
                             [NyayaNode negation:node],
                             
                             [NyayaNode conjunction:node with:node],
                             [NyayaNode conjunction:a with:node],
                             [NyayaNode conjunction:node with:a],
                             [NyayaNode conjunction:b with:node],
                             [NyayaNode conjunction:node with:b],
                             [NyayaNode conjunction:c with:node],
                             [NyayaNode conjunction:node with:c],
                             
                             [NyayaNode disjunction:node with:node],
                             [NyayaNode disjunction:a with:node],
                             [NyayaNode disjunction:node with:a],
                             [NyayaNode disjunction:b with:node],
                             [NyayaNode disjunction:node with:b],
                             [NyayaNode disjunction:c with:node],
                             [NyayaNode disjunction:node with:c],
                             
                             
                             nil]) {
        
        
        STAssertFalse([test isImfFormula], [test description]);
        STAssertFalse([test isNnfFormula], [test description]);
        STAssertFalse([test isCnfFormula], [test description]);
        STAssertFalse([test isDnfFormula], [test description]);
    }
}

- (void)testNotNegationNormalForm {
    NyayaNode *A = [NyayaNode atom:@"a"];
    NyayaNode *B = [NyayaNode atom:@"b"];
    NyayaNode *nnA = [NyayaNode negation:[NyayaNode negation:A]];
    NyayaNode *nnB = [NyayaNode negation:[NyayaNode negation:A]];
    NyayaNode *nAaB = [NyayaNode negation:[NyayaNode conjunction:A  with:B]];
    NyayaNode *nAoB = [NyayaNode negation:[NyayaNode conjunction:A  with:B]];
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             nnA, nnB, nAaB, nAoB,
                             [NyayaNode conjunction:A with: [NyayaNode disjunction: B with:nnA]],
                             [NyayaNode conjunction:A with: [NyayaNode disjunction: B with:nAaB]],
                             
                             nil]) {
        
        
        STAssertTrue([test isImfFormula], [test description]);
        STAssertFalse([test isNnfFormula], [test description]);
        STAssertFalse([test isCnfFormula], [test description]);
        STAssertFalse([test isDnfFormula], [test description]);
    }

    
    
    
}



@end
