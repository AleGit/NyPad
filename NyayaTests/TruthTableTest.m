//
//  TruthTableTest.m
//  Nyaya
//
//  Created by Alexander Maringele on 24.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TruthTableTest.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "NyayaTruthTable.h"

@implementation TruthTableTest

- (void)testSimple {
    NyayaParser *parser = [NyayaParser parserWithString:@"!x&y | (x > y)"];
    
    NyayaNode *formula = [parser parseFormula];
    
    NyayaTruthTable *truthTable = [[NyayaTruthTable alloc] initWithFormula:formula];
    
    STAssertEqualObjects(truthTable.formula, formula,nil);
    STAssertEqualObjects(truthTable.title, @"x ∧ y",nil);
    
    [truthTable evaluateTable];
    
    NSString *expected =
    @"| x | y | x ∧ y |\n"
    @"| F | F | F     |\n"
    @"| F | T | F     |\n"
    @"| T | F | F     |\n"
    @"| T | T | T     |\n";
    
    NSString *actual = truthTable.description;
    NSLog(@"\n%@", actual);
    STAssertEqualObjects(actual, expected,nil);
    
}

@end
