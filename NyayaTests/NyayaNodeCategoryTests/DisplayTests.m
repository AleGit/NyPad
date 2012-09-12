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


@implementation DisplayTests

- (void)testDisplayTop {
    NyayaNode *top = [NyayaNode top];
    STAssertEquals(top.displayValue, (NyayaBool)NyayaTrue, nil);
}

- (void)testDisplayBottom {
    NyayaNode *top = [NyayaNode bottom];
    STAssertEquals(top.displayValue, (NyayaBool)NyayaFalse, nil);
}

- (void)testDisplayA {
    NyayaNode *a = [self nodeWithFormula:@"a"];
    ((NyayaNodeVariable*)a).displayValue = NyayaTrue;
    STAssertEquals(a.displayValue, (NyayaBool)NyayaTrue, @"%d",a.displayValue);
    ((NyayaNodeVariable*)a).displayValue = NyayaFalse;
    STAssertEquals(a.displayValue, (NyayaBool)NyayaFalse, @"%d",a.displayValue);
}

@end
