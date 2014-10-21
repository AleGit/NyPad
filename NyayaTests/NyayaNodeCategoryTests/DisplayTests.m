//
//  DisplayTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 07.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DisplayTests.h"
#import "SenTestCase+NyayaTests.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Display.h"
#import "NyayaFormula.h"


@implementation DisplayTests

- (void)testDisplayTop {
    NyayaNode *top = [NyayaNode top];
    XCTAssertEqual(top.displayValue, (NyayaBool)NyayaTrue);
}

- (void)testDisplayBottom {
    NyayaNode *top = [NyayaNode bottom];
    XCTAssertEqual(top.displayValue, (NyayaBool)NyayaFalse);
}

- (void)testDisplayA {
    NyayaFormula *formula = [NyayaFormula formulaWithString:@"a"];
    NyayaNode *a = [formula syntaxTree:NO];
    ((NyayaNodeVariable*)a).displayValue = NyayaTrue;
    XCTAssertEqual(a.displayValue, (NyayaBool)NyayaTrue, @"%d",a.displayValue);
    ((NyayaNodeVariable*)a).displayValue = NyayaFalse;
    XCTAssertEqual(a.displayValue, (NyayaBool)NyayaFalse, @"%d",a.displayValue);
}

@end
