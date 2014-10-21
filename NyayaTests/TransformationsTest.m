//
//  TransformationsTest.m
//  Nyaya
//
//  Created by Alexander Maringele on 19.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TransformationsTest.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Reductions.h"
#import "NyayaFormula.h"

#import "NyayaNode+Transformations.h"

@implementation TransformationsTest

- (void)testTransformation {
    NyayaNode *a = [NyayaNode atom:@"a"];
    NyayaNode *b = [NyayaNode atom:@"b"];
    NyayaNode *ab = [NyayaNode conjunction:a with:b];
    
    NyayaNode *node = [ab nodeByReplacingNodeAtIndexPath:[NSIndexPath indexPathWithIndex:1] withNode:ab];
    node = [node nodeByReplacingNodeAtIndexPath:[NSIndexPath indexPathWithIndex:0] withNode:[NyayaNode negation:a]];
    node = [node substitute:nil];
    
    XCTAssertEqualObjects([ab description], @"a ∧ b");
    XCTAssertEqualObjects([node description], @"¬a ∧ (a ∧ b)");
}

- (void)testImfKey {
    NyayaFormula *frm = [NyayaFormula formulaWithString:@"(a>b)|c"];
    NyayaNode *node = [frm syntaxTree:NO];
    XCTAssertNil(node.imfKey);
    XCTAssertEqualObjects([node nodeAtIndex:0].imfKey, @"P→Q=¬P∨Q");
    XCTAssertNil([node nodeAtIndex:1].imfKey);
}

- (void)testCnfKeys {
    NyayaFormula *frm = [NyayaFormula formulaWithString:@"a|b&c; (d&e|f ; g&h|i&j)"];
    NyayaNode *node = [frm syntaxTree:NO];
    NyayaNode *abc = [node nodeAtIndex:0];
    NyayaNode *def = [[node nodeAtIndex:1] nodeAtIndex:0];
    NyayaNode *ghij = [[node nodeAtIndex:1] nodeAtIndex:1];
    
    XCTAssertEqualObjects([abc description], @"a ∨ (b ∧ c)");
    XCTAssertNil(abc.cnfLeftKey);
    XCTAssertEqualObjects(abc.cnfRightKey, @"P∨(Q∧R)=(P∨Q)∧(P∨R)");
    
    XCTAssertEqualObjects([def description], @"(d ∧ e) ∨ f");
    XCTAssertEqualObjects(def.cnfLeftKey, @"(P∧Q)∨R=(P∨R)∧(Q∨R)");
    XCTAssertNil(def.cnfRightKey);
    
    XCTAssertEqualObjects([ghij description], @"(g ∧ h) ∨ (i ∧ j)");
    XCTAssertEqualObjects(ghij.cnfLeftKey, @"(P∧Q)∨R=(P∨R)∧(Q∨R)");
    XCTAssertEqualObjects(ghij.cnfRightKey, @"P∨(Q∧R)=(P∨Q)∧(P∨R)");
}

- (void)testDnfKeys {
    NyayaFormula *frm = [NyayaFormula formulaWithString:@"a&(b|c); ((d|e)&f ; (g|h)&(i|j))"];
    NyayaNode *node = [frm syntaxTree:NO];
    NyayaNode *abc = [node nodeAtIndex:0];
    NyayaNode *def = [[node nodeAtIndex:1] nodeAtIndex:0];
    NyayaNode *ghij = [[node nodeAtIndex:1] nodeAtIndex:1];
    
    XCTAssertEqualObjects([abc description], @"a ∧ (b ∨ c)");
    XCTAssertNil(abc.dnfLeftKey);
    XCTAssertEqualObjects(abc.dnfRightKey, @"P∧(Q∨R)=(P∧Q)∨(P∧R)");
    
    XCTAssertEqualObjects([def description], @"(d ∨ e) ∧ f");
    XCTAssertEqualObjects(def.dnfLeftKey, @"(P∨Q)∧R=(P∧R)∨(Q∧R)");
    XCTAssertNil(def.dnfRightKey);
    
    XCTAssertEqualObjects([ghij description], @"(g ∨ h) ∧ (i ∨ j)");
    XCTAssertEqualObjects(ghij.dnfLeftKey, @"(P∨Q)∧R=(P∧R)∨(Q∧R)");
    XCTAssertEqualObjects(ghij.dnfRightKey, @"P∧(Q∨R)=(P∧Q)∨(P∧R)");
}

