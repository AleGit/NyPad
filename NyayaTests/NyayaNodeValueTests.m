//
//  NyayaNodeTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeValueTests.h"
#import "NyayaNode.h" 
#import "NyayaParser.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Display.h"
#import "NyayaNode+Type.h"

@interface NyayaNodeValueTests () {
    NyayaNode *_u;
    NyayaNode *_f;
    NyayaNode *_t;
}

@end

@implementation NyayaNodeValueTests

- (void)setUp
{
    [super setUp];
    
    _u = [NyayaNode atom:@"U"];
    _f = [NyayaNode atom:@"F"];
    _t = [NyayaNode atom:@"T"];

}

- (void)tearDown
{
    _u = nil;
    _f = nil;
    _t = nil;
    
    [super tearDown];
}

- (void)testUFT {
    STAssertEqualObjects(@"U", _u.symbol, nil);
    STAssertEquals((NyayaBool)NyayaUndefined, _u.displayValue, nil);
    STAssertEqualObjects(@"F", _f.symbol, nil);
    STAssertEquals((NyayaBool)NyayaFalse, _f.displayValue, nil);
    STAssertEqualObjects(@"T", _t.symbol, nil);
    STAssertEquals((NyayaBool)NyayaTrue, _t.displayValue, nil);
}


- (void)testNegation {
    NyayaNode *n = nil;
    
    // ¬u
    
    n = [NyayaNode negation:_u];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    // ¬f
    
    n = [NyayaNode negation:_f];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    // ¬t
    
    n = [NyayaNode negation:_t];
    STAssertEqualObjects(@"¬", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaNegation, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
}

- (void)testConjunction {
    NyayaNode *n = nil;
    
    // u ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_u with:_u];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode conjunction:_u with:_f];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    n = [NyayaNode conjunction:_u with:_t];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    // f ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_f with:_u];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    n = [NyayaNode conjunction:_f with:_f];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    n = [NyayaNode conjunction:_f with:_t];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    // t ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_t with:_u];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode conjunction:_t with:_f];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    n = [NyayaNode conjunction:_t with:_t];
    STAssertEqualObjects(@"∧", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaConjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    
}



- (void)testDisjunction {
    NyayaNode *n = nil;
    
    // u ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_u with:_u];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode disjunction:_u with:_f];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode disjunction:_u with:_t];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    // f ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_f with:_u];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode disjunction:_f with:_f];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    n = [NyayaNode disjunction:_f with:_t];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    // t ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_t with:_u];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    n = [NyayaNode disjunction:_t with:_f];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    n = [NyayaNode disjunction:_t with:_t];
    STAssertEqualObjects(@"∨", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaDisjunction, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    
}

- (void)testImplication {
    NyayaNode *n = nil;
    
    // u → {u,f,t}
    
    n = [NyayaNode implication: _u with:_u];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode implication:_u with:_f];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode implication:_u with:_t];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    // f → {u,f,t}
    
    n = [NyayaNode implication:_f with:_u];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    n = [NyayaNode implication:_f with:_f];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    n = [NyayaNode implication:_f with:_t];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    // t → {u,f,t}
    
    n = [NyayaNode implication:_t with:_u];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaUndefined, n.displayValue, nil);
    
    n = [NyayaNode implication:_t with:_f];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaFalse, n.displayValue, nil);
    
    n = [NyayaNode implication:_t with:_t];
    STAssertEqualObjects(@"→", n.symbol, nil);
    STAssertEquals((NyayaNodeType)NyayaImplication, n.type,nil);
    STAssertEquals((NyayaBool)NyayaTrue, n.displayValue, nil);
    
    
}


@end
