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
#import "NyayaNode+Reductions.h"
#import "NyayaNode+Description.h"
#import "NyayaNode+Attributes.h"
#import "NyayaNode+Type.h"

@implementation NyayaNode

+ (id)nodeWithFormula:(NSString*)input {
    
    if ([input length] > NYAYA_MAX_INPUT_LENGTH) return nil;
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
    NyayaNode *node = [parser parseFormula];
    if (node) {
        node->_wellFormed = !parser.hasErrors;
        node->_pred = 0;
    }
    return node;
}

- (NyayaNode*)reducedFormula {
    if (!_reducedNode) _reducedNode = [self reduce:100];
    return _reducedNode;
}

- (TruthTable*)truthTable:(BOOL)compact {
    if (_wellFormed && (!_truthTable || _truthTable.compact != compact)) {
        _truthTable = [[TruthTable alloc] initWithNode:self];
        [_truthTable evaluateTable];
    }
    return _truthTable;
}

- (BddNode*)OBDD:(BOOL)reduced {
    if (_wellFormed && (!_bddNode || (_bddNode.reduced != reduced))) {
        _bddNode = [BddNode bddWithTruthTable:[self truthTable:YES] reduce:reduced];
    }
    return _bddNode;
}

- (NSUInteger)count {
    NSUInteger c = 1;
    for (NyayaNode *subnode in self.nodes) {
        c += [subnode count]; // the graph must not contain circles, but can be reduced
    }
    return c;
}

/* ********************************************************************************************************* */

- (void)makeDescriptions {
    dispatch_once(&_pred, ^{
        
        _slfDescription = [self description];
        NyayaNode *redNode = nil;
        NSString *redDescription = nil;
        
        if ([self isNegationNormalForm]) {
            redNode = [self reduce:800];
            redDescription = [redNode description];
            NSLog(@"RED %@ CNF=%u DNF=%u",redDescription, [redNode isConjunctiveNormalForm], [redNode isDisjunctiveNormalForm]);
        }
        
        _cnfDescription = [redNode isConjunctiveNormalForm] ? redDescription : [self OBDD:YES].cnfDescription;
        _dnfDescription = [redNode isDisjunctiveNormalForm] ? redDescription : [self OBDD:YES].dnfDescription;
        
        if ([_cnfDescription length] < [_dnfDescription length]) {
            _nnfDescription = _cnfDescription;
            _imfDescription = _imfDescription;
        }
        else {
            _nnfDescription = _dnfDescription;
            _imfDescription = _dnfDescription;
        }
        
        if ([self isImplicationFree] && [_slfDescription length] < [_imfDescription length])
            _imfDescription = _slfDescription;
        
        if ([self isNegationNormalForm] && [_slfDescription length] < [_nnfDescription length])
            _nnfDescription = _slfDescription;
        
//        if ([self isConjunctiveNormalForm] && [_slfDescription length] < [_cnfDescription length])
//            _cnfDescription = _slfDescription;
//        
//        if ([self isDisjunctiveNormalForm] && [_slfDescription length] < [_dnfDescription length])
//            _dnfDescription = _slfDescription;
    });
}
    

- (NSString*)cnfDescription {
    [self makeDescriptions];
    return _cnfDescription;
}

- (NSString*)dnfDescription {
    [self makeDescriptions];
    return _dnfDescription;
}

- (NSString*)nnfDescription {
    [self makeDescriptions];
    return _nnfDescription;
}

- (NSString*)imfDescription {
    [self makeDescriptions];
    return _imfDescription;
}

- (NSString*)slfDescription {
    [self makeDescriptions];
    return _slfDescription;
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

- (BOOL)nodesAreEqual:(NyayaNode*)other {
    __block BOOL equal = YES; // call this only with nodes of same length
    
    switch (self.type) {
            // (commutative binary functions: the order of subnodes does not matter)
        case NyayaConjunction:
        case NyayaDisjunction:
        case NyayaXdisjunction:
        case NyayaBicondition:
        case NyayaSequence:
            equal = [[NSSet setWithArray: self.nodes] isEqual:[NSSet setWithArray:other.nodes]];
            break;
            
            // (unary functions)
            // (not commutative binary functions: the order of subnodes matters)
            // case NyayaImplication:
            // case NyayaEntailment:
            // (functions with arity > 2: the order of subnodes matters usually)
        default:
            // equal = [self.nodes isEqual:other.nodes]; // this did not work
            
            [self.nodes enumerateObjectsUsingBlock:^(NyayaNode *node, NSUInteger idx, BOOL *stop) {
                if (![node isEqualToNode:[other nodeAtIndex:idx]]) {
                    equal = NO;
                    *stop = YES;
                }
            }];
            break;
    }
    
    return equal;
}

- (BOOL)isNegationToNode:(NyayaNode*)other {
    BOOL negates = NO;
    if (self.type == NyayaNegation) {
        negates = [[(NyayaNodeNegation*)self firstNode] isEqualToNode:other];
    }
    if (!negates && other.type == NyayaNegation) {
        negates = [self isEqual:[(NyayaNodeNegation*)other firstNode]];
    }
    
    return negates;
    
}

- (BOOL)isEqualToNode:(NyayaNode*)other {
    
    return
    [self.symbol isEqualToString:other.symbol]
    && [self.nodes count] == [other.nodes count]
    && [self nodesAreEqual:other];
    
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    
    if (![object isKindOfClass:[NyayaNode class]]) return NO;
    
    return [self isEqualToNode:object];
}

- (NSUInteger)hash {
    NSUInteger hash = [self.symbol hash]; // F,T,x,y,z,¬∧∨↔→⊻
    for (NyayaNode *node in self.nodes) {
        hash += [node hash]; // a > b has same hash as b > a
    }
    return hash;
}

- (NSComparisonResult)compare:(NyayaNode*)other {
    NSUInteger selfCount = [self count];
    NSUInteger otherCount = [other count];
    
    if (selfCount < otherCount) return NSOrderedAscending;
    else if (selfCount > otherCount) return NSOrderedDescending;
    else return NSOrderedSame;
}

@end

/* ********************************************************************************************************* */
#pragma mark - clustered subclasses -
/* ********************************************************************************************************* */

@implementation NyayaNodeVariable

//- (BOOL)isEqual:(id)object {
//    if (object == self)
//        return YES;
//    else if (!object || ![object isKindOfClass:[self class]])
//        return NO;
//    return [self.symbol isEqual:((NyayaNodeVariable*)object).symbol];
//}
//
//- (NSUInteger)hash {
//    return [self.symbol hash];
//}
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


