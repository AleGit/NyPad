//
//  NyayaNode+Transformations.m
//  Nyaya
//
//  Created by Alexander Maringele on 19.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Transformations.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Type.h"
#import "NyayaNode+Attributes.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Valuation.h"

@interface NSIndexPath (Nyaya)
- (NSIndexPath*)indexPathByRemovingFirstIndex;
@end

@implementation NSIndexPath (Nyaya)
- (NSIndexPath*)indexPathByRemovingFirstIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:nil length:0];
    for (NSUInteger idx = 1; idx < [self length]; idx++) {
        indexPath  = [indexPath indexPathByAddingIndex:[self indexAtPosition:idx]];
    }
    return indexPath;
}
@end

@implementation NyayaNode (Transformations)

/*     []      !a & (b+c)
        &
      /   \
  [0]     [1]
    !       +
    |      / \
 [0.0] [1.0]  [1.1]
    a    b      c
*/

- (NyayaNode*)nodeAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath length] == 0) {
        return self;
    }
    else {
        NSUInteger idx = [indexPath indexAtPosition:0];
        NSIndexPath *subpath = [indexPath indexPathByRemovingFirstIndex];
        return [[self nodeAtIndex:idx] nodeAtIndexPath:subpath];
    }
}
- (NyayaNode*)nodeByReplacingNodeAtIndexPath:(NSIndexPath*)indexPath withNode:(NyayaNode*)node {
    if ([indexPath length] == 0) {
        return node;
    }
    else {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.nodes count]];
        
        [self.nodes enumerateObjectsUsingBlock:^(NyayaNode *obj, NSUInteger idx, BOOL *stop) {
            NyayaNode *subnode = nil;
            if ([indexPath indexAtPosition:0] == idx) {
                subnode = [obj nodeByReplacingNodeAtIndexPath:[indexPath indexPathByRemovingFirstIndex]
                                                     withNode:node];
            }
            else {
                subnode = obj;
            }
            [array addObject:subnode];
            
        }];
        return [self copyWith:array];
    }
}

#pragma mark - keys for equivalence transformations

- (NSString*)collapseKey {
    NSString *key = nil; // default return value
    NyayaNode *n0 = [self nodeAtIndex:0];   // level 1
    NyayaNode *n1 = [self nodeAtIndex:1];   // level 1
    
    switch (self.type) {
        case NyayaNegation:
            if (n0.type == NyayaNegation) key = @"¬¬P=P";
            break;
        case NyayaConjunction:
            if ([n0 isEqual:n1]) key = @"P∧P=P";
            else if ([n0 isNegationToNode:n1]) key = @"P∧¬P=⊥";
            else if ([n0 isEqual:[NyayaNode top]]) key = @"⊤∧P=P";
            else if ([n0 isEqual:[NyayaNode bottom]]) key = @"⊥∧P=⊥";
            else if ([n1 isEqual:[NyayaNode top]]) key = @"P∧⊤=P";
            else if ([n1 isEqual:[NyayaNode bottom]]) key = @"P∧⊥=⊥";
            break;
        case NyayaDisjunction:
            if ([n0 isEqual:n1]) key = @"P∨P=P";
            else if ([n0 isNegationToNode:n1]) key = @"P∨¬P=⊤";
            else if ([n0 isEqual:[NyayaNode top]]) key = @"⊤∨P=⊤";
            else if ([n0 isEqual:[NyayaNode bottom]]) key = @"⊥∨P=P";
            else if ([n1 isEqual:[NyayaNode top]]) key = @"P∨⊤=⊤";
            else if ([n1 isEqual:[NyayaNode bottom]]) key = @"P∨⊥=P";
            break;
    }
    return key;
}

