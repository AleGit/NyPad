//
//  NyayaStoreTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaStoreTests.h"
#import "NyayaStore.h"
#import "NyayaParser.h"
#import "NyayaNode.h"

@implementation NyayaStoreTests

- (void)setUp
{
    [super setUp];
    
    [[NyayaStore sharedInstance] removeAllNodes];
    
}

- (void)tearDown
{
    
    [super tearDown];
}

- (void) testStore {
    NSString *tName = @"T";
    NSString *fName = @"F";
    NSString *uName = @"u";
    
    NyayaStore *store = [NyayaStore sharedInstance];
    NyayaNode *tNode = [store nodeForName:tName];
    NyayaNode *fNode = [store nodeForName:fName];
    NyayaNode *uNode = [store nodeForName:uName];
    STAssertNil(tNode,@"tNode");
    STAssertNil(fNode,@"fNode");
    STAssertNil(uNode,@"uNode");
    
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"F>u|(T>F)"];
    NyayaNode *node = [parser parseFormula];
    tNode = [store nodeForName:tName];
    fNode = [store nodeForName:fName];
    uNode = [store nodeForName:uName];
    STAssertNotNil(tNode,@"tNode");
    STAssertNotNil(fNode,@"fNode"); 
    STAssertNotNil(uNode,@"uNode"); 
    STAssertEquals(tNode.displayValue,(NyayaBool)NyayaTrue,@"tNode");
    STAssertEquals(fNode.displayValue,(NyayaBool)NyayaFalse,@"fNode"); 
    STAssertEquals(uNode.displayValue,(NyayaBool)NyayaUndefined,@"uNode"); 
    STAssertEquals(node.displayValue,(NyayaBool)NyayaTrue,@"node");
    
   
    
    
    parser = [NyayaParser parserWithString:tName];
    node = [parser parseFormula];
    STAssertEquals(node, tNode, nil);
    
    parser = [NyayaParser parserWithString:fName];
    node = [parser parseFormula];
    STAssertEquals(node, fNode, nil);
    
    parser = [NyayaParser parserWithString:uName];
    node = [parser parseFormula];
    STAssertEquals(node, uNode, nil);
    
}



@end
