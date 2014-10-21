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
    
    XCTAssertEqualObjects(@"a → T", [node description]);
    XCTAssertEqual((NyayaBool)NyayaTrue, node.displayValue);
    XCTAssertEqualObjects(@"¬a ∨ T", [imf description]);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, imf.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, imf.displayValue,@"%@",[imf description]);
    
    parser = [NyayaParser parserWithString:@"!a > b | (!b > !F)"];
    node = [parser parseFormula];
    imf = [node deriveImf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"¬a → b ∨ (¬b → ¬F)", [node description]);
    XCTAssertEqual((NyayaBool)NyayaTrue, node.displayValue);
    XCTAssertEqualObjects([imf description], @"¬¬a ∨ (b ∨ (¬¬b ∨ ¬F))");
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, imf.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, imf.displayValue,@"%@",[imf description]);
    
    parser = [NyayaParser parserWithString:@"a <> ¬b"];
    node = [parser parseFormula];
    imf = [node deriveImf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"a ↔ ¬b", [node description]);
    XCTAssertEqual((NyayaBool)NyayaUndefined, node.displayValue);
    XCTAssertEqualObjects([imf description], @"(¬a ∨ ¬b) ∧ (¬¬b ∨ a)");
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, imf.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, imf.displayValue,@"%@",[imf description]);
    
}

- (void)testNnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"!!F"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node deriveNnf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"¬¬F", [node description]);
    XCTAssertEqual((NyayaBool)NyayaFalse, node.displayValue);
    XCTAssertEqualObjects(@"F", [imf description]);
    XCTAssertEqual((NyayaNodeType)NyayaConstant, imf.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, imf.displayValue,@"%@",[imf description]);
    
    parser = [NyayaParser parserWithString:@"(!(P|(Q&!R)))"];
    node = [parser parseFormula];
    imf = [node deriveNnf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"¬(P ∨ (Q ∧ ¬R))", [node description]);
    XCTAssertEqual((NyayaBool)NyayaUndefined, node.displayValue);
    XCTAssertEqualObjects(@"¬P ∧ (¬Q ∨ R)", [imf description]);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, imf.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, imf.displayValue,@"%@",[imf description]);
    
}

- (void)testCnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"(a&!b)|c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node deriveImf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"(a ∧ ¬b) ∨ c", [node description]);
    XCTAssertEqualObjects(@"(a ∧ ¬b) ∨ c", [imf description]);
    
    parser = [NyayaParser parserWithString:@"a|(!b&c)"];
    node = [parser parseFormula];
    imf = [node deriveImf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"a ∨ (¬b ∧ c)", [node description]);
    XCTAssertEqualObjects(@"a ∨ (¬b ∧ c)", [imf description]);
    
}

- (void)testDnf {
    NyayaParser *parser = [NyayaParser parserWithString:@"(a|!b)&c"];
    NyayaNode *node = [parser parseFormula];
    NyayaNode *imf = [node deriveDnf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"(a ∨ ¬b) ∧ c", [node description]);
    XCTAssertEqualObjects(@"(a ∧ c) ∨ (¬b ∧ c)", [imf description]);
    
    parser = [NyayaParser parserWithString:@"a&(!b|c)"];
    node = [parser parseFormula];
    imf = [node deriveDnf:NSIntegerMax];
    
    XCTAssertEqualObjects(@"a ∧ (¬b ∨ c)", [node description]);
    XCTAssertEqualObjects(@"(a ∧ ¬b) ∨ (a ∧ c)", [imf description]);
    
}

- (void)testBicondition {
    NyayaParser *parser = [NyayaParser parserWithString:@"a<>b"];
    NyayaNode *ast = [parser parseFormula];
    NyayaNode *imf = [ast deriveImf:NSIntegerMax];
    NyayaNode *nnf = [imf deriveNnf:NSIntegerMax];
    NyayaNode *cnf = [nnf deriveCnf:NSIntegerMax];
    NyayaNode *dnf = [nnf deriveDnf:NSIntegerMax];
    XCTAssertEqualObjects([ast description], @"a ↔ b");
    XCTAssertEqualObjects([imf description], @"(¬a ∨ b) ∧ (¬b ∨ a)");
    XCTAssertEqualObjects([nnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)");
    XCTAssertEqualObjects([cnf description], @"(¬a ∨ b) ∧ (¬b ∨ a)");
    XCTAssertEqualObjects([dnf description], @"(¬a ∧ ¬b) ∨ (¬a ∧ a) ∨ ((b ∧ ¬b) ∨ (b ∧ a))");
    
    parser = [NyayaParser parserWithString:@"!a<>b"];
    ast = [parser parseFormula];
    imf = [ast deriveImf:NSIntegerMax];
    nnf = [imf deriveNnf:NSIntegerMax];
    cnf = [nnf deriveCnf:NSIntegerMax];
    dnf = [nnf deriveDnf:NSIntegerMax];
    XCTAssertEqualObjects([ast description], @"¬a ↔ b");
    XCTAssertEqualObjects([imf description], @"(¬¬a ∨ b) ∧ (¬b ∨ ¬a)");
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
    
    XCTAssertFalse([ast isImplicationFree]);
    XCTAssertFalse([ast isNegationNormalForm]);
    XCTAssertFalse([ast isConjunctiveNormalForm]);
    XCTAssertFalse([ast isDisjunctiveNormalForm]);
    
    XCTAssertTrue([imf isImplicationFree]);
    XCTAssertFalse([imf isNegationNormalForm]);
    XCTAssertFalse([imf isConjunctiveNormalForm]);
    XCTAssertFalse([imf isDisjunctiveNormalForm]);
    
    XCTAssertTrue([nnf isImplicationFree]);                 // ¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))
    XCTAssertTrue([nnf isNegationNormalForm]);
    XCTAssertFalse([nnf isConjunctiveNormalForm]);                // is not cnf
    XCTAssertTrue([nnf isDisjunctiveNormalForm]);                 // is allready dnf
    
    XCTAssertTrue([cnf isImplicationFree]);                 // (¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a))) ∧ (¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ ¬a)))
    XCTAssertTrue([cnf isNegationNormalForm]);
    XCTAssertTrue([cnf isConjunctiveNormalForm]);
    XCTAssertFalse([cnf isDisjunctiveNormalForm]);
    
    XCTAssertTrue([dnf isImplicationFree]);                 // ¬a ∨ (¬b ∨ a ∨ ¬b ∨ (b ∨ a ∨ (¬a ∨ b) ∨ (¬a ∧ ¬a)))
    XCTAssertTrue([dnf isNegationNormalForm]);
    XCTAssertFalse([dnf isConjunctiveNormalForm]);
    XCTAssertTrue([dnf isDisjunctiveNormalForm]);
    
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
        
        XCTAssertEqualObjects(actual, expected, @"%@",message);

    
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
        
        
        XCTAssertFalse([test isImplicationFree], @"%@",[test description]);
        XCTAssertFalse([test isNegationNormalForm], @"%@",[test description]);
        XCTAssertFalse([test isConjunctiveNormalForm], @"%@",[test description]);
        XCTAssertFalse([test isDisjunctiveNormalForm], @"%@",[test description]);
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
        
        
        XCTAssertTrue([test isImplicationFree], @"%@",[test description]);
        XCTAssertFalse([test isNegationNormalForm], @"%@",[test description]);
        XCTAssertFalse([test isConjunctiveNormalForm], @"%@",[test description]);
        XCTAssertFalse([test isDisjunctiveNormalForm], @"%@",[test description]);
    }

    
    
    
}



@end