- (void)testCnfs {
    NSArray *inputs =       @[@"a+(b∧c)"  , @"(d∧e)+f"              ,@"(g∧h)+(i∧j)"         , @"!a" , @"a+a", @"a∧a",               @"a∧(b+c)"];
    NSArray *leftkeys =     @[@"---"      , @"(P∧Q)∨R=(P∨R)∧(Q∨R)"  ,@"(P∧Q)∨R=(P∨R)∧(Q∨R)" , @"---", @"---", @"---",               @"---"];
    NSArray *rightkeys =    @[@"P∨(Q∧R)=(P∨Q)∧(P∨R)"   , @"---",    @"P∨(Q∧R)=(P∨Q)∧(P∨R)"  , @"---", @"---", @"---",               @"---"];
    
    NSArray *leftDists =    @[@"a ∨ (b ∧ c)", @"(d ∨ f) ∧ (e ∨ f)",  @"(g ∨ (i ∧ j)) ∧ (h ∨ (i ∧ j))", @"¬a", @"a ∨ a" , @"a ∧ a", @"a ∧ (b ∨ c)"];
    NSArray *rightDist =    @[@"(a ∨ b) ∧ (a ∨ c)", @"(d ∧ e) ∨ f",  @"((g ∧ h) ∨ i) ∧ ((g ∧ h) ∨ j)", @"¬a", @"a ∨ a" , @"a ∧ a",@"(a ∧ b) ∨ (a ∧ c)"];
    
    
    [inputs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NyayaFormula *frm = [NyayaFormula formulaWithString:obj];
        NyayaNode *node = [frm syntaxTree:NO];
        
        NSString *leftkey = [node cnfLeftKey];
        NSString *rightkey = [node cnfRightKey];
        XCTAssertEqualObjects(leftkey ? leftkey : @"---", leftkeys[idx], @"%@", obj);
        XCTAssertEqualObjects(rightkey ? rightkey : @"---", rightkeys[idx], @"%@", obj);
        XCTAssertEqualObjects([[node distributedNodeToIndex:0] description], leftDists[idx], @"%@", obj);
        XCTAssertEqualObjects([[node distributedNodeToIndex:1] description], rightDist[idx], @"%@", obj);
    }];
    
}



- (void)testDnfs {
    NSArray *inputs =       @[@"a&(b|c)"  , @"(d|e)&f"              ,@"(g|h)&(i|j)"         , @"!a" , @"a&a", @"a|a",               @"a|(b&c)"];
    NSArray *leftkeys =     @[@"---"      , @"(P∨Q)∧R=(P∧R)∨(Q∧R)"  ,@"(P∨Q)∧R=(P∧R)∨(Q∧R)" , @"---", @"---", @"---",               @"---"];
    NSArray *rightkeys =    @[@"P∧(Q∨R)=(P∧Q)∨(P∧R)"   , @"---",    @"P∧(Q∨R)=(P∧Q)∨(P∧R)"  , @"---", @"---", @"---",               @"---"];

    NSArray *leftDists =    @[@"a ∧ (b ∨ c)", @"(d ∧ f) ∨ (e ∧ f)",  @"(g ∧ (i ∨ j)) ∨ (h ∧ (i ∨ j))", @"¬a", @"a ∧ a" , @"a ∨ a", @"a ∨ (b ∧ c)"];
    NSArray *rightDist =    @[@"(a ∧ b) ∨ (a ∧ c)", @"(d ∨ e) ∧ f",  @"((g ∨ h) ∧ i) ∨ ((g ∨ h) ∧ j)", @"¬a", @"a ∧ a" , @"a ∨ a",@"(a ∨ b) ∧ (a ∨ c)"];
    
    
    [inputs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NyayaFormula *frm = [NyayaFormula formulaWithString:obj];
        NyayaNode *node = [frm syntaxTree:NO];
        
        NSString *leftkey = [node dnfLeftKey];
        NSString *rightkey = [node dnfRightKey];
        XCTAssertEqualObjects(leftkey ? leftkey : @"---", leftkeys[idx], @"%@", obj);
        XCTAssertEqualObjects(rightkey ? rightkey : @"---", rightkeys[idx], @"%@", obj);
        XCTAssertEqualObjects([[node distributedNodeToIndex:0] description], leftDists[idx], @"%@", obj);
        XCTAssertEqualObjects([[node distributedNodeToIndex:1] description], rightDist[idx], @"%@", obj);
    }];
    
}


