//
//  NyayaLiteralTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaLiteralTests.h"
#import "NSSet+NyayaLiteral.h"

@interface NyayaLiteralTests () {
    NSSet *_setA, *_setB, *_setC;
}
@end

@implementation NyayaLiteralTests

- (void)setUp {
    _setA = [NSSet setWithObjects:@"a", @"¬b", @"c1", @"a", @"c1", @"a", nil];
    
    _setB = [NSSet setWithObjects:@"a", @"¬b", @"¬c1", @"a", @"c1", @"a", nil];
    
    _setC = [NSSet setWithObjects:@"a", @"¬b", @"c1", @"a", @"c1", @"¬a", nil];
    
    STAssertEquals([_setA count], (NSUInteger)3, nil);
    STAssertEquals([_setB count], (NSUInteger)4, nil);
    STAssertEquals([_setC count], (NSUInteger)4, nil);
    
}

- (void)tearDown {
    _setA = nil, _setB = nil, _setC = nil;
}


- (void)testContainsComplement {
    
    
    STAssertTrue([_setA containsObject:@"a"], nil);
    STAssertFalse([_setA containsObject:@"¬a"], nil);
    
    STAssertFalse([_setA containsContemplementOf:@"a"], nil);
    STAssertTrue([_setA containsContemplementOf:@"¬a"], nil);
    
    
}

- (void)testContains {
    STAssertFalse([_setA containsContemplementaryStrings], nil);
    STAssertTrue([_setB containsContemplementaryStrings], nil);
    STAssertTrue([_setC containsContemplementaryStrings], nil);
}

@end
