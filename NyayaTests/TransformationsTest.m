//
//  TransformationsTest.m
//  Nyaya
//
//  Created by Alexander Maringele on 19.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TransformationsTest.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Reductions.h"

#import "NyayaNode+Transformations.h"

@implementation TransformationsTest

- (void)testTransformation {
    NyayaNode *a = [NyayaNode atom:@"a"];
    NyayaNode *b = [NyayaNode atom:@"b"];
    NyayaNode *ab = [NyayaNode conjunction:a with:b];
    
    NyayaNode *node = [ab nodeByReplacingNodeAtIndexPath:[NSIndexPath indexPathWithIndex:1] withNode:ab];
    node = [node nodeByReplacingNodeAtIndexPath:[NSIndexPath indexPathWithIndex:0] withNode:[NyayaNode negation:a]];
    node = [node substitute:nil];
    
    STAssertEqualObjects([ab description], @"a ∧ b", nil);
    STAssertEqualObjects([node description], @"¬a ∧ (a ∧ b)", nil);
}

@end
