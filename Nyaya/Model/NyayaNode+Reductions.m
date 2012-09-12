//
//  NyayaNode+Reductions.m
//  Nyaya
//
//  Created by Alexander Maringele on 06.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Reductions.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Type.h"
#import "NyayaNode+Creation.h"
#import "NSString+NyayaToken.h"



@implementation NSSet (Reductions)
- (BOOL)containsComplementaryNodes {
    NSMutableSet *negatedSet = [self negatedSet];
    [negatedSet intersectSet:self];
    return [negatedSet count] > 0;
}

- (NSMutableSet*)negatedSet {
    NSMutableSet *negatedSet = [NSMutableSet setWithCapacity:[self count]];
    for (NyayaNode *node in self) {
        if (node.type == NyayaNegation) {
            [negatedSet addObject:[node nodeAtIndex:0]];
        }
        else {
            [negatedSet addObject:[NyayaNode negation:node]];
        }
    }
    return negatedSet;
}

- (NSMutableSet*)reducedSet {
     NSMutableSet *reducedSet = [NSMutableSet setWithCapacity:[self count]];
    for (NyayaNode *node in self) {
        [reducedSet addObject: [node reduce:NSIntegerMax]];
    }
    return reducedSet;
    
}

- (BOOL)containsTop {
    return [self containsObject:[NyayaNode top]];
}

- (BOOL)containsBottom {
    return [self containsObject:[NyayaNode bottom]];
}
@end


@implementation NyayaNode (Reductions)

- (NSMutableSet*)naryDisjunction {
    return nil;
}

- (NSMutableSet*)naryConjunction {
    return nil;
}

- (NyayaNode*)reduce:(NSInteger)maxSize {
    
    if (maxSize > 0 && [self.nodes count] > 0) {
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[self.nodes count]];
        for (NyayaNode *node in self.nodes) {
            NyayaNode *rn = maxSize < 0 ? [node copy] : [node reduce:maxSize-1];
            
            [nodes addObject: rn];
            maxSize -= [rn count];
        }
        return [self copyWith:nodes];
    }
    
    return [self copy];
}
@end

@implementation NyayaNodeVariable (Reductions)
// copy
@end

@implementation NyayaNodeConstant (Reductions)
// copy
@end

@implementation NyayaNodeUnary (Reductions)
// copy
@end

@implementation NyayaNodeNegation (Reductions)
// remove double negation
- (NyayaNode*)reduce:(NSInteger)maxSize {
    NyayaNode *reducedFirstNode = [self.firstNode reduce:maxSize-1];
    
    if ([reducedFirstNode.symbol isFalseToken]) return [NyayaNode top];
    
    if ([reducedFirstNode.symbol isTrueToken]) return [NyayaNode bottom];
    
    if (reducedFirstNode.type == NyayaNegation)
         return [(NyayaNodeNegation*)reducedFirstNode firstNode]; // firstNode is allready reduced
         
    return [NyayaNode negation:reducedFirstNode];
}
@end

@implementation NyayaNodeBinary  (Reductions)
@end

@implementation NyayaNodeJunction (Reductions)
@end

@implementation NyayaNodeDisjunction (Reductions)

- (NSMutableSet*)naryDisjunction {
    
    NSMutableSet *set = [NSMutableSet set];
    for (NyayaNode *node in self.nodes) {
        NSSet *subSet = [node naryDisjunction];
        if (!subSet) [set addObject:node];
        else [set unionSet:subSet];
    }
    [set removeObject:[NyayaNode bottom]];
    return set;
}

- (NyayaNode*)reduce:(NSInteger)maxSize {
    // first collect disjuncted subnodes, then reduce the nodes in the set
    NSMutableSet *set = [[self naryDisjunction] reducedSet];
    
    if ([set count] == 0) return [NyayaNode bottom];
    
    if ([set containsTop] || [set containsComplementaryNodes]) return [NyayaNode top];
    
    NyayaNode *node = nil;
    for (NyayaNode *n in set) {
        if (!node) node = n;
        else node = [NyayaNode disjunction:node with:n];
    }
    return node;
    
}
@end

@implementation NyayaNodeSequence (Reductions)
// Conjunction
@end

