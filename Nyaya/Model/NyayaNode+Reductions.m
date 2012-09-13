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
#import "NyayaNode+Description.h"



@implementation NSArray (Reductions)
- (BOOL)containsComplementaryNodes {
    NSMutableArray *negatedArray = [self negatedNodes:NO]; // the nodes in self are unique
    NSUInteger count = [negatedArray count];
    [negatedArray removeObjectsInArray:self];
    
    return [negatedArray count] < count;
}

- (NSMutableArray*)negatedNodes:(BOOL)unique {
    NSMutableArray *negatedArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NyayaNode *sub in self) {
        NyayaNode *rdc = sub.type == NyayaNegation ? [sub nodeAtIndex:0] : [NyayaNode negation:sub];
        
        if (!unique || ![negatedArray containsObject:rdc])
            [negatedArray addObject: rdc];
    }
    return negatedArray;
}

- (NSMutableArray*)reducedNodes:(BOOL)unique {
    NSMutableArray *reducedArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NyayaNode *sub in self) {
        NyayaNode *rdc = [sub reduce:NSIntegerMax];
        if (!unique || ![reducedArray containsObject:rdc])
            [reducedArray addObject: rdc];
    }
    return reducedArray;
}

- (BOOL)containsTop {
    return [self containsObject:[NyayaNode top]];
}

- (BOOL)containsBottom {
    return [self containsObject:[NyayaNode bottom]];
}
@end



@implementation NSMutableArray (Reductions)

- (void)xorConsolidate {
    [self consolidate:YES];
}

- (void)bicConsolidate {
    [self consolidate:NO];
}

- (void)consolidate:(BOOL)isXor {
    NSCountedSet *countedSet = [NSCountedSet setWithArray:self];
    for (NyayaNode *node in countedSet) {
        NSUInteger count = [countedSet countForObject:node];
        NSUInteger idx = [self indexOfObject:node]; // lowest index of obj isEqual:node)
        if (count > 1) {
            //  
            // !isXor: T=T == T, F=F == T subNode = subNode == T, node = T == node
            [self removeObject:node]; // removes all occurrences of obj isEqual:node
            
            if (count % 2 == 1) {
                [self insertObject:node atIndex:idx];
            }
        }
    }
    
    countedSet = [NSCountedSet setWithArray:self];
    NSMutableArray *negatedNodes = [self negatedNodes:NO];
    
    NSUInteger substitutions = 0;
    for (NyayaNode *node in countedSet) {
        NSAssert([countedSet countForObject:node] == 1, @"there must be no doubles");
        
        if ([negatedNodes containsObject:node]) {
            // [!P,!Q, P] contains node in { P:1, Q:1,!P:1 }
            [self removeObject:node]; // will be called for !P and P
            substitutions++;
        }
    }
    
    substitutions = (substitutions / 2) % 2;
    // [!P,!Q, P]        => [Q] substitutions = 1;
    // [!P,!Q, P, A, !A] => [Q] substitutions = 0;
    
    if (isXor) {
        // P^F = F^P == P
        [self removeObject:[NyayaNode bottom]]; // bottom is neutral for XOR
        
        if (substitutions == 1) {
            // (1) P^!P == T, (0) P^P^!P^!P = F
            [self addObject:[NyayaNode top]];  
        }
    }
    else {
        // P=T = T=P == P
        [self removeObject:[NyayaNode top]]; // top is neutral for BIC
        
        if (substitutions == 1) {
            // (1) P=!P == F, (0) P=P=!P=!P == T
            [self addObject:[NyayaNode bottom]];
        }
    }
}
@end


@implementation NyayaNode (Reductions)

- (NSMutableSet*)naryDisjunction {
    return nil;
}

- (NSMutableSet*)naryConjunction {
    return nil;
}

- (NSMutableArray*)naryXdisjunction {
    return nil;
}

- (NSMutableArray*)naryBiconditional {
    return nil;
}


- (NyayaNode*)reduce:(NSInteger)maxSize { // stop reduction
    if (maxSize < 0 || [self.nodes count] == 0) // nothing to reduce
        return self;

    NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[self.nodes count]];
    for (NyayaNode *node in self.nodes) {
        NyayaNode *rn = [node reduce:maxSize-1];
        [nodes addObject: rn];
        maxSize -= [rn length];
    }
    return [self copyWith:nodes];
    
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
    if (maxSize < 0) return self; // stop reduction

    NyayaNode *reducedFirstNode = [self.firstNode reduce:maxSize-1];
    
    if ([reducedFirstNode isEqual:[NyayaNode bottom]]) return [NyayaNode top];
    
    if ([reducedFirstNode isEqual:[NyayaNode top]]) return [NyayaNode bottom];
    
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

// it would be easier with a set, but an array keeps the order
- (NSMutableArray*)naryDisjunction {
    
    NSMutableArray *array = [NSMutableArray array];
    for (NyayaNode *node in self.nodes) {
        NSArray *subArray = [node naryDisjunction];
        if (!subArray) subArray = @[node];
        
        for (NyayaNode* subNode in subArray) {
            if (![array containsObject:subNode]) // inefficient form many nodes
                [array addObject:subNode];
        }
    }
    [array removeObject:[NyayaNode bottom]];
    return array;
}

