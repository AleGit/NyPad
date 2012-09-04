//
//  NyayaNodeVariablesTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeVariablesTests.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Derivations.h"

#import "NyayaNode+Valuation.h"

@implementation NyayaNodeVariablesTests

- (void)testBasicVariables {
    NyayaNode *a = [NyayaNode atom:@"a"];
    NyayaNode *b = [NyayaNode atom:@"b"];
    NyayaNode *c = [NyayaNode atom:@"c"];
    NyayaNode *d = [NyayaNode atom:@"d"];
    
    NyayaNode *aAb = [NyayaNode conjunction:a with:b];
    aAb = [NyayaNode disjunction:aAb with:a];
    aAb = [NyayaNode negation:aAb];
    aAb = [[[[NyayaNode implication:b with:aAb] imf] nnf] cnf];
    
    NSSet *set = [aAb setOfVariables];
    STAssertEquals([set count], (NSUInteger)2,nil);
    STAssertTrue([set containsObject:a], nil);
    STAssertTrue([set containsObject:b], nil);
    STAssertTrue(![set containsObject:c], nil);
    STAssertTrue(![set containsObject:d], nil);
    
    
}

@end
