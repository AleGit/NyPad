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
    XCTAssertEqualObjects(@"U", _u.symbol);
    XCTAssertEqual((NyayaBool)NyayaUndefined, _u.displayValue);
    XCTAssertEqualObjects(@"F", _f.symbol);
    XCTAssertEqual((NyayaBool)NyayaFalse, _f.displayValue);
    XCTAssertEqualObjects(@"T", _t.symbol);
    XCTAssertEqual((NyayaBool)NyayaTrue, _t.displayValue);
}


- (void)testNegation {
    NyayaNode *n = nil;
    
    // ¬u
    
    n = [NyayaNode negation:_u];
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    // ¬f
    
    n = [NyayaNode negation:_f];
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    // ¬t
    
    n = [NyayaNode negation:_t];
    XCTAssertEqualObjects(@"¬", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaNegation, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
}

- (void)testConjunction {
    NyayaNode *n = nil;
    
    // u ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_u with:_u];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode conjunction:_u with:_f];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    n = [NyayaNode conjunction:_u with:_t];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    // f ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_f with:_u];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    n = [NyayaNode conjunction:_f with:_f];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    n = [NyayaNode conjunction:_f with:_t];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    // t ∧ {u,f,t}
    
    n = [NyayaNode conjunction:_t with:_u];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode conjunction:_t with:_f];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    n = [NyayaNode conjunction:_t with:_t];
    XCTAssertEqualObjects(@"∧", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaConjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    
}



- (void)testDisjunction {
    NyayaNode *n = nil;
    
    // u ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_u with:_u];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode disjunction:_u with:_f];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode disjunction:_u with:_t];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    // f ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_f with:_u];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode disjunction:_f with:_f];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    n = [NyayaNode disjunction:_f with:_t];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    // t ∨ {u,f,t}
    
    n = [NyayaNode disjunction:_t with:_u];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    n = [NyayaNode disjunction:_t with:_f];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    n = [NyayaNode disjunction:_t with:_t];
    XCTAssertEqualObjects(@"∨", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaDisjunction, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    
}

- (void)testImplication {
    NyayaNode *n = nil;
    
    // u → {u,f,t}
    
    n = [NyayaNode implication: _u with:_u];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode implication:_u with:_f];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode implication:_u with:_t];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    // f → {u,f,t}
    
    n = [NyayaNode implication:_f with:_u];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    n = [NyayaNode implication:_f with:_f];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    n = [NyayaNode implication:_f with:_t];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    // t → {u,f,t}
    
    n = [NyayaNode implication:_t with:_u];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaUndefined, n.displayValue);
    
    n = [NyayaNode implication:_t with:_f];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaFalse, n.displayValue);
    
    n = [NyayaNode implication:_t with:_t];
    XCTAssertEqualObjects(@"→", n.symbol);
    XCTAssertEqual((NyayaNodeType)NyayaImplication, n.type);
    XCTAssertEqual((NyayaBool)NyayaTrue, n.displayValue);
    
    
}


@end
