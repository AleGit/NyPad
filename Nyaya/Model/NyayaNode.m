//
//  NyayaNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Description.h"


@implementation NyayaNode

+ (id)nodeWithInput:(NSString*)input {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
    NyayaNode *node = [parser parseFormula];
    if (node) {
        node->_wellFormed = ![parser hasErrors];
        
        node->_truthTablePredicate = 0;
        node->_bddNode = 0;
        
       
    }
    return node;
}

- (TruthTable*)truthTable {
    dispatch_once(&_truthTablePredicate, ^{
        _truthTable = [[TruthTable alloc] initWithFormula:self];
        [_truthTable evaluateTable];
    });
    return _truthTable;
}

- (BddNode*)binaryDecisionDiagram {
    dispatch_once(&_bddNodePredicate, ^{
        _bddNode = [BddNode diagramWithTruthTable:[self truthTable]];
        _cnfDescription = [_bddNode cnfDescription];
        _dnfDescription = [_bddNode dnfDescription];
        _nnfDescription = [_cnfDescription length] <= [_dnfDescription length] ? _cnfDescription : _dnfDescription;
    });
    return _bddNode;
    
}
/* ********************************************************************************************************* */
#pragma mark - internal methods -
/* ********************************************************************************************************* */

- (id)copyWithZone:(NSZone*)zone {
    
    return [self copyWith:[self valueForKeyPath:@"nodes.copy"]]; // recursive copy
}

- (NyayaNode*)nodeAtIndex:(NSUInteger)index {
    return [_nodes count] > index ? [_nodes objectAtIndex:index] : nil;
}

@end

/* ********************************************************************************************************* */
#pragma mark - clustered subclasses -
/* ********************************************************************************************************* */

@implementation NyayaNodeVariable

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    else if (!object || ![object isKindOfClass:[self class]])
        return NO;
    return [self.symbol isEqual:((NyayaNodeVariable*)object).symbol];
}

- (NSUInteger)hash {
    return [self.symbol hash];
}
@end

@implementation NyayaNodeConstant
@end


@implementation NyayaNodeUnary
- (NyayaNode*)firstNode {
    return [self nodeAtIndex:0];
}
@end

@implementation NyayaNodeNegation
@end

@implementation NyayaNodeBinary
- (NyayaNode*)secondNode {
    return [self nodeAtIndex:1];
}
@end

@implementation NyayaNodeJunction
@end

@implementation NyayaNodeConjunction
@end

@implementation NyayaNodeSequence
@end

@implementation NyayaNodeDisjunction
@end

@implementation NyayaNodeExpandable
@end

@implementation NyayaNodeImplication
@end

@implementation NyayaNodeEntailment
@end

@implementation NyayaNodeBicondition
@end

@implementation NyayaNodeXdisjunction
@end

@implementation NyayaNodeFunction
@end