@implementation NyayaNodeConjunction (Reductions)
- (NSMutableSet*)naryConjunction {
    
    NSMutableSet *set = [NSMutableSet set];
    
    for (NyayaNode *node in self.nodes) {
        NSSet *subSet = [node naryConjunction];
        if (!subSet) [set addObject:node];
        else [set unionSet:subSet];
    }
    return set;
}

- (NyayaNode*)reduce:(NSInteger)maxSize; {
    // first collect conjuncted subnodes, then reduce the nodes in the set
    NSMutableSet *set = [[self naryConjunction] reducedSet];
    
    if ([set count] == 0) return [NyayaNode top];
    
    if ([set containsBottom] || [set containsComplementaryNodes]) return [NyayaNode bottom];
    
    NyayaNode *node = nil;
    for (NyayaNode *n in set) {
        if (!node) node = n;
        else node = [NyayaNode conjunction:node with:n];
    }
    return node;
}
@end

@implementation NyayaNodeExpandable (Reductions)
@end

@implementation NyayaNodeXdisjunction (Reductions)

- (NyayaNode*)reduce:(NSInteger)maxSize; {
    NyayaNode *reducedFirstNode = [[self firstNode] reduce:maxSize-1];
    NyayaNode *reducedSecondNode = [[self secondNode] reduce:maxSize-1];
    
    if ([reducedFirstNode.symbol isFalseToken]) return reducedSecondNode;
    if ([reducedSecondNode.symbol isFalseToken]) return reducedFirstNode;
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return [NyayaNode bottom];
    if ([reducedFirstNode isNegationToNode:reducedSecondNode]) return [NyayaNode top];
    
    if ([reducedFirstNode.symbol isTrueToken]) {
        if (reducedSecondNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedSecondNode firstNode];
        return [NyayaNode negation:reducedSecondNode];
    }
    
    if ([reducedSecondNode.symbol isTrueToken]) {
        if (reducedFirstNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedFirstNode firstNode];
        return [NyayaNode negation:reducedFirstNode];
    }
    
    return [NyayaNode xdisjunction:reducedFirstNode with:reducedSecondNode];
}
@end

@implementation NyayaNodeImplication (Reductions)

- (NyayaNode*)reduce:(NSInteger)maxSize; {
    NyayaNode *reducedFirstNode = [[self firstNode] reduce:maxSize-1];
    if ([reducedFirstNode.symbol isFalseToken]) return [NyayaNode top];
    
    NyayaNode *reducedSecondNode = [[self secondNode] reduce:maxSize-1];
    if ([reducedFirstNode.symbol isTrueToken] || [reducedSecondNode.symbol isTrueToken]) return reducedSecondNode;
    
    if ([reducedSecondNode.symbol isFalseToken] && reducedFirstNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedFirstNode firstNode];
    
    if ([reducedSecondNode.symbol isFalseToken]) return [NyayaNode negation:reducedFirstNode];
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return [NyayaNode top];
    
    return [NyayaNode implication:reducedFirstNode with:reducedSecondNode];
}

@end

@implementation NyayaNodeEntailment (Reductions)
@end

@implementation NyayaNodeBicondition (Reductions)
- (NyayaNode*)reduce:(NSInteger)maxSize; {
//    return [[self imf] reduce];
    NyayaNode *reducedFirstNode = [[self firstNode] reduce:maxSize-1];
    NyayaNode *reducedSecondNode = [[self secondNode] reduce:maxSize-1];
    
    if ([reducedFirstNode.symbol isTrueToken]) return reducedSecondNode;
    if ([reducedSecondNode.symbol isTrueToken]) return reducedFirstNode;
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return [NyayaNode top];
    if ([reducedFirstNode isNegationToNode:reducedSecondNode]) return [NyayaNode bottom];
    
    if ([reducedFirstNode.symbol isFalseToken] && reducedSecondNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedSecondNode firstNode];
    if ([reducedFirstNode.symbol isFalseToken]) return [NyayaNode negation:reducedSecondNode];
    
    if ([reducedSecondNode.symbol isFalseToken] && reducedFirstNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedFirstNode firstNode];
    if ([reducedSecondNode.symbol isFalseToken]) return [NyayaNode negation:reducedFirstNode];
    
    return [NyayaNode bicondition:reducedFirstNode with:reducedSecondNode];
}
@end

@implementation NyayaNodeFunction (Reductions)
@end