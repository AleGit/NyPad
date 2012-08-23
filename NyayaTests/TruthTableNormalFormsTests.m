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
    TruthTable *truthTable = [[TruthTable alloc] initWithFormula: formula];
    [truthTable evaluateTable];
    return truthTable;
    
}

- (void)testTrueTop {
    for (NSString *input in @[@"x+!x",@"!(x&!x)", @"T", @"!F"]) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        
        NSArray *cnf = truthTable.cnfArray;
        NSArray *dnf = truthTable.dnfArray;
        
        STAssertEquals([cnf count], (NSUInteger)0, input);
        STAssertEquals([dnf count], (NSUInteger)1, input);
        STAssertEquals([[dnf objectAtIndex:0] count], (NSUInteger)0, input);
        
        // NSLog(@" T: %@ \n cnf: %@ \n dnf: %@ ", input, cnf, dnf);
    }
}
- (void)testFalseBottom {
    for (NSString *input in @[@"x&!x",@"!(x|!x)", @"!T", @"F"]) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        
        NSArray *cnf = truthTable.cnfArray;
        NSArray *dnf = truthTable.dnfArray;
        
        STAssertEquals([cnf count], (NSUInteger)1, input);
        STAssertEquals([[cnf objectAtIndex:0] count], (NSUInteger)0, input);
        STAssertEquals([dnf count], (NSUInteger)0, input);
        
        // NSLog(@" F: %@ \n cnf: %@ \n dnf: %@ ", input, cnf, dnf);
    }  
}

- (void)testXandY {
    for ( NSString *input in @[ @" x & y ", @"!(!x|!y)"]) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        NSArray *cnf = truthTable.cnfArray;
        NSArray *dnf = truthTable.dnfArray;
        
        STAssertEquals([cnf count], (NSUInteger)2, input);
        STAssertEqualObjects([[cnf objectAtIndex:0] objectAtIndex:0], @"x", input);
        STAssertEqualObjects([[cnf objectAtIndex:1] objectAtIndex:0], @"y", input);
        
        STAssertEquals([dnf count], (NSUInteger)1, input);
        STAssertEquals([[dnf objectAtIndex:0] count],(NSUInteger)2, input);
        
        NSString *x = [[dnf objectAtIndex:0] objectAtIndex:0];
        NSString *y = [[dnf objectAtIndex:0] objectAtIndex:1];
        STAssertEqualObjects(x, @"x", input);
        STAssertEqualObjects(y, @"y", input);
    }
    
    
}

- (void)testXorY {
    for ( NSString *input in @[ @" x | y ", @"!(!x&!y)", @" x | y | !!x | !!y"] ) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        NSArray *cnf = truthTable.cnfArray;
        NSArray *dnf = truthTable.dnfArray;
        
        STAssertEquals([dnf count], (NSUInteger)2, input);
        STAssertEqualObjects([[dnf objectAtIndex:0] objectAtIndex:0], @"x", input);
        STAssertEqualObjects([[dnf objectAtIndex:1] objectAtIndex:0], @"y", input);
        
        STAssertEquals([cnf count], (NSUInteger)1, input);
        STAssertEquals([[cnf objectAtIndex:0] count],(NSUInteger)2, input);
        STAssertEqualObjects([[cnf objectAtIndex:0] objectAtIndex:0], @"x", input);
        STAssertEqualObjects([[cnf objectAtIndex:0] objectAtIndex:1], @"y", input);
    }
    
}

- (void)testX_xor_Y {
    for ( NSString *input in @[ @" x ^ y ", @"!(x<>y)"] ) {
        TruthTable *truthTable = [self truthTableWithInput:input];
        NSArray *cnf = truthTable.cnfArray;
        NSArray *dnf = truthTable.dnfArray;
        
        STAssertEquals([cnf count], (NSUInteger)2, input);
        STAssertEquals([[cnf objectAtIndex:0] count],  (NSUInteger)2, input);
        STAssertEquals([[cnf objectAtIndex:1] count],  (NSUInteger)2, input);
        
        STAssertEquals([dnf count], (NSUInteger)2, input);
        STAssertEquals([[dnf objectAtIndex:0] count],  (NSUInteger)2, input);
        STAssertEquals([[dnf objectAtIndex:1] count],  (NSUInteger)2, input);
        
    }
    
}


@end
