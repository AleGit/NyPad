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
    
    XCTAssertEqualObjects(a1, a2, @"nodes should be equal");
    XCTAssertEqualObjects(a1.nodes, a2.nodes, @"array of subnodes should be equal");
    XCTAssertEqualObjects([NSSet setWithArray:a2.nodes], [NSSet setWithArray:a3.nodes], @"set of subnodes should be equal");
    
    
    a2 = [self nodeWithFormula:@"a&b"];
    a3 = [self nodeWithFormula:@"b&a"];
    
    a2 = [self nodeWithFormula:@"a>b"];
    a3 = [self nodeWithFormula:@"b>a"];
    XCTAssertFalse([a2 isEqual:a3], @"implication is not commutative");
}

- (void)testBigIsEqual {
    NyayaNode *a1 = [self nodeWithFormula:@"a+b+c+d+e+f+g+h+i+j+k+m+n+p+q+r+s+t+u+v+w+x+y+z"];
    NyayaNode *a2 = [self nodeWithFormula:@"a∨b∨c∨d∨e∨f∨g∨h∨i∨j∨k∨m∨n∨p∨q∨r∨s∨t∨u∨v∨w∨x∨y∨z"];
    XCTAssertEqualObjects(a1, a2);
    
}

- (void)testIsNegationOfNode {
    NyayaNode *a0 = [self nodeWithFormula:@"(a&b|c)"];
    NyayaNode *a1 = [self nodeWithFormula:@"!(a&b|c)"];
    NyayaNode *a2 = [self nodeWithFormula:@"!!(a&b|c)"];
    NyayaNode *a3 = [self nodeWithFormula:@"!!!(a&b|c)"];
    NyayaNode *a4 = [self nodeWithFormula:@"!!!!(a&b|c)"];
    
    XCTAssertFalse([a0 isNegationToNode:a0]);
    
    XCTAssertTrue([a0 isNegationToNode:a1]);
    XCTAssertTrue([a1 isNegationToNode:a0]);
    
    XCTAssertTrue([a2 isNegationToNode:a1]);
    XCTAssertTrue([a1 isNegationToNode:a2]);
    
    XCTAssertTrue([a2 isNegationToNode:a3]);
    XCTAssertTrue([a3 isNegationToNode:a2]);
    
    XCTAssertTrue([a4 isNegationToNode:a3]);
    XCTAssertTrue([a3 isNegationToNode:a4]);
}

@end
