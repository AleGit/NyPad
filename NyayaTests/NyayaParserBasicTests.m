//
//  NyayaParserTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaParserBasicTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "NyayaNode+Display.h"
#import "NyayaNode+Type.h"

@implementation NyayaParserBasicTests



- (void)testParseTerm {
    
    NyayaParser *parser = [NyayaParser parserWithString:@"x1"];
    
    NyayaNode *n = [parser parseTerm];
    
    XCTAssertEqualObjects(@"x1", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaVariable, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"T"];
    n = [parser parseTerm];
    XCTAssertEqualObjects(@"T", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConstant, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"1"];
    n = [parser parseTerm];
    XCTAssertEqualObjects(@"T", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConstant, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"F"];
    n = [parser parseTerm];
    XCTAssertEqualObjects(@"F", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConstant, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"0"];
    n = [parser parseTerm];
    XCTAssertEqualObjects(@"F", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConstant, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"f()"];
    n = [parser parseTerm];
    XCTAssertEqualObjects(@"f", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaFunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"f()", [n description]);
    
    parser = [NyayaParser parserWithString:@"f(a)"];
    n = [parser parseTerm];
    XCTAssertEqualObjects(@"f", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaFunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"f(a)", [n description]);
    
    parser = [NyayaParser parserWithString:@"f(a,b)"];
    n = [parser parseTerm];
    XCTAssertEqualObjects(@"f", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaFunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqual((NSUInteger)2, [n.nodes count]);
    XCTAssertEqualObjects(@"f(a,b)", [n description]);
    
}

- (void)testParseNegation {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!x1"];
    NyayaNode *n = [parser parseNegation];
    
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"!T"];
    n = [parser parseNegation];
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"!0"];
    n = [parser parseNegation];
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"!f()"];
    n = [parser parseNegation];
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"¬f()", [n description]);
    
    parser = [NyayaParser parserWithString:@"!f(a)"];
    n = [parser parseNegation];
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"¬f(a)", [n description]);
    
}

- (void)testParseFormula {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a > !x1 & a"];
    NyayaNode *n = [parser parseFormula];
    
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"!T | a>b"];
    n = [parser parseFormula];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"¬T ∨ a → b", [n description]);
    
    parser = [NyayaParser parserWithString:@"x>!0 | b"];
    n = [parser parseFormula];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    parser = [NyayaParser parserWithString:@"c | !f()→ach()"];
    n = [parser parseFormula];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"c ∨ ¬f() → ach()", [n description]);
    
    parser = [NyayaParser parserWithString:@"a & !f(a)>T"];
    n = [parser parseFormula];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    XCTAssertEqualObjects(@"a ∧ ¬f(a) → T", [n description]);
    
    parser = [NyayaParser parserWithString:@"F>a & !f(a,b)"];
    n = [parser parseFormula];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    XCTAssertEqualObjects(@"F → a ∧ ¬f(a,b)", [n description]);
    
    parser = [NyayaParser parserWithString:@"a & !f(a)<>T"];
    n = [parser parseFormula];
    XCTAssertEqualObjects(@"↔", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaBicondition, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"a ∧ ¬f(a) ↔ T", [n description]);
    
    parser = [NyayaParser parserWithString:@"F<>a & !f(a,b)"];
    n = [parser parseFormula];
    XCTAssertEqualObjects(@"↔", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaBicondition, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    XCTAssertEqualObjects(@"F ↔ a ∧ ¬f(a,b)", [n description]);
}


@end
