//
//  DescriptionTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DescriptionTests.h"
#import "SenTestCase+NyayaTests.h"
#import "NyayaNode+Description.h"
#import "NyayaFormula.h"

@implementation DescriptionTests

- (void)testDescriptionSubformula {
    
    NyayaNode *formula = [[NyayaFormula formulaWithString:@"a | b & c"] syntaxTree:NO];
    
    NSArray *descs = @[ [formula description:formula] // AND 
    ,[formula description: [formula nodeAtIndex:0]] // a
    ,[formula description: [formula nodeAtIndex:1]] // OR
    ,[formula description: [[formula nodeAtIndex:1] nodeAtIndex:0]] // b
    ,[formula description: [[formula nodeAtIndex:1] nodeAtIndex:1]] // c
    ];
    
    XCTAssertEqualObjects([descs objectAtIndex:0], @"[ a ∨ (b ∧ c) ]");
    XCTAssertEqualObjects([descs objectAtIndex:1], @"[ a ] ∨ (b ∧ c)");
    XCTAssertEqualObjects([descs objectAtIndex:2], @"a ∨ ([ b ∧ c ])");
    XCTAssertEqualObjects([descs objectAtIndex:3], @"a ∨ ([ b ] ∧ c)");
    XCTAssertEqualObjects([descs objectAtIndex:4], @"a ∨ (b ∧ [ c ])");
}

@end
