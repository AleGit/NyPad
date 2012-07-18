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
    
    
        
    NSString *c = [[ast sortedSubformulas] componentsJoinedByString:@"; "];
    STAssertEqualObjects(c, @"a; b; a ∧ b; (a ∧ b) ∨ a",nil);

}

@end