- (NyayaNode*)reduce:(NSInteger)maxSize {
    if (maxSize < 0) return self; // stop reduction
    
    // first collect disjuncted subnodes, then reduce the nodes in the set
    NSMutableArray *array = [[self naryDisjunction] reducedNodes:YES];
    [array removeObject:[NyayaNode bottom]];
    
    if ([array count] == 0) return [NyayaNode bottom];
    
    if ([array containsTop] || [array containsComplementaryNodes]) return [NyayaNode top];
    
    NyayaNode *node = nil;
    for (NyayaNode *n in array) {
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
- (NSMutableArray*)naryConjunction {
    
    NSMutableArray *array = [NSMutableArray array];
    for (NyayaNode *node in self.nodes) {
        NSArray *subArray = [node naryConjunction];
        if (!subArray) subArray = @[node];
        
        for (NyayaNode* subNode in subArray) {
            if (![array containsObject:subNode]) // inefficient form many nodes
                [array addObject:subNode];
        }
    }
    [array removeObject:[NyayaNode top]];
    return array;
}

- (NyayaNode*)reduce:(NSInteger)maxSize; {
    if (maxSize < 0) return self; // stop reduction
    
    // first collect conjuncted subnodes, then reduce the nodes in the set
    NSMutableArray *array = [[self naryConjunction] reducedNodes:YES];
    [array removeObject:[NyayaNode top]];
    
    if ([array count] == 0) return [NyayaNode top]; // P & T == P
    
    if ([array containsBottom] || [array containsComplementaryNodes]) return [NyayaNode bottom];
    
    NyayaNode *node = nil;
    for (NyayaNode *n in array) {
        if (!node) node = n;
        else node = [NyayaNode conjunction:node with:n];
    }
    return node;
}
@end

@implementation NyayaNodeExpandable (Reductions)
@end

@implementation NyayaNodeXdisjunction (Reductions)



- (NSMutableArray*)naryXdisjunction {
    NSMutableArray *array = [NSMutableArray array];
    
    for (NyayaNode *node in self.nodes) {
        NSArray *subArray = [node naryXdisjunction];
        if (!subArray) subArray = @[node];
        
        [array addObjectsFromArray:subArray];
    }
    
    [array removeObject:[NyayaNode bottom]];
    return array;
}

- (NyayaNode*)reduce:(NSInteger)maxSize; {
    if (maxSize < 0) return self; // stop reduction
    
    NSMutableArray *array = [[self naryXdisjunction] reducedNodes:NO];
    [array xorConsolidate];
    
    if ([array count] == 0) return [NyayaNode bottom];
    
    BOOL negation = NO;
    if ([array containsObject:[NyayaNode top]]) {
        [array removeObject:[NyayaNode top]];
        negation = YES;
    }
    
    NyayaNode *node = nil;
    for (NyayaNode *n in array) {
        if (!node) node = n;
        else node = [NyayaNode xdisjunction:node with:n];
    }
    
    return negation ? [NyayaNode negation:node] : node;
}
@end

@implementation NyayaNodeImplication (Reductions)

- (NyayaNode*)reduce:(NSInteger)maxSize; {
    if (maxSize < 0) return self; // stop reduction
    
    NyayaNode *reducedFirstNode = [[self firstNode] reduce:maxSize-1];
    if (!reducedFirstNode) reducedFirstNode = [self firstNode]; // use unreduced first node
    if ([reducedFirstNode isEqual:[NyayaNode bottom]]) return [NyayaNode top];
    
    NyayaNode *reducedSecondNode = [[self secondNode] reduce:maxSize-1-[reducedFirstNode length]];
    if (!reducedSecondNode) reducedSecondNode = [self secondNode]; // use unreduced second node
    
    if ([reducedFirstNode isEqual:[NyayaNode top]] || [reducedSecondNode isEqual:[NyayaNode top]]) return reducedSecondNode;
    
    if ([reducedSecondNode isEqual:[NyayaNode bottom]] && reducedFirstNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedFirstNode firstNode];
    
    if ([reducedSecondNode isEqual:[NyayaNode bottom]]) return [NyayaNode negation:reducedFirstNode];
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return [NyayaNode top];
    
    if ([reducedFirstNode isEqual:[self firstNode]] && [reducedSecondNode isEqual:[self secondNode]]) return self; // nothing has changed
    
    return [NyayaNode implication:reducedFirstNode with:reducedSecondNode];
}

@end

@implementation NyayaNodeEntailment (Reductions)
@end

@implementation NyayaNodeBicondition (Reductions)

- (NSMutableArray*)naryBiconditional {
    NSMutableArray *array = [NSMutableArray array];
    for (NyayaNode *node in self.nodes) {
        NSArray *subArray = [node naryBiconditional];
        if (!subArray) subArray = @[node];
        
        for (NyayaNode* subNode in subArray) {
            if (![array containsObject:subNode]) {
                [array insertObject:subNode atIndex:0];
            }
            else {
                // subNode <> subNode == T, node <> T == node
                [array removeObject:subNode];
            }
        }
    }
    [array removeObject:[NyayaNode top]];
    return array;
}
- (NyayaNode*)reduce:(NSInteger)maxSize; {
    if (maxSize < 0) return self; // stop reduction
    
    NSMutableArray *array = [[self naryBiconditional] reducedNodes:NO];
    [array bicConsolidate];
    if ([array count] == 0) return [NyayaNode top];
    
    BOOL negation = NO;
    if ([array containsObject:[NyayaNode bottom]]) {
        [array removeObject:[NyayaNode bottom]];
        negation = YES;
    }
    
    NyayaNode *node = nil;
    for (NyayaNode *n in array) {
        if (!node) node = n;
        else node = [NyayaNode bicondition:node with:n];
    }
    
    return negation ? [NyayaNode negation:node] : node;
}
@end

@implementation NyayaNodeFunction (Reductions)
@end