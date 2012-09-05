//
//  DescriptionTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DescriptionTests.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Description.h"

@implementation DescriptionTests

- (void)testDescriptionSubformula {
    
    NyayaNode *formula = [NyayaNode formulaWithInput:@"a | b & c"];
    
    NSArray *descs = @[ [formula description:formula] // AND 
    ,[formula description: [formula nodeAtIndex:0]] // a
    ,[formula description: [formula nodeAtIndex:1]] // OR
    ,[formula description: [[formula nodeAtIndex:1] nodeAtIndex:0]] // b
    ,[formula description: [[formula nodeAtIndex:1] nodeAtIndex:1]] // c
    ];
    
    STAssertEqualObjects([descs objectAtIndex:0], @"[ a ∨ (b ∧ c) ]", nil);
    STAssertEqualObjects([descs objectAtIndex:1], @"[ a ] ∨ (b ∧ c)", nil);
    STAssertEqualObjects([descs objectAtIndex:2], @"a ∨ ([ b ∧ c ])", nil);
    STAssertEqualObjects([descs objectAtIndex:3], @"a ∨ ([ b ] ∧ c)", nil);
    STAssertEqualObjects([descs objectAtIndex:4], @"a ∨ (b ∧ [ c ])", nil);
}

@end
