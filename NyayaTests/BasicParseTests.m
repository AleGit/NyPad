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
    [[NyayaStore sharedInstance] removeAllNodes];
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
    
    STAssertEquals(result, A, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaUndefined, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
}

- (void)testParseF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result, F, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
}

- (void)testParseT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result, T, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
}

- (void)testNotA {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaUndefined, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertEquals([result.nodes objectAtIndex:0], A, nil);
}

- (void)testNotF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertEquals([result.nodes objectAtIndex:0], F, nil);
}

- (void)testNotT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
    
    STAssertEquals([result.nodes objectAtIndex:0], T, nil);
}


- (void)testParseAorT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a|T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaDisjunction, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertEquals([result.nodes objectAtIndex:0], A, nil);
    STAssertEquals([result.nodes objectAtIndex:1], T, nil);
}

- (void)testParseAandF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a&F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaConjunction, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
    
    STAssertEquals([result.nodes objectAtIndex:0], A, nil);
    STAssertEquals([result.nodes objectAtIndex:1], F, nil);
}


@end
