//
//  TransformTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 30.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TransformTests.h"
#import "NyayaNode.h"



@implementation TransformTests

- (void)testIsTransformationNode {
    NyayaNode *A = [NyayaNode atom:@"a"];
    NyayaNode *B = [NyayaNode atom:@"b"];
    NyayaNode *nA = [NyayaNode negation:A];
    NyayaNode *nnA = [NyayaNode negation:nA];
    
    NyayaNode *AiB = [NyayaNode implication:A with:B];
    NyayaNode *AbB = [NyayaNode bicondition:A with:B];
    NyayaNode *AaB = [NyayaNode conjunction:A with:B];
    NyayaNode *AoB = [NyayaNode disjunction:A with:B];
    
    NyayaNode *nA_o_AaB = [NyayaNode disjunction:nA with:AaB];
    NyayaNode *AaB_o_B = [NyayaNode disjunction:AaB with:B];
    NyayaNode *nA_a_AoB = [NyayaNode conjunction:nA with:AoB];
    NyayaNode *AoB_a_B = [NyayaNode conjunction:AoB with:B];
    
    NyayaNode *nAaAaB = [NyayaNode conjunction:nA with:AaB];
    NyayaNode *AaBaB = [NyayaNode conjunction:AaB with:B];
    NyayaNode *nAoAoB = [NyayaNode disjunction:nA with:AoB];
    NyayaNode *AoBoB = [NyayaNode disjunction:AoB with:B];
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             A,B,nA,nnA,
                             AaB,AoB,
                             nA_o_AaB,AaB_o_B,nA_a_AoB,AoB_a_B,
                             nAaAaB,AaBaB,nAoAoB,AoBoB,
                             nil]) {
        STAssertFalse([test isImfTransformationNode], [test description]);
    }
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             AiB,AbB,
                             nil]) {
        STAssertTrue([test isImfTransformationNode], [test description]);
    }
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             A,B,nA,
                             AiB,AbB,AaB,AoB,
                             nA_o_AaB,AaB_o_B,nA_a_AoB,AoB_a_B,
                             nAaAaB,AaBaB,nAoAoB,AoBoB,
                             nil]) {
        STAssertFalse([test isNnfTransformationNode], [test description]);
    }
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             nnA,
                             nil]) {
        STAssertTrue([test isNnfTransformationNode], [test description]);
    }
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             A,B,nA,nnA,
                             AiB,AbB,AaB,AoB,
                             nA_a_AoB,AoB_a_B,
                             nAaAaB,AaBaB,nAoAoB,AoBoB,
                             nil]) {
        STAssertFalse([test isCnfTransformationNode], [test description]);
    }
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             nA_o_AaB,AaB_o_B,
                             nil]) {
        STAssertTrue([test isCnfTransformationNode], [test description]);
    }
    
    
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             A,B,nA,nnA,
                             AiB,AbB,AaB,AoB,
                             nA_o_AaB,AaB_o_B,
                             nAaAaB,AaBaB,nAoAoB,AoBoB,
                             nil]) {
        STAssertFalse([test isDnfTransformationNode], [test description]);
    }
    
    for (NyayaNode *test in [NSArray arrayWithObjects:
                             nA_a_AoB,AoB_a_B,
                             nil]) {
        STAssertTrue([test isDnfTransformationNode], [test description]);
    }
    
}

- (void)testReplaceNodeWithNode {
    NyayaNode *x = [NyayaNode atom:@"x"] ;
    NyayaNode *y = [NyayaNode atom:@"y"] ;
    NyayaNode *dis = [NyayaNode disjunction:y with:x];
    NyayaNode *con = [NyayaNode conjunction: x with:[NyayaNode negation: dis]];
    
    STAssertEqualObjects([con description], @"x ∧ ¬(y ∨ x)",nil);
    
    [con replacNode:x withNode:dis];
    
    STAssertEqualObjects([con description], @"(y ∨ x) ∧ ¬(y ∨ x)",nil);
    
}

@end
