//
//  CopyTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 30.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "CopyTests.h"
#import "NyayaNode.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode+Display.h"

@implementation CopyTests 

- (void) testAtomCopy {
    NyayaNode *A = [NyayaNode atom:@"a"];
    NyayaNode *Ac = [A copy];
    
    XCTAssertTrue(A == Ac);
    XCTAssertTrue([A isEqual: Ac]);
}

- (void) testNegationCopy {
    NyayaNode *nnA = [NyayaNode negation:[NyayaNode negation:[NyayaNode atom:@"a"]]];
    NyayaNode *nA = [nnA.nodes objectAtIndex:0];
    NyayaNodeVariable *A = [nA.nodes objectAtIndex:0];
    
    
    NyayaNode *nnAc = [nnA copy];
    NyayaNode *nAc = [nnAc.nodes objectAtIndex:0];
    NyayaNode *Ac = [nAc.nodes objectAtIndex:0];

    XCTAssertEqual(A.displayValue, Ac.displayValue);
    XCTAssertEqual(A.evaluationValue, Ac.evaluationValue);
    
    A.displayValue = NyayaTrue;
    A.evaluationValue = TRUE;
    XCTAssertEqual(Ac.displayValue, (NyayaBool)NyayaTrue);
    XCTAssertTrue(Ac.evaluationValue);
    
    A.displayValue = NyayaFalse;
    A.evaluationValue = FALSE;
    XCTAssertEqual(Ac.displayValue, (NyayaBool)NyayaFalse);
    XCTAssertFalse(Ac.evaluationValue);

    A.displayValue = NyayaUndefined;
    XCTAssertEqual(Ac.displayValue, (NyayaBool)NyayaUndefined);
    
    XCTAssertEqualObjects(nnA, nnAc);
    XCTAssertEqualObjects(nA, nAc);
    XCTAssertEqualObjects(A, Ac);
    
    XCTAssertEqualObjects([nnA description], [nnAc description]);
    XCTAssertEqualObjects([nA description], [nAc description]);
    XCTAssertEqualObjects([A description], [Ac description]);
    
    XCTAssertTrue(A == Ac);
    XCTAssertTrue(nA == nAc);
    XCTAssertTrue(nnA == nnAc);
}

@end
