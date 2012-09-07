//
//  NyayaAssociativityTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaAssociativityTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "TruthTable.h"

@implementation NyayaAssociativityTests

- (void)testAndAssociativity {
    NSArray *inputs = @[@"a.b.c",@"(a.b).c",@"a.(b.c)",@"a;b;c",@"a&b&c"];
    NSMutableArray *truthTables = [NSMutableArray arrayWithCapacity:[inputs count]];
    
    for (NSString *input in inputs) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *formula = [parser parseFormula];
        TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
        [truthTable evaluateTable];
        [truthTables addObject:truthTable];
    }
    
    [truthTables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STAssertEqualObjects(obj, [truthTables objectAtIndex:(idx + 1) % [inputs count]], nil);
    }];
}


- (void)testOrAssociativity {
    NSArray *inputs = @[@"a+b+c",@"(a+b)+c",@"a+(b+c)"];
    NSMutableArray *truthTables = [NSMutableArray arrayWithCapacity:[inputs count]];
    
    for (NSString *input in inputs) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *formula = [parser parseFormula];
        TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
        [truthTable evaluateTable];
        [truthTables addObject:truthTable];
    }
    
    [truthTables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STAssertEqualObjects(obj, [truthTables objectAtIndex:(idx + 1) % [inputs count]], nil);
    }];
}

- (void)testBicAssociativity {
    NSArray *inputs = @[@"a=b=c",@"(a=b)=c",@"a=(b=c)",@"a<>b<>c"];
    NSMutableArray *truthTables = [NSMutableArray arrayWithCapacity:[inputs count]];
    
    for (NSString *input in inputs) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *formula = [parser parseFormula];
        TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
        [truthTable evaluateTable];
        [truthTables addObject:truthTable];
    }
    
    [truthTables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STAssertEqualObjects(obj, [truthTables objectAtIndex:(idx + 1) % [inputs count]], nil);
    }];
}
- (void)testXorAssociativity {
    NSArray *inputs = @[@"a^b^c",@"(a^b)^c",@"a^(b^c)",@"a⊕b⊕c"];
    NSMutableArray *truthTables = [NSMutableArray arrayWithCapacity:[inputs count]];
    
    for (NSString *input in inputs) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *formula = [parser parseFormula];
        TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
        [truthTable evaluateTable];
        [truthTables addObject:truthTable];
    }
    
    [truthTables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STAssertEqualObjects(obj, [truthTables objectAtIndex:(idx + 1) % [inputs count]], nil);
    }];
}


- (void)testImpRightAssociativity {
    NSArray *inputs = @[@"a>b>c",@"(a>b)>c",@"a>(b>c)"];
    NSMutableArray *truthTables = [NSMutableArray arrayWithCapacity:[inputs count]];
    
    for (NSString *input in inputs) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
        NyayaNode *formula = [parser parseFormula];
        TruthTable *truthTable = [[TruthTable alloc] initWithNode:formula];
        [truthTable evaluateTable];
        [truthTables addObject:truthTable];
    }
    
    STAssertFalse([[truthTables objectAtIndex:0] isEqual: [truthTables objectAtIndex:1]], nil);
    STAssertFalse([[truthTables objectAtIndex:1] isEqual: [truthTables objectAtIndex:2]], nil);
    STAssertTrue([[truthTables objectAtIndex:2] isEqual: [truthTables objectAtIndex:0]], nil);
    
}

@end
