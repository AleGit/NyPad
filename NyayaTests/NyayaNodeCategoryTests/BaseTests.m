//
//  BaseTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "BaseTests.h"
#import "NyayaFormula.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Attributes.h"

@interface BaseTests () {
    NSArray *_bigFormulas;
}
@end

@implementation BaseTests

- (NyayaNode*) nodeWithFormula:(NSString*)input{
    return [[NyayaFormula formulaWithString:input] syntaxTree:NO];
    
}

- (void)setUp {
    _bigFormulas = @[
    @"a&b&c&d&e&f&g&h&i&j&k&l&m&n&o&p&q&r&s&t&u&v&w&x&y&z",
    @"a&b|c^c=d>a|a&!(a&b|c^c=d>a|a)<>a>b&!cvx;a|!m"
    ];
}

- (void)testIsEqual {
    NyayaNode *a1 = [self nodeWithFormula:@"a&b|c"];
    NyayaNode *a2 = [self nodeWithFormula:@"a∧b∨c"];
    NyayaNode *a3 = [self nodeWithFormula:@"c∨a∧b"];
    
    STAssertEqualObjects(a1, a2, @"nodes should be equal");
    STAssertEqualObjects(a1.nodes, a2.nodes, @"array of subnodes should be equal");
    STAssertEqualObjects([NSSet setWithArray:a2.nodes], [NSSet setWithArray:a3.nodes], @"set of subnodes should be equal");
    
    
    a2 = [self nodeWithFormula:@"a&b"];
    a3 = [self nodeWithFormula:@"b&a"];
    
    a2 = [self nodeWithFormula:@"a>b"];
    a3 = [self nodeWithFormula:@"b>a"];
    STAssertFalse([a2 isEqual:a3], @"implication is not commutative");
}

- (void)testBigIsEqual {
    NyayaNode *a1 = [self nodeWithFormula:@"a+b+c+d+e+f+g+h+i+j+k+m+n+p+q+r+s+t+u+v+w+x+y+z"];
    NyayaNode *a2 = [self nodeWithFormula:@"a∨b∨c∨d∨e∨f∨g∨h∨i∨j∨k∨m∨n∨p∨q∨r∨s∨t∨u∨v∨w∨x∨y∨z"];
    STAssertEqualObjects(a1, a2, nil);
    
}

- (void)testIsNegationOfNode {
    NyayaNode *a0 = [self nodeWithFormula:@"(a&b|c)"];
    NyayaNode *a1 = [self nodeWithFormula:@"!(a&b|c)"];
    NyayaNode *a2 = [self nodeWithFormula:@"!!(a&b|c)"];
    NyayaNode *a3 = [self nodeWithFormula:@"!!!(a&b|c)"];
    NyayaNode *a4 = [self nodeWithFormula:@"!!!!(a&b|c)"];
    
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
