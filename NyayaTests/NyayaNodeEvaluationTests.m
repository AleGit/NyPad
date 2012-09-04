//
//  NyayaNodeEvaluationTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeEvaluationTests.h"
#import "NyayaNode.h"
#import "NyayaNode+Creation.h"



@implementation NyayaNodeEvaluationTests

- (void)assertDerivations: (NyayaNode*)node expected:(BOOL) evaluation {
    NyayaNode *imf = [node imf];
    NyayaNode *nnf = [imf nnf];
    NyayaNode *cnf = [nnf nnf];
    NyayaNode *dnf = [imf dnf];
    STAssertEquals(node.evaluationValue, evaluation, nil);
    STAssertEquals(imf.evaluationValue, evaluation, nil);
    STAssertEquals(nnf.evaluationValue, evaluation, nil);
    STAssertEquals(cnf.evaluationValue, evaluation, nil);
    STAssertEquals(dnf.evaluationValue, evaluation, nil);
    
    STAssertEquals([[node setOfVariables] count], (NSUInteger)0,nil);
}

- (void)testConstantEvaluation {
    NyayaNode *t = [NyayaNode atom:@"T"];
    NyayaNode *f = [NyayaNode atom:@"F"];
    
    
    [self assertDerivations:t expected:TRUE];
    [self assertDerivations:f expected:FALSE];
    
    NyayaNode *nt = [NyayaNode negation:t];
    NyayaNode *nf = [NyayaNode negation:f];
    NyayaNode *nnt = [NyayaNode negation:nt];
    NyayaNode *nnf = [NyayaNode negation:nf];
    
    [self assertDerivations:nt expected:FALSE];
    [self assertDerivations:nf expected:TRUE];
    [self assertDerivations:nnt expected:TRUE];
    [self assertDerivations:nnf expected:FALSE];
    
    NyayaNode *tat = [NyayaNode conjunction:t with:t];
    NyayaNode *taf = [NyayaNode conjunction:t with:nt];
    NyayaNode *fat = [NyayaNode conjunction:nt with:t];
    NyayaNode *faf = [NyayaNode conjunction:nt with:nt];
    
    [self assertDerivations:tat expected:TRUE];
    [self assertDerivations:taf expected:FALSE];
    [self assertDerivations:fat expected:FALSE];
    [self assertDerivations:faf expected:FALSE];
    
    NyayaNode *tot = [NyayaNode disjunction:nf with:nf];
    NyayaNode *tof = [NyayaNode disjunction:nf with:nt];
    NyayaNode *fot = [NyayaNode disjunction:nt with:t];
    NyayaNode *fof = [NyayaNode disjunction:nt with:nt];
    
    [self assertDerivations:tot expected:TRUE];
    [self assertDerivations:tof expected:TRUE];
    [self assertDerivations:fot expected:TRUE];
    [self assertDerivations:fof expected:FALSE];
    
    NyayaNode *tit = [NyayaNode implication:t with:t];
    NyayaNode *tif = [NyayaNode implication:t with:nt];
    NyayaNode *fit = [NyayaNode implication:nt with:t];
    NyayaNode *fif = [NyayaNode implication:nt with:f];
    
    [self assertDerivations:tit expected:TRUE];
    [self assertDerivations:tif expected:FALSE];
    [self assertDerivations:fit expected:TRUE];
    [self assertDerivations:fif expected:TRUE];
    
    NyayaNode *tbt = [NyayaNode bicondition:t with:t];
    NyayaNode *tbf = [NyayaNode bicondition:t with:f];
    NyayaNode *fbt = [NyayaNode bicondition:f with:t];
    NyayaNode *fbf = [NyayaNode bicondition:f with:nt];
    
    [self assertDerivations:tbt expected:TRUE];
    [self assertDerivations:tbf expected:FALSE];
    [self assertDerivations:fbt expected:FALSE];
    [self assertDerivations:fbf expected:TRUE];
    
}

@end
