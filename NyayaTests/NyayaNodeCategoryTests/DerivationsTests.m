//
//  DerivationsTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DerivationsTests.h"
#import "SenTestCase+NyayaTests.h"
#import "NyayaNode+Derivations.h"
#import "NyayaFormula.h"

@implementation DerivationsTests

- (NyayaNode*)nodeWithFormula:(NSString*)input {
    return [[NyayaFormula formulaWithString:input] syntaxTree:NO];
}

- (void)testSubNodeSet {
    
    NyayaNode *node = [self nodeWithFormula:@"a"];
    NyayaNode *a = node;
    NSSet *set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)1, nil);
    
    node = [self nodeWithFormula:@"a|a"];
    set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)2, nil); // a, a|a
    
    node = [self nodeWithFormula:@"(a|b)&(a|b)"];
    set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)4, nil);
    
    node = [self nodeWithFormula:@"(a>b)|((a>b)&c)"];
    set = [node subNodeSet];
    STAssertEquals([set count], (NSUInteger)6, nil);
    
    
    STAssertTrue([set containsObject:a], nil);
    NSArray* array = [set allObjects];
    NSUInteger idx = [array indexOfObject:a];
    STAssertTrue(idx != NSNotFound, nil);
    NyayaNode *a2 = [array objectAtIndex:idx];
    STAssertFalse(a == a2, nil);
    STAssertTrue([a isEqual:a2], nil);
    
}

- (void)testAllreadyImplicationFree {
    for (NSString *input in @[@"!a", @"!a", @"a|b"
         ]) {
        NyayaNode *n = [self nodeWithFormula:input];
        NyayaNode *i = [n deriveImf:NSIntegerMax];
        STAssertEqualObjects(i, n, nil);
    }
}

- (void)testImplicationImf {
    NyayaNode *n = [self nodeWithFormula:@"a>b"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"!a|b"];
    STAssertEqualObjects(i, e, nil);
}

- (void)testBiconditionalImf {
    NyayaNode *n = [self nodeWithFormula:@"a=b"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"(!a|b)&(!b|a)"];
    STAssertEqualObjects(i, e, nil);
}



- (void)testFxorT {
    NyayaNode *n = [self nodeWithFormula:@"F^T"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"(F|T)&(!F|!T)"];
    STAssertEqualObjects(i, e, nil);
}


- (void)testXorImf {
    NyayaNode *n = [self nodeWithFormula:@"a^b"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"(a|b)&(!a|!b) "];
    STAssertEqualObjects(i, e, nil);
    
    
}



@end
