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
        STAssertEqualObjects([formula description], expected, key);
        STAssertEqualObjects([formula strictDescription], tree, key);
        
        count++;
        
    }];
    
    STAssertEquals(count, 15, nil);
    
    
}



- (void)testUFT {
    STAssertEqualObjects(@"U", [_u description], nil);
    STAssertEqualObjects(@"F", [_f description], nil);
    STAssertEqualObjects(@"T", [_t description], nil);
}

- (void)testNegation {
    NyayaNode *n = nil;
    
    // ¬u
    
    n = [NyayaNode negation:_u];
    STAssertEqualObjects(@"¬U", [n description], nil);
    
    // ¬f
    
    n = [NyayaNode negation:_f];
    STAssertEqualObjects(@"¬F", [n description], nil);
    
    // ¬t
    
    n = [NyayaNode negation:_t];
    STAssertEqualObjects(@"¬T", [n description], nil);
    
}

- (void)testConjunction {
    NyayaNode *n = nil;
    
    // u ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_u with:_u];
    STAssertEqualObjects(@"U ∧ U", [n description], nil);
    
    n = [NyayaNode conjunction:_u with:_f];
    STAssertEqualObjects(@"U ∧ F", [n description], nil);
    
    n = [NyayaNode conjunction:_u with:_t];
    STAssertEqualObjects(@"U ∧ T", [n description], nil);
    
    // f ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_f with:_u];
    STAssertEqualObjects(@"F ∧ U", [n description], nil);
    
    n = [NyayaNode conjunction:_f with:_f];
    STAssertEqualObjects(@"F ∧ F", [n description], nil);
    
    n = [NyayaNode conjunction:_f with:_t];
    STAssertEqualObjects(@"F ∧ T", [n description], nil);
    
    // t ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_t with:_u];
    STAssertEqualObjects(@"T ∧ U", [n description], nil);
    
    n = [NyayaNode conjunction:_t with:_f];
    STAssertEqualObjects(@"T ∧ F", [n description], nil);
    
    n = [NyayaNode conjunction:_t with:_t];
    STAssertEqualObjects(@"T ∧ T", [n description], nil);
    
    
}



- (void)testDisjunction {
    NyayaNode *n = nil;
    
    // u ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_u with:_u];
    STAssertEqualObjects(@"U ∨ U", [n description], nil);
    
    n = [NyayaNode disjunction:_u with:_f];
    STAssertEqualObjects(@"U ∨ F", [n description], nil);
    
    n = [NyayaNode disjunction:_u with:_t];
    STAssertEqualObjects(@"U ∨ T", [n description], nil);
    
    // f ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_f with:_u];
    STAssertEqualObjects(@"F ∨ U", [n description], nil);
    
    n = [NyayaNode disjunction:_f with:_f];
    STAssertEqualObjects(@"F ∨ F", [n description], nil);
    
    n = [NyayaNode disjunction:_f with:_t];
    STAssertEqualObjects(@"F ∨ T", [n description], nil);
    
    // t ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_t with:_u];
    STAssertEqualObjects(@"T ∨ U", [n description], nil);
    
    n = [NyayaNode disjunction:_t with:_f];
    STAssertEqualObjects(@"T ∨ F", [n description], nil);
    
    n = [NyayaNode disjunction:_t with:_t];
    STAssertEqualObjects(@"T ∨ T", [n description], nil);
    
    
}

- (void)testImplication {
    NyayaNode *n = nil;
    
    // u → {u,f,t}
    
    n = [NyayaNode implication: _u with:_u];
    STAssertEqualObjects(@"U → U", [n description], nil);
    
    n = [NyayaNode implication:_u with:_f];
    STAssertEqualObjects(@"U → F", [n description], nil);
    
    n = [NyayaNode implication:_u with:_t];
    STAssertEqualObjects(@"U → T", [n description], nil);
    
    // f → {u,f,t}
    
    n = [NyayaNode implication:_f with:_u];
    STAssertEqualObjects(@"F → U", [n description], nil);
    
    n = [NyayaNode implication:_f with:_f];
    STAssertEqualObjects(@"F → F", [n description], nil);
    
    n = [NyayaNode implication:_f with:_t];
    STAssertEqualObjects(@"F → T", [n description], nil);
    
    // t → {u,f,t}
    
    n = [NyayaNode implication:_t with:_u];
    STAssertEqualObjects(@"T → U", [n description], nil);
    
    n = [NyayaNode implication:_t with:_f];
    STAssertEqualObjects(@"T → F", [n description], nil);
    
    n = [NyayaNode implication:_t with:_t];
    STAssertEqualObjects(@"T → T", [n description], nil);
    
    
}

@end
