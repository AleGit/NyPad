//
//  CopyTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 30.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "CopyTests.h"
#import "NyayaNode.h"

@implementation CopyTests 

- (void) testAtomCopy {
    NyayaNode *A = [NyayaNode atom:@"a"];
    NyayaNode *Ac = [A copy];
    
    STAssertFalse(A == Ac, nil);
}

- (void) testNegationCopy {
    NyayaNode *nnA = [NyayaNode negation:[NyayaNode negation:[NyayaNode atom:@"a"]]];
    NyayaNode *nA = [nnA.nodes objectAtIndex:0];
    NyayaNodeVariable *A = [nA.nodes objectAtIndex:0];
    
    
    NyayaNode *nnAc = [nnA copy];
    NyayaNode *nAc = [nnAc.nodes objectAtIndex:0];
    NyayaNode *Ac = [nAc.nodes objectAtIndex:0];
    
    STAssertEquals(A.displayValue, Ac.displayValue,nil);
    STAssertEquals(A.evaluationValue, Ac.evaluationValue,nil);
    
    A.displayValue = NyayaTrue;
    A.evaluationValue = TRUE;
    STAssertEquals(Ac.displayValue, (NyayaBool)NyayaTrue,nil);
    STAssertTrue(Ac.evaluationValue, nil);
    
    A.displayValue = NyayaFalse;
    A.evaluationValue = FALSE;
    STAssertEquals(Ac.displayValue, (NyayaBool)NyayaFalse,nil);
    STAssertFalse(Ac.evaluationValue, nil);

    A.displayValue = NyayaUndefined;
    STAssertEquals(Ac.displayValue, (NyayaBool)NyayaUndefined,nil);
    
    STAssertEqualObjects([nnA description], [nnAc description],nil);
    STAssertEqualObjects([nA description], [nAc description],nil);
    STAssertEqualObjects([A description], [Ac description],nil);
    
    STAssertFalse(A == Ac, nil);
    STAssertFalse(nA == nAc, nil);
    STAssertFalse(nnA == nnAc, nil);
}

@end