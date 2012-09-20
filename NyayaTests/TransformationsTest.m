//
//  TransformationsTest.m
//  Nyaya
//
//  Created by Alexander Maringele on 19.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TransformationsTest.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Reductions.h"
#import "NyayaFormula.h"

#import "NyayaNode+Transformations.h"

@implementation TransformationsTest

- (void)testTransformation {
    NyayaNode *a = [NyayaNode atom:@"a"];
    NyayaNode *b = [NyayaNode atom:@"b"];
    NyayaNode *ab = [NyayaNode conjunction:a with:b];
    
    NyayaNode *node = [ab nodeByReplacingNodeAtIndexPath:[NSIndexPath indexPathWithIndex:1] withNode:ab];
    node = [node nodeByReplacingNodeAtIndexPath:[NSIndexPath indexPathWithIndex:0] withNode:[NyayaNode negation:a]];
    node = [node substitute:nil];
    
    STAssertEqualObjects([ab description], @"a ∧ b", nil);
    STAssertEqualObjects([node description], @"¬a ∧ (a ∧ b)", nil);
}

- (void)testImfKey {
    NyayaFormula *frm = [NyayaFormula formulaWithString:@"(a>b)|c"];
    NyayaNode *node = [frm syntaxTree:NO];
    STAssertNil(node.imfKey, nil);
    STAssertEqualObjects([node nodeAtIndex:0].imfKey, @"P→Q=¬P∨Q", nil);
    STAssertNil([node nodeAtIndex:1].imfKey, nil);
}

- (void)testCnfKeys {
    NyayaFormula *frm = [NyayaFormula formulaWithString:@"a|b&c; (d&e|f ; g&h|i&j)"];
    NyayaNode *node = [frm syntaxTree:NO];
    NyayaNode *abc = [node nodeAtIndex:0];
    NyayaNode *def = [[node nodeAtIndex:1] nodeAtIndex:0];
    NyayaNode *ghij = [[node nodeAtIndex:1] nodeAtIndex:1];
    
    STAssertEqualObjects([abc description], @"a ∨ (b ∧ c)", nil);
    STAssertNil(abc.cnfLeftKey,nil);
    STAssertEqualObjects(abc.cnfRightKey, @"P∨(Q∧R)=(P∨Q)∧(P∨R)", nil);
    
    STAssertEqualObjects([def description], @"(d ∧ e) ∨ f", nil);
    STAssertEqualObjects(def.cnfLeftKey, @"(P∧Q)∨R=(P∨R)∧(Q∨R)", nil);
    STAssertNil(def.cnfRightKey, nil);
    
    STAssertEqualObjects([ghij description], @"(g ∧ h) ∨ (i ∧ j)", nil);
    STAssertEqualObjects(ghij.cnfLeftKey, @"(P∧Q)∨R=(P∨R)∧(Q∨R)", nil);
    STAssertEqualObjects(ghij.cnfRightKey, @"P∨(Q∧R)=(P∨Q)∧(P∨R)", nil);
}

- (void)testDnfKeys {
    NyayaFormula *frm = [NyayaFormula formulaWithString:@"a&(b|c); ((d|e)&f ; (g|h)&(i|j))"];
    NyayaNode *node = [frm syntaxTree:NO];
    NyayaNode *abc = [node nodeAtIndex:0];
    NyayaNode *def = [[node nodeAtIndex:1] nodeAtIndex:0];
    NyayaNode *ghij = [[node nodeAtIndex:1] nodeAtIndex:1];
    
    STAssertEqualObjects([abc description], @"a ∧ (b ∨ c)", nil);
    STAssertNil(abc.dnfLeftKey,nil);
    STAssertEqualObjects(abc.dnfRightKey, @"P∧(Q∨R)=(P∧Q)∨(P∧R)", nil);
    
    STAssertEqualObjects([def description], @"(d ∨ e) ∧ f", nil);
    STAssertEqualObjects(def.dnfLeftKey, @"(P∨Q)∧R=(P∧R)∨(Q∧R)", nil);
    STAssertNil(def.dnfRightKey, nil);
    
    STAssertEqualObjects([ghij description], @"(g ∨ h) ∧ (i ∨ j)", nil);
    STAssertEqualObjects(ghij.dnfLeftKey, @"(P∨Q)∧R=(P∧R)∨(Q∧R)", nil);
    STAssertEqualObjects(ghij.dnfRightKey, @"P∧(Q∨R)=(P∧Q)∨(P∧R)", nil);
}



- (void)testTransformationNnf {
    NyayaFormula *frm = [NyayaFormula formulaWithString:@"!(a&b)>!(c|d)"];
    NyayaNode *node = [frm syntaxTree:NO];

    NyayaNode *ab = [node nodeAtIndex:0];
    NyayaNode *cd = [node nodeAtIndex:1];
    STAssertEqualObjects([ab description], @"¬(a ∧ b)", nil);
    STAssertEqualObjects([cd description], @"¬(c ∨ d)", nil);
    
    STAssertEqualObjects([[ab nnfKey] description], @"¬(P∧Q)=¬P∨¬Q", nil);
    STAssertEqualObjects([[cd nnfKey] description], @"¬(P∨Q)=¬P∧¬Q", nil);
    
    STAssertEqualObjects([[ab nnfNode] description], @"¬a ∨ ¬b", nil);
    STAssertEqualObjects([[cd nnfNode] description], @"¬c ∧ ¬d", nil);
    
    frm = [NyayaFormula formulaWithString:@"!0 & !1"];
    node = [frm syntaxTree:NO];

    NyayaNode *n0 = [node nodeAtIndex:0];
    NyayaNode *n1 = [node nodeAtIndex:1];
    
    STAssertEqualObjects([n0 description], @"¬F", nil);
    STAssertEqualObjects([n1 description], @"¬T", nil);
    
    STAssertEqualObjects([[n0 nnfKey] description], @"¬⊥=⊤", nil);
    STAssertEqualObjects([[n1 nnfKey] description], @"¬⊤=⊥", nil);
    
    STAssertEqualObjects([[n0 nnfNode] description], @"T", nil);
    STAssertEqualObjects([[n1 nnfNode] description], @"F", nil);
    
    frm = [NyayaFormula formulaWithString:@"!!(a&b|!!c)"];
    node = [frm syntaxTree:NO];
    n1 = [[[node nodeAtIndex:0] nodeAtIndex:0] nodeAtIndex:1];
    STAssertEqualObjects([n1 description], @"¬¬c", nil);
    
    STAssertEqualObjects([[node nnfKey] description], @"¬¬P=P", nil);
    STAssertEqualObjects([[n1 nnfKey] description], @"¬¬P=P", nil);
    STAssertEqualObjects([[node nnfNode] description], @"(a ∧ b) ∨ ¬¬c", nil);
    STAssertEqualObjects([[n1 nnfNode] description], @"c", nil);
    
    
    
    
    
    
}

@end
