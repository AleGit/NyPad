//
//  TruthTableNormalFormsTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 23.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TruthTableNormalFormsTests.h"
#import "NyayaParser.h"
#import "TruthTable.h"

@implementation TruthTableNormalFormsTests

- (TruthTable*)truthTableWithInput: (NSString*)input {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
    NyayaNode *formula = parser.parseFormula;
    TruthTable *truthTable = [[TruthTable alloc] initWithNode: formula];
    [truthTable evaluateTable];
    return truthTable;
    
}

- (void)testTrueTop {
    NSSet *expectedDnf = [NSSet setWithObject:[NSSet set]];         // OR ( AND (EMPTY) ) = TRUE
    NSSet *expectedCnf = [NSSet set];                               // AND ( EMPTY ) = TRUE

    for (NSString *input in @[@"x+!x",@"!(x&!x)", @"T", @"!F",@"!(x&!x)|(z>a)",@"(x&!x)|T"]) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        STAssertEqualObjects(truthTable.cnfSet, expectedCnf, input);
        STAssertEqualObjects(truthTable.dnfSet, expectedDnf, input);
    }
}
- (void)testFalseBottom {
    NSSet *expectedCnf = [NSSet setWithObject:[NSSet set]];         // AND ( OR (EMPTY) ) = FALSE
    NSSet *expectedDnf = [NSSet set];                               // OR ( EMPTY ) = FALSE
    
    for (NSString *input in @[@"x&!x",@"!(x|!x)", @"!T", @"F",@"F&(x|!x)"]) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        STAssertEqualObjects(truthTable.cnfSet, expectedCnf, input);
        STAssertEqualObjects(truthTable.dnfSet, expectedDnf, input);
    }  
}

- (void)testX_and_Y {
    NSSet *expectedDnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"x",@"y"]] ]];
    NSSet *expectedCnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"x"]], [NSSet setWithArray:@[@"y"]] ]];
    
    for ( NSString *input in @[ @" x & y ", @"!(!x|!y)"]) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        STAssertEqualObjects(truthTable.cnfSet, expectedCnf, input);
        STAssertEqualObjects(truthTable.dnfSet, expectedDnf, input);
    }
}

- (void)testX_or_Y {
    NSSet *expectedCnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"x",@"y"]] ]];
    NSSet *expectedDnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"x"]], [NSSet setWithArray:@[@"y"]] ]];
    
    
    for ( NSString *input in @[ @" x | y ", @"!(!x&!y)", @" x | y | !!x | !!y"] ) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        STAssertEqualObjects(truthTable.cnfSet, expectedCnf, input);
        STAssertEqualObjects(truthTable.dnfSet, expectedDnf, input);
    }
}

- (void)testX_xor_Y {
    NSSet *expectedCnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"x",@"y"]], [NSSet setWithArray:@[@"¬x",@"¬y"]] ]];
    NSSet *expectedDnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"¬x",@"y"]], [NSSet setWithArray:@[@"x",@"¬y"]] ]];
    
    for ( NSString *input in @[ @" x ^ y ", @"!(x<>y)"] ) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        STAssertEqualObjects(truthTable.cnfSet, expectedCnf, input);
        STAssertEqualObjects(truthTable.dnfSet, expectedDnf, input); 
    }
}

- (void)testX_bic_Y {
    NSSet *expectedDnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"x",@"y"]], [NSSet setWithArray:@[@"¬x",@"¬y"]] ]];
    NSSet *expectedCnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"¬x",@"y"]], [NSSet setWithArray:@[@"x",@"¬y"]] ]];
    
    for ( NSString *input in @[ @" !(x ^ y) ", @"(x<>y)"] ) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        STAssertEqualObjects(truthTable.cnfSet, expectedCnf, input);
        STAssertEqualObjects(truthTable.dnfSet, expectedDnf, input);  
    }
}

- (void)testX_impl_Y {
    NSSet *expectedDnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"¬x",]], [NSSet setWithArray:@[@"y"]] ]];
    NSSet *expectedCnf = [NSSet setWithArray: @[ [NSSet setWithArray:@[@"¬x",@"y"]] ]];
    
    for ( NSString *input in @[ @" x > y", @"!x|y", @"!(x&!y)"] ) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        STAssertEqualObjects(truthTable.cnfSet, expectedCnf, input);
        STAssertEqualObjects(truthTable.dnfSet, expectedDnf, input);       
    }
}




@end
