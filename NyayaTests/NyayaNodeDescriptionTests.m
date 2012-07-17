//
//  NyayaNodeDescriptionTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeDescriptionTests.h"
#import "NyayaNode.h"

@interface NyayaNodeDescriptionTests () {
    NyayaNode *_u;
    NyayaNode *_f;
    NyayaNode *_t;
}

@end

@implementation NyayaNodeDescriptionTests

- (void)setUp
{
    [super setUp];
    
    _u = [NyayaNode constant:@"U"];
    _f = [NyayaNode constant:@"F"];
    _t = [NyayaNode constant:@"T"];
    
}

- (void)tearDown
{
    _u = nil;
    _f = nil;
    _t = nil;
    
    [super tearDown];
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
