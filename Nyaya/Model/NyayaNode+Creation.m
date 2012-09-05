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
+ (NyayaNode*)atom:(NSString*)name {
    NyayaNode *node = nil;
    if ([name isTrueToken]) {
        node = [[NyayaNodeConstant alloc] init];
        node->_symbol = @"T";
    }
    else if ([name isFalseToken]) {
        node = [[NyayaNodeConstant alloc] init];
        node->_symbol = @"F";
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
    node->_nodes = [NSArray arrayWithObjects:firstNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)conjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeConjunction alloc] init];
    node->_symbol = @"∧";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)sequence:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeSequence alloc] init];
    node->_symbol = @";";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)disjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeDisjunction alloc] init];
    node->_symbol = @"∨";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)implication:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeImplication alloc] init];
    node->_symbol = @"→";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)entailment:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeEntailment alloc] init];
    node->_symbol = @"⊨";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)bicondition:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeBicondition alloc] init];
    node->_symbol = @"↔";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)xdisjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeXdisjunction alloc] init];
    node->_symbol = @"⊻"; // @"⊕";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
    
}

+ (NyayaNode*)function:(NSString *)name with:(NSArray *)nodes {
    NyayaNode*node=[[NyayaNodeFunction alloc] init];
    // node->isa = [NyayaNodeFunction class];
    node->_symbol = name;
    node->_nodes = [nodes copy];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

@end
