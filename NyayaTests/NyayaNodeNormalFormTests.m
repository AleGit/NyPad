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
#import "NyayaNode+Type.h"

@implementation NyayaNodeNormalFormTests

- (void)testImf {
    NyayaParser *parser = [NyayaParser parserWithString:@"a>T"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node deriveImf:NSIntegerMax];
    
    STAssertEqualObjects(@"a → T", [node description], nil);
    STAssertEquals((NyayaBool)NyayaTrue, node.displayValue,nil);
    STAssertEqualObjects(@"¬a ∨ T", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, imf.displayValue,[imf description]);
    
    parser = [NyayaParser parserWithString:@"!a > b | (!b > !F)"];
    node = [parser parseFormula];
    imf = [node deriveImf:NSIntegerMax];
    
    STAssertEqualObjects(@"¬a → b ∨ (¬b → ¬F)", [node description], nil);
    STAssertEquals((NyayaBool)NyayaTrue, node.displayValue,nil);
    STAssertEqualObjects([imf description], @"¬¬a ∨ (b ∨ (¬¬b ∨ ¬F))", nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, imf.displayValue,[imf description]);
    
    parser = [NyayaParser parserWithString:@"a <> ¬b"];
    node = [parser parseFormula];
    imf = [node deriveImf:NSIntegerMax];
    
    STAssertEqualObjects(@"a ↔ ¬b", [node description], nil);
    STAssertEquals((NyayaBool)NyayaUndefined, node.displayValue,nil);
    STAssertEqualObjects([imf description], @"(¬a ∨ ¬b) ∧ (¬¬b ∨ a)", nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, imf.displayValue,[imf description]);
    
}

- (void)testNnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"!!F"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node deriveNnf:NSIntegerMax];
    
    STAssertEqualObjects(@"¬¬F", [node description], nil);
    STAssertEquals((NyayaBool)NyayaFalse, node.displayValue,nil);
    STAssertEqualObjects(@"F", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, imf.displayValue,[imf description]);
    
    parser = [NyayaParser parserWithString:@"(!(P|(Q&!R)))"];
    node = [parser parseFormula];
    imf = [node deriveNnf:NSIntegerMax];
    
    STAssertEqualObjects(@"¬(P ∨ (Q ∧ ¬R))", [node description], nil);
    STAssertEquals((NyayaBool)NyayaUndefined, node.displayValue,nil);
    STAssertEqualObjects(@"¬P ∧ (¬Q ∨ R)", [imf description], nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, imf.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, imf.displayValue,[imf description]);
    
}

- (void)testCnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"(a&!b)|c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node deriveImf:NSIntegerMax];
    
    STAssertEqualObjects(@"(a ∧ ¬b) ∨ c", [node description], nil);
    STAssertEqualObjects(@"(a ∧ ¬b) ∨ c", [imf description], nil);
    
    parser = [NyayaParser parserWithString:@"a|(!b&c)"];
    node = [parser parseFormula];
    imf = [node deriveImf:NSIntegerMax];
    
    STAssertEqualObjects(@"a ∨ (¬b ∧ c)", [node description], nil);
    STAssertEqualObjects(@"a ∨ (¬b ∧ c)", [imf description], nil);
    
}

- (void)testDnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"(a|!b)&c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node deriveDnf:NSIntegerMax];
    
    STAssertEqualObjects(@"(a ∨ ¬b) ∧ c", [node description], nil);
    STAssertEqualObjects(@"(a ∧ c) ∨ (¬b ∧ c)", [imf description], nil);
    
    parser = [NyayaParser parserWithString:@"a&(!b|c)"];
    node = [parser parseFormula];
    imf = [node deriveDnf:NSIntegerMax];
    
    STAssertEqualObjects(@"a ∧ (¬b ∨ c)", [node description], nil);
    STAssertEqualObjects(@"(a ∧ ¬b) ∨ (a ∧ c)", [imf description], nil);
    
}