- (NyayaNode*)collapsedNode {
    NyayaNode *node = self;                 // level 0, default return value
    NyayaNode *n0 = [self nodeAtIndex:0];   // level 1
    NyayaNode *n1 = [self nodeAtIndex:1];   // level 1
    
    switch (self.type) {
        case NyayaNegation:
            if (n0.type == NyayaNegation) node = [n0 nodeAtIndex:0];
            break;
        case NyayaConjunction:
            if ([n0 isEqual:n1]) node = n0;
            else if ([n0 isNegationToNode:n1]) node = [NyayaNode bottom];
            else if ([n0 isEqual:[NyayaNode top]]) node = n1;
            else if ([n0 isEqual:[NyayaNode bottom]]) node = [NyayaNode bottom];
            else if ([n1 isEqual:[NyayaNode top]]) node = n0;
            else if ([n1 isEqual:[NyayaNode bottom]]) node = [NyayaNode bottom];
            break;
        case NyayaDisjunction:
            if ([n0 isEqual:n1]) node = n0;
            else if ([n0 isNegationToNode:n1]) node = [NyayaNode top];
            else if ([n0 isEqual:[NyayaNode top]]) node = [NyayaNode top];
            else if ([n0 isEqual:[NyayaNode bottom]]) node = n1;
            else if ([n1 isEqual:[NyayaNode top]]) node = [NyayaNode top];
            else if ([n1 isEqual:[NyayaNode bottom]]) node = n0;
            break;
    }
    return node;
}

- (NSString*)switchKey {
    NSString *key = nil; // default return value
    NyayaNode *n0 = [self nodeAtIndex:0];   // level 1
    NyayaNode *n1 = [self nodeAtIndex:1];   // level 1
    if (![n0 isEqual:n1]) {
        switch (self.type) {
            case NyayaConjunction: key=@"P∧Q=Q∧P"; break;
            case NyayaDisjunction: key=@"P∨Q=Q∨P"; break;
        }
    }
    return key;
}

- (NyayaNode*)switchedNode {
    NyayaNode *node = self;                 // level 0, default return value
    NyayaNode *n0 = [self nodeAtIndex:0];   // level 1
    NyayaNode *n1 = [self nodeAtIndex:1];   // level 1
    
    switch (self.type) {
        case NyayaConjunction: node=[NyayaNode conjunction:n1 with:n0]; break;
        case NyayaDisjunction: node=[NyayaNode disjunction:n1 with:n0];; break;
        case NyayaBicondition: node=[NyayaNode bicondition:n1 with:n0]; break;
        case NyayaXdisjunction: node=[NyayaNode bicondition:n1 with:n0]; break;
    }
    return node;
}

- (NSString*)imfKey {
    NSString *key = nil; // default return value
    switch (self.type) {
        case NyayaImplication: key = @"P→Q=¬P∨Q"; break;
        case NyayaBicondition: key = @"P↔Q=(P→Q)∧(Q→P)"; break;
        case NyayaXdisjunction: key = @"P⊻Q=¬(P↔Q)"; break;
    }
    return key;
}

- (NyayaNode*)imfNode {
    NyayaNode *node = self;                 // level 0, default return value
    NyayaNode *n0 = [self nodeAtIndex:0];   // level 1
    NyayaNode *n1 = [self nodeAtIndex:1];   // level 1
    
    if (self.type == NyayaImplication) {
        node = [NyayaNode disjunction:[NyayaNode negation:n0] with:n1];  
    }
    return node;
}

- (NSString *)nnfKey {
    NSString *key = nil; // default return value
    NyayaNode *n0 = [self nodeAtIndex:0];   // level 1
    
    if (self.type == NyayaNegation) {
        switch(n0.type) {
            case NyayaNegation: key = @"¬¬P=P"; break;
            case NyayaConjunction: key = @"¬(P∧Q)=¬P∨¬Q"; break;
            case NyayaDisjunction: key = @"¬(P∨Q)=¬P∧¬Q"; break;
            case NyayaConstant: key = n0.evaluationValue ? @"¬⊤=⊥" : @"¬⊥=⊤"; break;
        }
    }
    return key;
}

