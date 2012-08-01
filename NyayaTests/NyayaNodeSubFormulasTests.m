//
//  NyayaNodeSubFormulasTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeSubFormulasTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"

@implementation NyayaNodeSubFormulasTests

- (void)testTest {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a & b | a"];
    NyayaNode *ast = [parser parseFormula];
    NSString *description = [ast description];
    STAssertEqualObjects(description, @"(a ∧ b) ∨ a",nil);
    
    NSSet *set = [ast setOfSubformulas];
    
    STAssertEquals([set count], (NSUInteger)4, nil);
    STAssertTrue([set containsObject:@"a"], nil);
    STAssertTrue([set containsObject:@"b"], nil);
    STAssertTrue([set containsObject:@"a ∧ b"], nil);
    STAssertTrue([set containsObject:@"(a ∧ b) ∨ a"], nil);

}

@end
