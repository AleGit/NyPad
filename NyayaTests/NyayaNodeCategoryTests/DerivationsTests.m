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
    XCTAssertEqual([set count], (NSUInteger)1);
    
    node = [self nodeWithFormula:@"a|a"];
    set = [node subNodeSet];
    XCTAssertEqual([set count], (NSUInteger)2); // a, a|a
    
    node = [self nodeWithFormula:@"(a|b)&(a|b)"];
    set = [node subNodeSet];
    XCTAssertEqual([set count], (NSUInteger)4);
    
    node = [self nodeWithFormula:@"(a>b)|((a>b)&c)"];
    set = [node subNodeSet];
    XCTAssertEqual([set count], (NSUInteger)6);
    
    
    XCTAssertTrue([set containsObject:a]);
    NSArray* array = [set allObjects];
    NSUInteger idx = [array indexOfObject:a];
    XCTAssertTrue(idx != NSNotFound);
    NyayaNode *a2 = [array objectAtIndex:idx];
    XCTAssertFalse(a == a2);
    XCTAssertTrue([a isEqual:a2]);
    
}

- (void)testAllreadyImplicationFree {
    for (NSString *input in @[@"!a", @"!a", @"a|b"
         ]) {
        NyayaNode *n = [self nodeWithFormula:input];
        NyayaNode *i = [n deriveImf:NSIntegerMax];
        XCTAssertEqualObjects(i, n);
    }
}

- (void)testImplicationImf {
    NyayaNode *n = [self nodeWithFormula:@"a>b"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"!a|b"];
    XCTAssertEqualObjects(i, e);
}

- (void)testBiconditionalImf {
    NyayaNode *n = [self nodeWithFormula:@"a=b"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"(!a|b)&(!b|a)"];
    XCTAssertEqualObjects(i, e);
}



- (void)testFxorT {
    NyayaNode *n = [self nodeWithFormula:@"F^T"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"(F|T)&(!F|!T)"];
    XCTAssertEqualObjects(i, e);
}


- (void)testXorImf {
    NyayaNode *n = [self nodeWithFormula:@"a^b"];
    NyayaNode *i = [n deriveImf:NSIntegerMax];
    NyayaNode *e = [self nodeWithFormula:@"(a|b)&(!a|!b) "];
    XCTAssertEqualObjects(i, e);
    
    
}



@end