- (void)testBicondition {
    NyayaParser *parser = [NyayaParser parserWithString:@"a<>b"];
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast deriveImf:NSIntegerMax];
    NyayaNode *nnf = [imf deriveNnf:NSIntegerMax];
    NyayaNode *cnf = [nnf deriveCnf:NSIntegerMax];
    NyayaNode *dnf = [nnf deriveDnf:NSIntegerMax];
    STAssertEqualObjects([ast description], @"a ↔ b",nil);
    STAssertEqualObjects([imf description], @"(¬a ∨ b) ∧ (¬b ∨ a)",nil);
    STAssertEqualObjects([nnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)",nil);
    STAssertEqualObjects([cnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)",nil);
    STAssertEqualObjects([dnf description], @"(¬a ∧ ¬b) ∨ (¬a ∧ a) ∨ ((b ∧ ¬b) ∨ (b ∧ a))",nil);
    
    parser = [NyayaParser parserWithString:@"!a<>b"];
    ast = [parser parseFormula];
    imf = [ast deriveImf:NSIntegerMax];
    nnf = [imf deriveNnf:NSIntegerMax];
    cnf = [nnf deriveCnf:NSIntegerMax];
    dnf = [nnf deriveDnf:NSIntegerMax];
    STAssertEqualObjects([ast description], @"¬a ↔ b",nil);
    STAssertEqualObjects([imf description], @"(¬¬a ∨ b) ∧ (¬b ∨ ¬a)",nil);
//    STAssertEqualObjects([nnf description], @"(a ∨ b) ∧ (¬b ∨ ¬a)",nil);
//    STAssertEqualObjects([cnf description], @"(a ∨ b) ∧ (¬b ∨ ¬a)",nil);
//    STAssertEqualObjects([dnf description], @"(a ∧ ¬b) ∨ (a ∧ ¬a) ∨ ((b ∧ ¬b) ∨ (b ∧ ¬a))",nil);
//    
//    
    
    
}

- (void)testNormalForms {
    NyayaParser *parser = [NyayaParser parserWithString:@"a>b&!a&b>b|a|(a>b)|!(!a>a)"];
    
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast deriveImf:NSIntegerMax];
    NyayaNode *nnf = [imf deriveNnf:NSIntegerMax];
    NyayaNode *cnf = [nnf deriveCnf:NSIntegerMax];
    NyayaNode *dnf = [nnf deriveDnf:NSIntegerMax];
    
    STAssertFalse([ast isImplicationFree], nil);
    STAssertFalse([ast isNegationNormalForm], nil);
    STAssertFalse([ast isConjunctiveNormalForm], nil);
    STAssertFalse([ast isDisjunctiveNormalForm], nil);
    
    STAssertTrue([imf isImplicationFree], nil);
    STAssertFalse([imf isNegationNormalForm], nil);
    STAssertFalse([imf isConjunctiveNormalForm], nil);
    STAssertFalse([imf isDisjunctiveNormalForm], nil);
    
    STAssertTrue([nnf isImplicationFree], nil);                 // ¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))
    STAssertTrue([nnf isNegationNormalForm], nil);
    STAssertFalse([nnf isConjunctiveNormalForm], nil);                // is not cnf
    STAssertTrue([nnf isDisjunctiveNormalForm], nil);                 // is allready dnf
    
    STAssertTrue([cnf isImplicationFree], nil);                 // (¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a))) ∧ (¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a)))
    STAssertTrue([cnf isNegationNormalForm], nil);
    STAssertTrue([cnf isConjunctiveNormalForm], nil);
    STAssertFalse([cnf isDisjunctiveNormalForm], nil);
    
    STAssertTrue([dnf isImplicationFree], nil);                 // ¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))
    STAssertTrue([dnf isNegationNormalForm], nil);
    STAssertFalse([dnf isConjunctiveNormalForm], nil);
    STAssertTrue([dnf isDisjunctiveNormalForm], nil);
    
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
        
        
        STAssertFalse([test isImplicationFree], [test description]);
        STAssertFalse([test isNegationNormalForm], [test description]);
        STAssertFalse([test isConjunctiveNormalForm], [test description]);
        STAssertFalse([test isDisjunctiveNormalForm], [test description]);
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
        
        
        STAssertTrue([test isImplicationFree], [test description]);
        STAssertFalse([test isNegationNormalForm], [test description]);
        STAssertFalse([test isConjunctiveNormalForm], [test description]);
        STAssertFalse([test isDisjunctiveNormalForm], [test description]);
    }

    
    
    
}



@end
