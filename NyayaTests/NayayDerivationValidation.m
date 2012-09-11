//
//  NayayDerivationValidation.m
//  Nyaya
//
//  Created by Alexander Maringele on 02.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NayayDerivationValidation.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "TruthTable.h"
#import "BddNode.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Valuation.h"

@implementation NayayDerivationValidation

- (BOOL)validateDerivations:(NSString*)input; {
    NyayaParser *parser = [[NyayaParser alloc] initWithString: input];
    NyayaNode *frm = [parser parseFormula];
    NyayaNode *imf = [frm deriveImf:NSIntegerMax];
    NyayaNode *nnf = [imf deriveNnf:NSIntegerMax];
    NyayaNode *cnf = [imf deriveCnf:NSIntegerMax];
    NyayaNode *dnf = [imf deriveDnf:NSIntegerMax];
    
    
    NSArray* truthTables = @[
    [[TruthTable alloc] initWithNode:frm],
    [[TruthTable alloc] initWithNode:imf],
    [[TruthTable alloc] initWithNode:nnf],
    [[TruthTable alloc] initWithNode:cnf],
    [[TruthTable alloc] initWithNode:dnf]
    ];
    
        
    
    [truthTables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj evaluateTable];
        if (idx > 0) {
            STAssertEqualObjects([truthTables objectAtIndex:idx-1], obj, input);
        }
    }];
    
    TruthTable *truthTable = [truthTables objectAtIndex:0];
    BddNode *bddNode = [BddNode bddWithTruthTable:truthTable reduce:YES];
    
    NSString *cnfDescription = bddNode.cnfDescription;
//    NSString *dnfDescription = [bddNode dnfDescription];
    
    for (NyayaNode* variable in frm.setOfVariables) {
        if ( [cnfDescription rangeOfString:variable.symbol].length == 0) {
            cnfDescription = [cnfDescription stringByAppendingFormat:@" & (%1$@ | !%1$@)", variable.symbol]; // add optimized variables for truth table comparison
        }
        
//        if ( [dnfDescription rangeOfString:variable.symbol].length == 0) {
//            dnfDescription = [dnfDescription stringByAppendingFormat:@" | (%1$@ & !%1$@)", variable.symbol]; // add optimized variables for truth table comparison
//        }
        
    }
    
    NyayaParser *cnfParser = [[NyayaParser alloc] initWithString:cnfDescription];
//    NyayaParser *dnfParser = [[NyayaParser alloc] initWithString:dnfDescription];
    

    NyayaNode *cnfFrm = [cnfParser parseFormula];
//    NyayaNode *dnfFrm = [dnfParser parseFormula];
    
    truthTables = @[
    [[TruthTable alloc] initWithNode:cnfFrm]
//    ,[[TruthTable alloc] initWithNode:dnfFrm]
    ];
    
    
    [truthTables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj evaluateTable];
        STAssertEqualObjects(truthTable, obj, [truthTable.formula description]);
    }];
    
    

    
    return YES;
}

- (void)testABC {
    for (NSString *input in @[@"a",@"!a", @"a & a", @"!a | !a", @"a | b & c"
         , @" a ^ b", @" a <> b", @"a&b|c>a^b=a;a&!b|!c"]) {
        [self validateDerivations:input];
        
    }
}


@end
