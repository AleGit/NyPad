//
//  NyayaNodeDescriptionTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeDescriptionTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Description.h"

@interface NyayaNodeDescriptionTests () {
    NyayaNode *_u;
    NyayaNode *_f;
    NyayaNode *_t;
    
    NSDictionary *_testCases;
}

@end

@implementation NyayaNodeDescriptionTests

- (void)setUp
{
    [super setUp];
    
    _u = [NyayaNode atom:@"U"];
    _f = [NyayaNode atom:@"F"];
    _t = [NyayaNode atom:@"T"];
    
    _testCases = [NSDictionary dictionaryWithObjectsAndKeys:
                  // disjunctions
                  
                  [NSArray arrayWithObjects:
                   @"a∨b ∨c", // parse
                   @"a ∨ b ∨ c", // expected description
                   @"((a∨b)∨c)", // expected tree description
                   nil], @"OR s1", 
                  
                  [NSArray arrayWithObjects:
                   @"(a∨b) ∨c", // parse
                   @"a ∨ b ∨ c", // expected description
                   @"((a∨b)∨c)", // expected tree description
                   nil], @"OR s2",
                  
                  [NSArray arrayWithObjects:
                   @"a∨(b ∨c)", // parse
                   @"a ∨ (b ∨ c)", // expected description
                   @"(a∨(b∨c))", // expected tree description
                   nil], @"OR s3",
                  
                  // conjunctions
                  
                  [NSArray arrayWithObjects:
                   @"a∧b ∧c", // parse
                   @"a ∧ b ∧ c", // expected description
                   @"((a∧b)∧c)", // expected tree description
                   nil], @"AND s1", 
                  
                  [NSArray arrayWithObjects:
                   @"(a∧b) ∧c", // parse
                   @"a ∧ b ∧ c", // expected description
                   @"((a∧b)∧c)", // expected tree description
                   nil], @"AND s2",
                  
                  [NSArray arrayWithObjects:
                   @"a∧(b ∧c)", // parse
                   @"a ∧ (b ∧ c)", // expected description
                   @"(a∧(b∧c))", // expected tree description
                   nil], @"AND s3",
                  
                  // implications
                  
                  [NSArray arrayWithObjects:
                   @"a→b →c", // parse
                   @"a → b → c", // expected description
                   @"(a→(b→c))", // expected tree description
                   nil], @"IMPL s1", 
                  
                  [NSArray arrayWithObjects:
                   @"(a→b) →c", // parse
                   @"(a → b) → c", // expected description
                   @"((a→b)→c)", // expected tree description
                   nil], @"IMPL s2",
                  
                  [NSArray arrayWithObjects:
                   @"a→(b →c)", // parse
                   @"a → b → c", // expected description
                   @"(a→(b→c))", // expected tree description
                   nil], @"IMPL s3",
                  
                  // negations
                  
                  [NSArray arrayWithObjects:
                   @"¬¬¬a", // parse
                   @"¬¬¬a", // expected description
                   @"(¬(¬(¬a)))", // expected tree description
                   nil], @"NOT s1", 
                  
                  [NSArray arrayWithObjects:
                   @"¬ ¬(¬a)", // parse
                   @"¬¬¬a", // expected description
                   @"(¬(¬(¬a)))", // expected tree description
                   nil], @"NOT s2",                   
                  
                  [NSArray arrayWithObjects:
                   @"¬ (¬¬(a))", // parse
                   @"¬¬¬a", // expected description
                   @"(¬(¬(¬a)))", // expected tree description
                   nil], @"NOT s3", 
                  
                  // functions
                  
                  [NSArray arrayWithObjects:
                   @"f(a∨b,a∧b,a→b,¬a,g(a))", // parse
                   @"f(a ∨ b,a ∧ b,a → b,¬a,g(a))", // expected description
                   @"f((a∨b),(a∧b),(a→b),(¬a),g(a))", // expected tree description
                   nil], @"FNC s1", 
                  
                  [NSArray arrayWithObjects:
                   @"f(a) → g(a,b)",
                   @"f(a) → g(a,b)",
                   @"(f(a)→g(a,b))",
                   nil], @"FNC s2",
                  
                  [NSArray arrayWithObjects:
                   @"f(f(f(f(f(f(f(f(a,f(a)))))))))",
                   @"f(f(f(f(f(f(f(f(a,f(a)))))))))",
                   @"f(f(f(f(f(f(f(f(a,f(a)))))))))",
                   nil], @"FNC s3",
                  
                  
                  
                  nil]; // end of dictionary
    
}

- (void)tearDown
{
    _u = nil;
    _f = nil;
    _t = nil;
    _testCases = nil;
    [super tearDown];
}