- (void)testImfs {
    
    
    NSArray *inputs = @[@"a>b"      , @"!a" , @"a&a", @"a|a"];
    NSArray *keys = @[@"P→Q=¬P∨Q"   , @"---", @"---", @"---"];
    NSArray *trans = @[@"¬a ∨ b"    , @"¬a", @"a ∧ a", @"a ∨ a"];
    
    [inputs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NyayaFormula *frm = [NyayaFormula formulaWithString:obj];
        NyayaNode *node = [frm syntaxTree:NO];
        
        NSString *key = [node imfKey];
        XCTAssertEqualObjects(key ? key : @"---", keys[idx], @"%@", obj);
        XCTAssertEqualObjects([[node imfNode] description], trans[idx], @"%@", obj);
    }];
}


- (void)testNffs {
    NSArray *inputs = @[@"!!a"  , @"!(b&c)"         , @"!(d|e)"         , @"!a", @"a&a", @"a|a"];
    NSArray *keys = @[@"¬¬P=P"  , @"¬(P∧Q)=¬P∨¬Q"   , @"¬(P∨Q)=¬P∧¬Q"   , @"---", @"---", @"---"];
    NSArray *trans = @[@"a"     , @"¬b ∨ ¬c"        , @"¬d ∧ ¬e"        , @"¬a", @"a ∧ a", @"a ∨ a"];
    
    [inputs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NyayaFormula *frm = [NyayaFormula formulaWithString:obj];
        NyayaNode *node = [frm syntaxTree:NO];
        
        NSString *key = [node nnfKey];
        XCTAssertEqualObjects(key ? key : @"---", keys[idx], @"%@", obj);
        XCTAssertEqualObjects([[node nnfNode] description], trans[idx], @"%@", obj);
    }];    
}

- (void)testCollapseAnd {
    
    NSArray *inputs = @[@"a&a"  ,@"a&!a"    ,@"!a&a"    ,@"a&0"     ,@"0&a"     ,@"a&1"     ,@"1&a"     ,  @"T&T"     ,@"T&F"   ,   @"F&T"  ,   @"F&F"];
    NSArray *keys = @[@"P∧P=P"  ,@"P∧¬P=⊥"  ,@"P∧¬P=⊥"  ,@"P∧⊥=⊥"   ,@"⊥∧P=⊥"  ,@"P∧⊤=P"    ,@"⊤∧P=P" ,@"P∧P=P"     ,@"⊤∧P=P"   ,@"⊥∧P=⊥",  @"P∧P=P"];
    NSArray *trans = @[  @"a"   ,@"F"       , @"F"      ,@"F"       ,@"F"       ,@"a"       ,@"a"       ,@"T"       , @"F"          , @"F"  , @"F", @"F"];
    
    [inputs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NyayaFormula *frm = [NyayaFormula formulaWithString:obj];
        NyayaNode *node = [frm syntaxTree:NO];
        
        XCTAssertEqualObjects([node collapseKey], keys[idx], @"%@", obj);
        XCTAssertEqualObjects([[node collapsedNode] description], trans[idx], @"%@", obj);
    }];
}

- (void)testCollapseOr {
    
    NSArray *inputs = @[@"a|a",@"a|!a"  ,@"!a|a"  ,@"a|0"   ,@"0|a"  ,@"a|1"  ,@"1|a",   @"T|T",   @"T|F",   @"F|T",   @"F|F"];
    NSArray *keys = @[@"P∨P=P",@"P∨¬P=⊤",@"P∨¬P=⊤",@"P∨⊥=P",@"⊥∨P=P",@"P∨⊤=⊤",@"⊤∨P=⊤",@"P∨P=P", @"⊤∨P=⊤",@"⊥∨P=P",@"P∨P=P"];
    NSArray *trans = @[  @"a"    ,@"T",       @"T",    @"a",    @"a",    @"T",   @"T",   @"T",     @"T",    @"T",     @"F"];
    
    [inputs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NyayaFormula *frm = [NyayaFormula formulaWithString:obj];
        NyayaNode *node = [frm syntaxTree:NO];
        
        XCTAssertEqualObjects([node collapseKey], keys[idx], @"%@", obj);
        XCTAssertEqualObjects([[node collapsedNode] description], trans[idx], @"%@", obj);
    }];
}

- (void)testNoCollapse {
    
    NSArray *inputs = @[@"a|b"  ,@"a&b"     ,@"a>b"];
    NSArray *trans = @[@"a ∨ b" ,@"a ∧ b"   ,@"a → b"];
    
    [inputs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NyayaFormula *frm = [NyayaFormula formulaWithString:obj];
        NyayaNode *node = [frm syntaxTree:NO];
        
        XCTAssertNil([node collapseKey], @"%@", obj);
        XCTAssertEqualObjects([[node collapsedNode] description], trans[idx], @"%@", obj);
    }];
}


@end
