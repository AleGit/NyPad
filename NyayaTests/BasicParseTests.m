//
//  BasicParseTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BasicParseTests.h"
#import "NyayaNode.h"
#import "NyayaParser.h"
#import "NyayaStore.h"

@interface BasicParseTests () {
    NyayaNode *A;
    NyayaNode *B;
    NyayaNode *F;
    NyayaNode *T;
}
@end

@implementation BasicParseTests

- (void)setUp {
    [[NyayaStore sharedInstance] clear];
    A = [NyayaNode atom:@"a"];
    B = [NyayaNode atom:@"b"];
    F = [NyayaNode atom:@"F"];
    T = [NyayaNode atom:@"T"];
}

- (void)tearDown {
    A = nil;
    B = nil;
    T = nil;
    F = nil;
}

- (void)testParseA {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.displayValue, A.displayValue, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaUndefined, nil);
    STAssertFalse(result.evaluationValue, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)0, nil);
}

- (void)testParseF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.displayValue, F.displayValue, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)0, nil);
}

- (void)testParseT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.displayValue, T.displayValue, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)0, nil);
}

- (void)testNotA {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaUndefined, nil);
    STAssertTrue(result.evaluationValue, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], A.displayValue, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)1, nil);
    NyayaNode *a = [result valueForKeyPath:@"firstNode"];
    STAssertEquals(a.parent, result, nil);
    STAssertEquals([a.nodes count], (NSUInteger)0, nil);
}

- (void)testNotF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], F.displayValue, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)1, nil);
    NyayaNode *f = [result valueForKeyPath:@"firstNode"];
    STAssertEquals(f.parent, result, nil);
    STAssertEquals([f.nodes count], (NSUInteger)0, nil);
}

- (void)testNotT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], T.displayValue, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)1, nil);
    
    NyayaNode *t = [result valueForKeyPath:@"firstNode"];
    STAssertEquals(t.parent, result, nil);
    STAssertEquals([t.nodes count], (NSUInteger)0, nil);
}


- (void)testParseAorT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a|T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaDisjunction, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], A.displayValue, nil);
    STAssertEquals([[result.nodes objectAtIndex:1] displayValue], T.displayValue, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)2, nil);
    NyayaNode *a = [result valueForKey:@"firstNode"];
    STAssertEquals(a.parent, result, nil);
    STAssertEquals([a.nodes count], (NSUInteger)0, nil);
    
    NyayaNode *t = [result valueForKeyPath:@"secondNode"];
    STAssertEquals(t.parent, result, nil);
    STAssertEquals([t.nodes count], (NSUInteger)0, nil);
}

- (void)testParseAandF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a&F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaConjunction, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], A.displayValue, nil);
    STAssertEquals([[result.nodes objectAtIndex:1] displayValue], F.displayValue, nil);
    
    STAssertNil(result.parent, nil);
    STAssertEquals([result.nodes count], (NSUInteger)2, nil);
    NyayaNode *a = [result valueForKey:@"firstNode"];
    STAssertEquals(a.parent, result, nil);
    STAssertEquals([a.nodes count], (NSUInteger)0, nil);
    
    NyayaNode *f = [result valueForKeyPath:@"secondNode"];
    STAssertEquals(f.parent, result, nil);
    STAssertEquals([f.nodes count], (NSUInteger)0, nil);
}

- (void)testVariables {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"T&a&b|a>F"];
    NyayaNode *result = [[parser parseFormula] copy];
    
    STAssertEqualObjects([result description], @"(T ∧ a ∧ b) ∨ a → F", nil);
    STAssertEquals([result.setOfVariables count], (NSUInteger)2, nil);
    
    NyayaNode* disj = [result valueForKey:@"firstNode"];
    NyayaNode* f = [result valueForKey:@"secondNode"];
    STAssertEquals(disj.parent, result, nil);
    STAssertEquals(f.parent, result, nil);
    STAssertEqualObjects([disj description], @"(T ∧ a ∧ b) ∨ a", nil);
    STAssertEqualObjects([f description], @"F", nil);
    STAssertEquals([disj.setOfVariables count], (NSUInteger)2, nil);
    STAssertEquals([f.setOfVariables count], (NSUInteger)0, nil);
    
    NyayaNode* conj = [result valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode* a1 = [result valueForKeyPath:@"firstNode.secondNode"];
    STAssertEquals(conj.parent, disj, nil);
    STAssertEquals(a1.parent, disj, nil);
    STAssertEqualObjects([conj description], @"T ∧ a ∧ b", nil);
    STAssertEqualObjects([a1 description], @"a", nil);
    STAssertEquals([conj.setOfVariables count], (NSUInteger)2, nil);
    STAssertEquals([a1.setOfVariables count], (NSUInteger)1, nil);
    
    NyayaNode* ta2 = [result valueForKeyPath:@"firstNode.firstNode.firstNode"];
    NyayaNode* b = [result valueForKeyPath:@"firstNode.firstNode.secondNode"];
    STAssertEquals(ta2.parent, conj, nil);
    STAssertEquals(b.parent, conj, nil);
    STAssertEqualObjects([ta2 description], @"T ∧ a", nil);
    STAssertEqualObjects([b description], @"b", nil);
    STAssertEquals([ta2.setOfVariables count], (NSUInteger)1, nil);
    STAssertEquals([b.setOfVariables count], (NSUInteger)1, nil);
    
    NyayaNode* t = [result valueForKeyPath:@"firstNode.firstNode.firstNode.firstNode"];
    NyayaNode* a2 = [result valueForKeyPath:@"firstNode.firstNode.firstNode.secondNode"];
    STAssertEquals(t.parent, ta2, nil);
    STAssertEquals(a2.parent, ta2, nil);
    STAssertEqualObjects([t description], @"T", nil);
    STAssertEqualObjects([a2 description], @"a", nil);
    STAssertEquals([t.setOfVariables count], (NSUInteger)0, nil);
    STAssertEquals([a2.setOfVariables count], (NSUInteger)1, nil);
    
    STAssertFalse(a1 == a2, nil);
    STAssertTrue([a1 isEqual: a2], nil);
}


@end
