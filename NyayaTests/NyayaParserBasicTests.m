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

@implementation NyayaParserBasicTests



- (void)testParseTerm {
    
    NyayaParser *parser = [NyayaParser parserWithString:@"x1"];
    
    NyayaNode *n = [parser parseTerm];
    
    STAssertEqualObjects(@"x1", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaVariable, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"T"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"T", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"1"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"1", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"F"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"F", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"0"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"0", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"f()"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"f", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaFunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"f()", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"f(a)"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"f", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaFunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"f(a)", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"f(a,b)"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"f", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaFunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEquals((NSUInteger)2, [n.nodes count], nil);
    STAssertEqualObjects(@"f(a,b)", [n description],nil);
    
}

- (void)testParseNegation {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!x1"];
    NyayaNode *n = [parser parseNegation];
    
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"!T"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"!0"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"!f()"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"¬f()", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"!f(a)"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"¬f(a)", [n description],nil);
    
}


/*
- (void)testParseJunction {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!x1 & a"];
    NyayaNode *n = [parser parseJunction];
    
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"!T | a"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"¬T ∨ a", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"!0 | b"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"c | !f()"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"c ∨ ¬f()", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"a & !f(a)"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"a ∧ ¬f(a)", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"a & !f(a,b)"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"a ∧ ¬f(a,b)", [n description],nil);
    
}
*/

- (void)testParseFormula {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a > !x1 & a"];
    NyayaNode *n = [parser parseFormula];
    
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"!T | a>b"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"¬T ∨ a → b", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"x>!0 | b"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    parser = [NyayaParser parserWithString:@"c | !f()→ach()"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"c ∨ ¬f() → ach()", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"a & !f(a)>T"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    STAssertEqualObjects(@"a ∧ ¬f(a) → T", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"F>a & !f(a,b)"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    STAssertEqualObjects(@"F → a ∧ ¬f(a,b)", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"a & !f(a)<>T"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"↔", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaBicondition, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"a ∧ ¬f(a) ↔ T", [n description],nil);
    
    parser = [NyayaParser parserWithString:@"F<>a & !f(a,b)"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"↔", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaBicondition, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    STAssertEqualObjects(@"F ↔ a ∧ ¬f(a,b)", [n description],nil);
    
}


@end