- (void)testCases {
    __block NSInteger count = 0;
    
    [_testCases enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *array, BOOL *stop) {
        NSString *input = [array objectAtIndex:0];
        NSString *expected = [array objectAtIndex:1];
        NSString *tree = [array objectAtIndex:2];
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *formula = [parser parseFormula];
        XCTAssertEqualObjects([formula description], expected, @"%@", key);
        XCTAssertEqualObjects([formula strictDescription], tree, @"%@",key);
        
        count++;
        
    }];
    
    XCTAssertEqual(count, 15);
    
    
}



- (void)testUFT {
    XCTAssertEqualObjects(@"U", [_u description]);
    XCTAssertEqualObjects(@"F", [_f description]);
    XCTAssertEqualObjects(@"T", [_t description]);
}

- (void)testNegation {
    NyayaNode *n = nil;
    
    // ¬u
    
    n = [NyayaNode negation:_u];
    XCTAssertEqualObjects(@"¬U", [n description]);
    
    // ¬f
    
    n = [NyayaNode negation:_f];
    XCTAssertEqualObjects(@"¬F", [n description]);
    
    // ¬t
    
    n = [NyayaNode negation:_t];
    XCTAssertEqualObjects(@"¬T", [n description]);
    
}

- (void)testConjunction {
    NyayaNode *n = nil;
    
    // u ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_u with:_u];
    XCTAssertEqualObjects(@"U ∧ U", [n description]);
    
    n = [NyayaNode conjunction:_u with:_f];
    XCTAssertEqualObjects(@"U ∧ F", [n description]);
    
    n = [NyayaNode conjunction:_u with:_t];
    XCTAssertEqualObjects(@"U ∧ T", [n description]);
    
    // f ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_f with:_u];
    XCTAssertEqualObjects(@"F ∧ U", [n description]);
    
    n = [NyayaNode conjunction:_f with:_f];
    XCTAssertEqualObjects(@"F ∧ F", [n description]);
    
    n = [NyayaNode conjunction:_f with:_t];
    XCTAssertEqualObjects(@"F ∧ T", [n description]);
    
    // t ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_t with:_u];
    XCTAssertEqualObjects(@"T ∧ U", [n description]);
    
    n = [NyayaNode conjunction:_t with:_f];
    XCTAssertEqualObjects(@"T ∧ F", [n description]);
    
    n = [NyayaNode conjunction:_t with:_t];
    XCTAssertEqualObjects(@"T ∧ T", [n description]);
    
    
}



- (void)testDisjunction {
    NyayaNode *n = nil;
    
    // u ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_u with:_u];
    XCTAssertEqualObjects(@"U ∨ U", [n description]);
    
    n = [NyayaNode disjunction:_u with:_f];
    XCTAssertEqualObjects(@"U ∨ F", [n description]);
    
    n = [NyayaNode disjunction:_u with:_t];
    XCTAssertEqualObjects(@"U ∨ T", [n description]);
    
    // f ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_f with:_u];
    XCTAssertEqualObjects(@"F ∨ U", [n description]);
    
    n = [NyayaNode disjunction:_f with:_f];
    XCTAssertEqualObjects(@"F ∨ F", [n description]);
    
    n = [NyayaNode disjunction:_f with:_t];
    XCTAssertEqualObjects(@"F ∨ T", [n description]);
    
    // t ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_t with:_u];
    XCTAssertEqualObjects(@"T ∨ U", [n description]);
    
    n = [NyayaNode disjunction:_t with:_f];
    XCTAssertEqualObjects(@"T ∨ F", [n description]);
    
    n = [NyayaNode disjunction:_t with:_t];
    XCTAssertEqualObjects(@"T ∨ T", [n description]);
    
    
}

- (void)testImplication {
    NyayaNode *n = nil;
    
    // u → {u,f,t}
    
    n = [NyayaNode implication: _u with:_u];
    XCTAssertEqualObjects(@"U → U", [n description]);
    
    n = [NyayaNode implication:_u with:_f];
    XCTAssertEqualObjects(@"U → F", [n description]);
    
    n = [NyayaNode implication:_u with:_t];
    XCTAssertEqualObjects(@"U → T", [n description]);
    
    // f → {u,f,t}
    
    n = [NyayaNode implication:_f with:_u];
    XCTAssertEqualObjects(@"F → U", [n description]);
    
    n = [NyayaNode implication:_f with:_f];
    XCTAssertEqualObjects(@"F → F", [n description]);
    
    n = [NyayaNode implication:_f with:_t];
    XCTAssertEqualObjects(@"F → T", [n description]);
    
    // t → {u,f,t}
    
    n = [NyayaNode implication:_t with:_u];
    XCTAssertEqualObjects(@"T → U", [n description]);
    
    n = [NyayaNode implication:_t with:_f];
    XCTAssertEqualObjects(@"T → F", [n description]);
    
    n = [NyayaNode implication:_t with:_t];
    XCTAssertEqualObjects(@"T → T", [n description]);
    
    
}

@end
