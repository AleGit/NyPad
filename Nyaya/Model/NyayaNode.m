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



//- (NyayaNode*)reducedFormula {
//    if (!_reducedNode) _reducedNode = [self reduce:100];
//    return _reducedNode;
//}



- (NSUInteger)length {
    NSUInteger c = 1;
    for (NyayaNode *subnode in self.nodes) {
        c += [subnode length]; // the graph must not contain circles, but can be reduced
    }
    return c;
}


- (NSUInteger) width {
    NSUInteger width = 0;
    
    for (NyayaNode *node in self.nodes) width += node.width;
    
    return width ? width : 1;
    
}

- (NSUInteger)height {
    NSUInteger height = 0;
    
    for (NyayaNode *node in self.nodes) height = MAX(height,node.height);
    
    return 1 + height;
}

/* ********************************************************************************************************* */




/* ********************************************************************************************************* */
#pragma mark - internal methods -
/* ********************************************************************************************************* */

- (id)copyWithZone:(NSZone*)zone {
    
    return [self copyWith:[self valueForKeyPath:@"nodes.copy"]]; // recursive copy
}

- (NyayaNode*)nodeAtIndex:(NSUInteger)index {
    return [_nodes count] > index ? [_nodes objectAtIndex:index] : nil;
}

- (BOOL)nodesAreSyntacticallyEqual:(NyayaNode*)other {
    __block BOOL equal = YES; // call this only with nodes of same length
    
    [self.nodes enumerateObjectsUsingBlock:^(NyayaNode *node, NSUInteger idx, BOOL *stop) {
        if (![node isEqualToNode:[other nodeAtIndex:idx]]) {
            equal = NO;
            *stop = YES;
        }
    }];
    return equal;
}

- (BOOL)nodesAreSemanticallyEqual:(NyayaNode*)other {
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

- (BOOL)isSyntacticallyEqualToNode:(NyayaNode *)other {
    
    return
    [self.symbol isEqualToString:other.symbol]
    && [self.nodes count] == [other.nodes count]
    && [self nodesAreSyntacticallyEqual:other];
    
}

- (BOOL)isSemanticallyEqualToNode:(NyayaNode *)other {
    
    return
    [self.symbol isEqualToString:other.symbol]
    && [self.nodes count] == [other.nodes count]
    && [self nodesAreSemanticallyEqual:other];
    
}

- (BOOL)isEqualToNode:(NyayaNode*)other {
    return [self isSyntacticallyEqualToNode:other]; // make this configurable
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    
    if (![object isKindOfClass:[NyayaNode class]]) return NO;
    
    return [self isEqualToNode:object];
}

- (NSUInteger)hash {
    NSUInteger hash = [self.symbol hash]; // F,T,x,y,z,¬∧∨↔→⊻
    for (NyayaNode *node in self.nodes) {
        hash += [node hash];
        // a > b has same hash as b > a
        // so the hash of not equal nodes can be the same
    }
    return hash;
}

- (NSComparisonResult)compare:(NyayaNode*)other {
    NSUInteger selfCount = [self length];
    NSUInteger otherCount = [other length];
    
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
// AND is associative and commutative
- (BOOL)isSemanticallyEqualToNode:(NyayaNode*)other {
    NSSet *selfSet = [NSSet setWithArray:[self naryConjunction]];
    NSSet *otherSet = [NSSet setWithArray:[other naryConjunction]];
    return [selfSet isEqualToSet:otherSet];
}
@end

@implementation NyayaNodeSequence
@end

@implementation NyayaNodeDisjunction
// OR is associative and commutative
- (BOOL)isSemanticallyEqualToNode:(NyayaNode*)other {
    NSSet *selfSet = [NSSet setWithArray:[self naryDisjunction]];
    NSSet *otherSet = [NSSet setWithArray:[other naryDisjunction]];
    return [selfSet isEqualToSet:otherSet];
}
@end

@implementation NyayaNodeExpandable
@end

@implementation NyayaNodeImplication
// IMP is neither associative nor commutative
@end

@implementation NyayaNodeEntailment
@end

@implementation NyayaNodeBicondition
// BIC is associative and commutative
- (BOOL)isSemanticallyEqualToNode:(NyayaNode*)other {
    NSSet *selfSet = [NSSet setWithArray:[self naryBiconditional]];
    NSSet *otherSet = [NSSet setWithArray:[other naryBiconditional]];
    return [selfSet isEqualToSet:otherSet];
}
@end

@implementation NyayaNodeXdisjunction
// XOR is associative and commutative
- (BOOL)isSemanticallyEqualToNode:(NyayaNode*)other {
    NSSet *selfSet = [NSSet setWithArray:[self naryXdisjunction]];
    NSSet *otherSet = [NSSet setWithArray:[other naryXdisjunction]];
    return [selfSet isEqualToSet:otherSet];
}
@end

@implementation NyayaNodeFunction
@end


