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
}

- (void)testParseF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.displayValue, F.displayValue, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
}

- (void)testParseT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.displayValue, T.displayValue, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
}

- (void)testNotA {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!a"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaUndefined, nil);
    STAssertTrue(result.evaluationValue, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], A.displayValue, nil);
}

- (void)testNotF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], F.displayValue, nil);
}

- (void)testNotT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"!T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaNegation, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], T.displayValue, nil);
}


- (void)testParseAorT {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a|T"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaDisjunction, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaTrue, nil);
    STAssertEquals(result.evaluationValue, (BOOL)TRUE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], A.displayValue, nil);
    STAssertEquals([[result.nodes objectAtIndex:1] displayValue], T.displayValue, nil);
}

- (void)testParseAandF {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a&F"];
    NyayaNode *result = [parser parseFormula];
    
    STAssertEquals(result.type, (NyayaNodeType)NyayaConjunction, nil);
    STAssertEquals(result.displayValue, (NyayaBool)NyayaFalse, nil);
    STAssertEquals(result.evaluationValue, (BOOL)FALSE, nil);
    
    STAssertEquals([[result.nodes objectAtIndex:0] displayValue], A.displayValue, nil);
    STAssertEquals([[result.nodes objectAtIndex:1] displayValue], F.displayValue, nil);
}


@end
