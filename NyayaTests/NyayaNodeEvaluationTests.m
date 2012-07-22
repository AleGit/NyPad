//
//  NyayaNodeEvaluationTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeEvaluationTests.h"
#import "NyayaNode.h"



@implementation NyayaNodeEvaluationTests

- (void)testEvaluation {
    NyayaNode *t = [NyayaNode atom:@"T"];
    NyayaNode *f = [NyayaNode atom:@"F"];
    
    STAssertEquals(t.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(f.evaluation, (BOOL)FALSE, nil);
    
    NyayaNode *nt = [NyayaNode negation:t];
    NyayaNode *nf = [NyayaNode negation:f];
    NyayaNode *nnt = [NyayaNode negation:nt];
    NyayaNode *nnf = [NyayaNode negation:nf];
    
    STAssertEquals(nt.evaluation, (BOOL)FALSE, nil);
    STAssertEquals(nf.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(nnt.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(nnf.evaluation, (BOOL)FALSE, nil);
    
    NyayaNode *tat = [NyayaNode conjunction:t with:t];
    NyayaNode *taf = [NyayaNode conjunction:t with:nt];
    NyayaNode *fat = [NyayaNode conjunction:nt with:t];
    NyayaNode *faf = [NyayaNode conjunction:nt with:nt];
    
    STAssertEquals(tat.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(taf.evaluation, (BOOL)FALSE, nil);
    STAssertEquals(fat.evaluation, (BOOL)FALSE, nil);
    STAssertEquals(faf.evaluation, (BOOL)FALSE, nil);
    
    NyayaNode *tot = [NyayaNode disjunction:nf with:nf];
    NyayaNode *tof = [NyayaNode disjunction:nf with:nt];
    NyayaNode *fot = [NyayaNode disjunction:nt with:t];
    NyayaNode *fof = [NyayaNode disjunction:nt with:nt];
    
    STAssertEquals(tot.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(tof.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(fot.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(fof.evaluation, (BOOL)FALSE, nil);
    
    NyayaNode *tit = [NyayaNode implication:t with:t];
    NyayaNode *tif = [NyayaNode implication:t with:nt];
    NyayaNode *fit = [NyayaNode implication:nt with:t];
    NyayaNode *fif = [NyayaNode implication:nt with:f];
    
    STAssertEquals(tit.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(tif.evaluation, (BOOL)FALSE, nil);
    STAssertEquals(fit.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(fif.evaluation, (BOOL)TRUE, nil);
    
    NyayaNode *tbt = [NyayaNode bicondition:t with:t];
    NyayaNode *tbf = [NyayaNode bicondition:t with:f];
    NyayaNode *fbt = [NyayaNode bicondition:f with:t];
    NyayaNode *fbf = [NyayaNode bicondition:f with:nt];
    
    STAssertEquals(tbt.evaluation, (BOOL)TRUE, nil);
    STAssertEquals(tbf.evaluation, (BOOL)FALSE, nil);
    STAssertEquals(fbt.evaluation, (BOOL)FALSE, nil);
    STAssertEquals(fbf.evaluation, (BOOL)TRUE, nil);
    
    
}

@end
