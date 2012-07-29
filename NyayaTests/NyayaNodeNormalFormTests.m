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
    
    /*
    STAssertEqualObjects([ast description], , nil);
    STAssertEqualObjects([imf description], , nil);
    STAssertEqualObjects([nnf description], , nil);
    STAssertEqualObjects([cnf description], @"", nil);
    STAssertEqualObjects([dnf description], @"", nil);
    
    */
    
    
}

@end