- (NyayaNode*)nnfNode {
    NyayaNode *node = self;                 // level 0, default return value
    NyayaNode *n0 = [self nodeAtIndex:0];   // level 1
    NyayaNode *n00 = [n0 nodeAtIndex:0];   // level 2
    NyayaNode *n01 = [n0 nodeAtIndex:1];   // level 2
    
    
    if (self.type == NyayaNegation) {
        switch(n0.type) {
            case NyayaNegation: node = [n0 nodeAtIndex:0]; break;
            case NyayaConjunction: node = [NyayaNode disjunction:[NyayaNode negation:n00] with:[NyayaNode negation:n01]]; break;
            case NyayaDisjunction: node = [NyayaNode conjunction:[NyayaNode negation:n00] with:[NyayaNode negation:n01]]; break;
            case NyayaConstant: node = n0.evaluationValue ? [NyayaNode bottom] : [NyayaNode top];
        }
    }
    return node;
}

- (NSString *)cnfKey:(NSUInteger)idx {
    NSString *key = nil; // default return value
    NyayaNode *nidx = [self nodeAtIndex:idx];   // level 1
    
    if (self.type == NyayaDisjunction) {
        switch (nidx.type) {
            case NyayaConjunction: key = idx==0 ? @"(P∧Q)∨R=(P∨R)∧(Q∨R)" : @"P∨(Q∧R)=(P∨Q)∧(P∨R)"; break;
        }
    }
    return key;
}

- (NSString *)cnfLeftKey {
    return [self cnfKey:0];
}

- (NSString *)cnfRightKey {
    return [self cnfKey:1];
}

- (NSString *)dnfKey:(NSUInteger)idx {
    NSString *key = nil; // default return value
    NyayaNode *nidx = [self nodeAtIndex:idx];   // level 1
    
    if (self.type == NyayaConjunction) {
        switch (nidx.type) {
            case NyayaDisjunction: key = idx==0 ? @"(P∨Q)∧R=(P∧R)∨(Q∧R)" : @"P∧(Q∨R)=(P∧Q)∨(P∧R)"; break;
        }
    }
    return key;
}

- (NSString*)dnfLeftKey {
    return [self dnfKey:0];
}

- (NSString*)dnfRightKey {
     return [self dnfKey:1];
}

- (NyayaNode*)distributedNodeToIndex:(NSUInteger)idx {
    NyayaNode *node = self;                // level 0, default return value
    NyayaNode *n0 = [self nodeAtIndex:0];  // level 1
    NyayaNode *n00 = [n0 nodeAtIndex:0];   // level 2
    NyayaNode *n01 = [n0 nodeAtIndex:1];   // level 2
    NyayaNode *n1 = [self nodeAtIndex:1];  // level 1
    NyayaNode *n10 = [n1 nodeAtIndex:0];   // level 2
    NyayaNode *n11 = [n1 nodeAtIndex:1];   // level 2
    
    if (idx == 0 && node.type == NyayaConjunction && n0.type == NyayaDisjunction) {
        // (P∨Q)∧R=(P∧R)∨(Q∧R)
        node = [NyayaNode disjunction:[NyayaNode conjunction:n00 with:n1] with:[NyayaNode conjunction:n01 with:n1]];
    }
    else if (idx == 0 && node.type == NyayaDisjunction && n0.type == NyayaConjunction) {
        // (P∧Q)∨R=(P∨R)∧(Q∨R)
        node = [NyayaNode conjunction:[NyayaNode disjunction:n00 with:n1] with:[NyayaNode disjunction:n01 with:n1]];
    }
    else if (idx == 1 && node.type == NyayaConjunction && n1.type == NyayaDisjunction) {
        // @"P∧(Q∨R)=(P∧Q)∨(P∧R)
        node = [NyayaNode disjunction:[NyayaNode conjunction:n0 with:n10] with:[NyayaNode conjunction:n0 with:n11]];
    }
    else if (idx == 1 && node.type == NyayaDisjunction && n1.type == NyayaConjunction) {
        // @"P∨(Q∧R)=(P∨Q)∧(P∨R)
        node = [NyayaNode conjunction:[NyayaNode disjunction:n0 with:n10] with:[NyayaNode disjunction:n0 with:n11]];
    }
    
    return node;

    
}
@end
