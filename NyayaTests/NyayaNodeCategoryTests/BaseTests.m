//
//  BaseTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BaseTests.h"
#import "NyayaNode.h"
#import "NyayaNode_Cluster.h"

@implementation BaseTests

- (void)testIsEqual {
    NyayaNode *a1 = [NyayaNode formulaWithInput:@"a&b|c"];
    NyayaNode *a2 = [NyayaNode formulaWithInput:@"a∧b∨c"];
    NyayaNode *a3 = [NyayaNode formulaWithInput:@"c∨a∧b"];
    
    STAssertEqualObjects(a1, a2, @"nodes should be equal");
    STAssertEqualObjects(a1.nodes, a2.nodes, @"array of subnodes should be equal");
    STAssertEqualObjects([NSSet setWithArray:a2.nodes], [NSSet setWithArray:a3.nodes], @"set of subnodes should be equal");
    STAssertEqualObjects(a2, a3, @"nodes should be equal");
    
    a2 = [NyayaNode formulaWithInput:@"a&b"];
    a3 = [NyayaNode formulaWithInput:@"b&a"];
    STAssertEqualObjects(a2, a3, @"conjunction is commutative");
    
    a2 = [NyayaNode formulaWithInput:@"a>b"];
    a3 = [NyayaNode formulaWithInput:@"b>a"];
    STAssertFalse([a2 isEqual:a3], @"implication is not commutative");
   
    
    
}

- (void)testIsNegationOfNode {
    NyayaNode *a0 = [NyayaNode formulaWithInput:@"(a&b|c)"];
    NyayaNode *a1 = [NyayaNode formulaWithInput:@"!(a&b|c)"];
    NyayaNode *a2 = [NyayaNode formulaWithInput:@"!!(a&b|c)"];
    NyayaNode *a3 = [NyayaNode formulaWithInput:@"!!!(a&b|c)"];
    NyayaNode *a4 = [NyayaNode formulaWithInput:@"!!!!(a&b|c)"];
    
    STAssertFalse([a0 isNegationToNode:a0], nil);
    
    STAssertTrue([a0 isNegationToNode:a1], nil);
    STAssertTrue([a1 isNegationToNode:a0], nil);
    
    STAssertTrue([a2 isNegationToNode:a1], nil);
    STAssertTrue([a1 isNegationToNode:a2], nil);
    
    STAssertTrue([a2 isNegationToNode:a3], nil);
    STAssertTrue([a3 isNegationToNode:a2], nil);
    
    STAssertTrue([a4 isNegationToNode:a3], nil);
    STAssertTrue([a3 isNegationToNode:a4], nil);
    
    
}

@end
