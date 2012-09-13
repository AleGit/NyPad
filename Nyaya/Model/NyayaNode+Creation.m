//
//  NyayaNode+Creation.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Creation.h"
#import "NyayaNode_Cluster.h"
#import "NSSet+NyayaToken.h"
#import "NSString+NyayaToken.h"
#import "NyayaStore.h"


@implementation NyayaNode (Creation)

#pragma mark node factory

// top is a singleton
+ (NyayaNode *)top {
    static dispatch_once_t pred = 0;
    __strong static NyayaNode* _top = nil;
    dispatch_once(&pred, ^{
        _top = [self atom:@"1"];
    });
    return _top;
}

// bottom is a singleton
+ (NyayaNode *)bottom {
    static dispatch_once_t pred = 0;
    __strong static NyayaNode* _bottom = nil;
    dispatch_once(&pred, ^{
        _bottom = [self atom:@"0"];
    });
    return _bottom;
}

+ (NyayaNode*)atom:(NSString*)name {
    NyayaNode *node = nil;
    if ([name isTrueToken]) {
        node = [[NyayaNodeConstant alloc] init];
        node->_symbol = @"T";
        node->_evaluationValue = YES;
        node->_displayValue = NyayaTrue;
    }
    else if ([name isFalseToken]) {
        node = [[NyayaNodeConstant alloc] init];
        node->_symbol = @"F";
        node->_evaluationValue = NO;
        node->_displayValue = NyayaFalse;
    }
    else { // variable name
        node = [[NyayaNodeVariable alloc] init];
        [[NyayaStore sharedInstance] setDisplayValue:NyayaUndefined forName:name];
        node->_symbol = name;
    };
    
    
    return node;
}

+ (NyayaNode*)negation:(NyayaNode *)firstNode {
    NyayaNode*node=[[NyayaNodeNegation alloc] init];
    node->_symbol = @"¬";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode, nil];
    return node;
}

+ (NyayaNode*)conjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeConjunction alloc] init];
    node->_symbol = @"∧";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)sequence:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeSequence alloc] init];
    node->_symbol = @";";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)disjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeDisjunction alloc] init];
    node->_symbol = @"∨";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)implication:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeImplication alloc] init];
    node->_symbol = @"→";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)entailment:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeEntailment alloc] init];
    node->_symbol = @"⊨";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)bicondition:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeBicondition alloc] init];
    node->_symbol = @"↔";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)xdisjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeXdisjunction alloc] init];
    node->_symbol = @"⊻"; // @"⊕";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSMutableArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
    
}

+ (NyayaNode*)function:(NSString *)name with:(NSArray *)nodes {
    NyayaNode*node=[[NyayaNodeFunction alloc] init];
    // node->isa = [NyayaNodeFunction class];
    node->_symbol = name;
    node->_nodes = [nodes mutableCopy];
    return node;
}

@end
