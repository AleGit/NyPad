//
//  NyayaParserTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaParserBasicTests.h"
#import "NyayaParser.h"

@implementation NyayaParserBasicTests



- (void)testParseTerm {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"x1"];
    
    NyayaNode *n = [parser parseTerm];
    
    STAssertEqualObjects(@"x1", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    
    [parser resetWithString:@"T"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"T", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.value, nil);
    
    [parser resetWithString:@"0"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"0", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConstant, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.value, nil);
    
    [parser resetWithString:@"f()"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"f", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaFunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"f()", [n description],nil);
    
    [parser resetWithString:@"f(a)"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"f", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaFunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"f(a)", [n description],nil);
    
    [parser resetWithString:@"f(a,b)"];
    n = [parser parseTerm];
    STAssertEqualObjects(@"f", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaFunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEquals((NSUInteger)2, [n.nodes count], nil);
    STAssertEqualObjects(@"f(a,b)", [n description],nil);
    
}

- (void)testParseNegation {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!x1"];
    NyayaNode *n = [parser parseNegation];
    
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    
    [parser resetWithString:@"!T"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.value, nil);
    
    [parser resetWithString:@"!0"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.value, nil);
    
    [parser resetWithString:@"!f()"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"¬f()", [n description],nil);
    
    [parser resetWithString:@"!f(a)"];
    n = [parser parseNegation];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"¬f(a)", [n description],nil);
    
}



- (void)testParseJunction {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!x1 & a"];
    NyayaNode *n = [parser parseJunction];
    
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    
    [parser resetWithString:@"!T | a"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"¬T ∨ a", [n description],nil);
    
    [parser resetWithString:@"!0 | b"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.value, nil);
    
    [parser resetWithString:@"c | !f()"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"c ∨ ¬f()", [n description],nil);
    
    [parser resetWithString:@"a & !f(a)"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"a ∧ ¬f(a)", [n description],nil);
    
    [parser resetWithString:@"a & !f(a,b)"];
    n = [parser parseJunction];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"a ∧ ¬f(a,b)", [n description],nil);
    
}


- (void)testParseFormula {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a > !x1 & a"];
    NyayaNode *n = [parser parseFormula];
    
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    
    [parser resetWithString:@"!T | a>b"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"¬T ∨ a → b", [n description],nil);
    
    [parser resetWithString:@"x>!0 | b"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.value, nil);
    
    [parser resetWithString:@"c | !f()→ach()"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.value, nil);
    STAssertEqualObjects(@"c ∨ ¬f() → ach()", [n description],nil);
    
    [parser resetWithString:@"a & !f(a)>T"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.value, nil);
    STAssertEqualObjects(@"a ∧ ¬f(a) → T", [n description],nil);
    
    [parser resetWithString:@"F>a & !f(a,b)"];
    n = [parser parseFormula];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.value, nil);
    STAssertEqualObjects(@"F → a ∧ ¬f(a,b)", [n description],nil);
    
}


@end
