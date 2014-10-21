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
#import "NyayaNode+Valuation.h"

@implementation NyayaNodeSubFormulasTests

- (void)testTest {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a & b | a"];
    NyayaNode *ast = [parser parseFormula];
    NSString *description = [ast description];
    XCTAssertEqualObjects(description, @"(a ∧ b) ∨ a");
    
    NSSet *set = [ast setOfSubformulas];
    
    XCTAssertEqual([set count], (NSUInteger)4);
    XCTAssertTrue([set containsObject:@"a"]);
    XCTAssertTrue([set containsObject:@"b"]);
    XCTAssertTrue([set containsObject:@"a ∧ b"]);
    XCTAssertTrue([set containsObject:@"(a ∧ b) ∨ a"]);

}

@end
