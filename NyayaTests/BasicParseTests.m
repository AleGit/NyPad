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
#import "NyayaNode+Creation.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode+Display.h"

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
    
    XCTAssertEqual(result.displayValue, A.displayValue);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaUndefined);
    XCTAssertFalse(result.evaluationValue);
    XCTAssertEqual([result.nodes count], (NSUInteger)0);
}

- (void)testParseF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F"];
    NyayaNode *result = [parser parseFormula];
    
    XCTAssertEqual(result.displayValue, F.displayValue);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaFalse);
    XCTAssertEqual(result.evaluationValue, (BOOL)FALSE);
    XCTAssertEqual([result.nodes count], (NSUInteger)0);
}

- (void)testParseT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"T"];
    NyayaNode *result = [parser parseFormula];
    
    XCTAssertEqual(result.displayValue, T.displayValue);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaTrue);
    XCTAssertEqual(result.evaluationValue, (BOOL)TRUE);
    XCTAssertEqual([result.nodes count], (NSUInteger)0);
}

- (void)testNotA {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a"];
    NyayaNode *result = [parser parseFormula];
    
    XCTAssertEqual(result.type, (NyayaNodeType)NyayaNegation);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaUndefined);
    XCTAssertTrue(result.evaluationValue);
    
    XCTAssertEqual([[result.nodes objectAtIndex:0] displayValue], A.displayValue);
    XCTAssertEqual([result.nodes count], (NSUInteger)1);
    NyayaNode *a = [result valueForKeyPath:@"firstNode"];
    XCTAssertEqual([a.nodes count], (NSUInteger)0);
}

- (void)testNotF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!F"];
    NyayaNode *result = [parser parseFormula];
    
    XCTAssertEqual(result.type, (NyayaNodeType)NyayaNegation);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaTrue);
    XCTAssertEqual(result.evaluationValue, (BOOL)TRUE);
    
    XCTAssertEqual([[result.nodes objectAtIndex:0] displayValue], F.displayValue);

    XCTAssertEqual([result.nodes count], (NSUInteger)1);
    NyayaNode *f = [result valueForKeyPath:@"firstNode"];
    XCTAssertEqual([f.nodes count], (NSUInteger)0);
}

- (void)testNotT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!T"];
    NyayaNode *result = [parser parseFormula];
    
    XCTAssertEqual(result.type, (NyayaNodeType)NyayaNegation);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaFalse);
    XCTAssertEqual(result.evaluationValue, (BOOL)FALSE);
    
    XCTAssertEqual([[result.nodes objectAtIndex:0] displayValue], T.displayValue);

    XCTAssertEqual([result.nodes count], (NSUInteger)1);
    
    NyayaNode *t = [result valueForKeyPath:@"firstNode"];
    XCTAssertEqual([t.nodes count], (NSUInteger)0);
}


- (void)testParseAorT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a|T"];
    NyayaNode *result = [parser parseFormula];
    
    XCTAssertEqual(result.type, (NyayaNodeType)NyayaDisjunction);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaTrue);
    XCTAssertEqual(result.evaluationValue, (BOOL)TRUE);
    
    XCTAssertEqual([[result.nodes objectAtIndex:0] displayValue], A.displayValue);
    XCTAssertEqual([[result.nodes objectAtIndex:1] displayValue], T.displayValue);
    
    XCTAssertEqual([result.nodes count], (NSUInteger)2);
    NyayaNode *a = [result valueForKey:@"firstNode"];
    XCTAssertEqual([a.nodes count], (NSUInteger)0);
    
    NyayaNode *t = [result valueForKeyPath:@"secondNode"];
    XCTAssertEqual([t.nodes count], (NSUInteger)0);
}

- (void)testParseAandF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a&F"];
    NyayaNode *result = [parser parseFormula];
    
    XCTAssertEqual(result.type, (NyayaNodeType)NyayaConjunction);
    XCTAssertEqual(result.displayValue, (NyayaBool)NyayaFalse);
    XCTAssertEqual(result.evaluationValue, (BOOL)FALSE);
    
    XCTAssertEqual([[result.nodes objectAtIndex:0] displayValue], A.displayValue);
    XCTAssertEqual([[result.nodes objectAtIndex:1] displayValue], F.displayValue);
   
    XCTAssertEqual([result.nodes count], (NSUInteger)2);
    NyayaNode *a = [result valueForKey:@"firstNode"];
    XCTAssertEqual([a.nodes count], (NSUInteger)0);
    
    NyayaNode *f = [result valueForKeyPath:@"secondNode"];
    XCTAssertEqual([f.nodes count], (NSUInteger)0);
}

- (void)testVariables {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"T&a&b|a>F"];
    NyayaNode *result = [[parser parseFormula] copy];
    
    XCTAssertEqualObjects([result description], @"(T ∧ a ∧ b) ∨ a → F");
    XCTAssertEqual([result.setOfVariables count], (NSUInteger)2);
    
    NyayaNode* disj = [result valueForKey:@"firstNode"];
    NyayaNode* f = [result valueForKey:@"secondNode"];
    XCTAssertEqualObjects([disj description], @"(T ∧ a ∧ b) ∨ a");
    XCTAssertEqualObjects([f description], @"F");
    XCTAssertEqual([disj.setOfVariables count], (NSUInteger)2);
    XCTAssertEqual([f.setOfVariables count], (NSUInteger)0);
    
    NyayaNode* conj = [result valueForKeyPath:@"firstNode.firstNode"];
    NyayaNode* a1 = [result valueForKeyPath:@"firstNode.secondNode"];
    XCTAssertEqualObjects([conj description], @"T ∧ a ∧ b");
    XCTAssertEqualObjects([a1 description], @"a");
    XCTAssertEqual([conj.setOfVariables count], (NSUInteger)2);
    XCTAssertEqual([a1.setOfVariables count], (NSUInteger)1);
    
    NyayaNode* ta2 = [result valueForKeyPath:@"firstNode.firstNode.firstNode"];
    NyayaNode* b = [result valueForKeyPath:@"firstNode.firstNode.secondNode"];
    XCTAssertEqualObjects([ta2 description], @"T ∧ a");
    XCTAssertEqualObjects([b description], @"b");
    XCTAssertEqual([ta2.setOfVariables count], (NSUInteger)1);
    XCTAssertEqual([b.setOfVariables count], (NSUInteger)1);
    
    NyayaNode* t = [result valueForKeyPath:@"firstNode.firstNode.firstNode.firstNode"];
    NyayaNode* a2 = [result valueForKeyPath:@"firstNode.firstNode.firstNode.secondNode"];
    XCTAssertEqualObjects([t description], @"T");
    XCTAssertEqualObjects([a2 description], @"a");
    XCTAssertEqual([t.setOfVariables count], (NSUInteger)0);
    XCTAssertEqual([a2.setOfVariables count], (NSUInteger)1);
    
    XCTAssertTrue(a1 == a2);
    XCTAssertTrue([a1 isEqual: a2]);
}


@end
