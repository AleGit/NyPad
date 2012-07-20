//
//  DemoTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DemoTests.h"
#import "DemoLeaf.h"

@implementation DemoTests

- (void) testDemoLeafValue {
    NSUInteger l=10, n=24;
    DemoLeaf *leaf = [DemoLeaf leafWithValue:l];
    STAssertEquals(leaf.value, l,@"leaf");
    STAssertEquals(((DemoNode*)leaf).value, l,@"leafnode");
    
    DemoNode *node = [DemoLeaf leafWithValue:n];
    STAssertEquals(node.value, n,@"node");
}

- (void) testDemoNodeValue {
    NSUInteger a=10, b=24;
    DemoNode *leaveA = [DemoLeaf leafWithValue:a];
    DemoNode *leaveB = [DemoLeaf leafWithValue:b];
    DemoNode *node = [[DemoNode alloc] init];
    STAssertEquals(leaveA.value, a,@"leaveA");
    STAssertEquals(leaveB.value, b,@"leaveB");
    STAssertEquals(node.value, (NSUInteger)0,@"leaveB");
    
    
    [leaveA.nodes addObject:leaveA];
    [node.nodes addObject:leaveB];
    
    STAssertEquals(leaveA.value, a,@"leaveA");
    STAssertEquals(node.value, b,@"leaveB");
    
    [node.nodes addObject:leaveA];
    STAssertEquals(node.value, a+b,@"leaveB");


    
}

- (void) testObjectForKey {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"hello" forKey:@"yes"];
    
    STAssertNotNil([dictionary objectForKey:@"yes"],nil);
    STAssertNil([dictionary objectForKey:@"no"],nil);
    
    [dictionary setObject:@"yes, hello" forKey:@"yes"];
    [dictionary setObject:@"no, hello" forKey:@"no"];
    STAssertNotNil([dictionary objectForKey:@"yes"],nil);
    STAssertNotNil([dictionary objectForKey:@"no"],nil);
    
    [dictionary removeObjectForKey:@"yes"];
    STAssertNil([dictionary objectForKey:@"yes"],nil);
    STAssertNotNil([dictionary objectForKey:@"no"],nil);
}

@end
