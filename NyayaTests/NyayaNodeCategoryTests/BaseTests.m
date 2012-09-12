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
@interface BaseTests () {
    NSArray *_bigFormulas;
}
@end

@implementation BaseTests

- (void)setUp {
    _bigFormulas = @[
    @"a&b&c&d&e&f&g&h&i&j&k&l&m&n&o&p&q&r&s&t&u&v&w&x&y&z",
    @"a&b|c^c=d>a|a&!(a&b|c^c=d>a|a)<>a>b&!cvx;a|!m"
    ];
}

- (void)testIsEqual {
    NyayaNode *a1 = [NyayaNode nodeWithFormula:@"a&b|c"];
    NyayaNode *a2 = [NyayaNode nodeWithFormula:@"a∧b∨c"];
    NyayaNode *a3 = [NyayaNode nodeWithFormula:@"c∨a∧b"];
    
    STAssertEqualObjects(a1, a2, @"nodes should be equal");
    STAssertEqualObjects(a1.nodes, a2.nodes, @"array of subnodes should be equal");
    STAssertEqualObjects([NSSet setWithArray:a2.nodes], [NSSet setWithArray:a3.nodes], @"set of subnodes should be equal");
    STAssertEqualObjects(a2, a3, @"nodes should be equal");
    
    a2 = [NyayaNode nodeWithFormula:@"a&b"];
    a3 = [NyayaNode nodeWithFormula:@"b&a"];
    STAssertEqualObjects(a2, a3, @"conjunction is commutative");
    
    a2 = [NyayaNode nodeWithFormula:@"a>b"];
    a3 = [NyayaNode nodeWithFormula:@"b>a"];
    STAssertFalse([a2 isEqual:a3], @"implication is not commutative");
}

- (void)testBigIsEqual {
    NyayaNode *a1 = [NyayaNode nodeWithFormula:@"a+b+c+d+e+f+g+h+i+j+k+m+n+p+q+r+s+t+u+v+w+x+y+z"];
    NyayaNode *a2 = [NyayaNode nodeWithFormula:@"a∨b∨c∨d∨e∨f∨g∨h∨i∨j∨k∨m∨n∨p∨q∨r∨s∨t∨u∨v∨w∨x∨y∨z"];
    STAssertEqualObjects(a1, a2, nil);
    
}

- (void)testIsNegationOfNode {
    NyayaNode *a0 = [NyayaNode nodeWithFormula:@"(a&b|c)"];
    NyayaNode *a1 = [NyayaNode nodeWithFormula:@"!(a&b|c)"];
    NyayaNode *a2 = [NyayaNode nodeWithFormula:@"!!(a&b|c)"];
    NyayaNode *a3 = [NyayaNode nodeWithFormula:@"!!!(a&b|c)"];
    NyayaNode *a4 = [NyayaNode nodeWithFormula:@"!!!!(a&b|c)"];
    
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

- (void)testIsNegationOfBigFormula {
    for (NSString *input in _bigFormulas) {
        
        NyayaNode *a = [NyayaNode nodeWithFormula:input];
        NyayaNode *n = [NyayaNode nodeWithFormula:[NSString stringWithFormat:@"!(%@)", input] ];
        NSDate *begin = [NSDate date];
        STAssertTrue([a isNegationToNode:n], [a description]);
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:begin];
        STAssertTrue(duration < 0.002, @"%f %@", duration, [a description]);
    }
}

- (void)testIsEqualBigFormula {
    for (NSString *input in _bigFormulas) {
        NyayaNode *a = [NyayaNode nodeWithFormula:input];
        NyayaNode *b = [NyayaNode nodeWithFormula:input];
        STAssertFalse(a == b, [a description]);
        NSDate *begin = [NSDate date];
        STAssertEqualObjects(a, b, [a description]);
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:begin];
        STAssertTrue(duration < 0.002, @"%f %@", duration, [a description]);
    }
}

@end
