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

@implementation NyayaNode (Reductions)

- (NyayaNode*)reduce {
    if ([self.nodes count] > 0) {
        NSArray *nodes = [self.nodes valueForKeyPath:@"nodes.reduce"];
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
- (NyayaNode*)reduce {
    NyayaNode *reducedFirstNode = [self.firstNode reduce];
    
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
- (NyayaNode*)reduce {
    NyayaNode *reducedFirstNode = [[self firstNode] reduce];
    if ([reducedFirstNode.symbol isTrueToken]) return reducedFirstNode;
    
    NyayaNode *reducedSecondNode = [[self secondNode] reduce];
    if ([reducedFirstNode.symbol isFalseToken] || [reducedSecondNode.symbol isTrueToken]) return reducedSecondNode;
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return reducedFirstNode;
    
    if ([reducedFirstNode isNegationToNode:reducedSecondNode]) return [NyayaNode top];
    
    return [NyayaNode disjunction:reducedFirstNode with:reducedSecondNode];
}
@end

@implementation NyayaNodeSequence (Reductions)
// Conjunction
@end

@implementation NyayaNodeConjunction (Reductions)
- (NyayaNode*)reduce {
    NyayaNode *reducedFirstNode = [[self firstNode] reduce];
    if ([reducedFirstNode.symbol isFalseToken]) return reducedFirstNode;
    
    NyayaNode *reducedSecondNode = [[self secondNode] reduce];
    if ([reducedFirstNode.symbol isFalseToken] || [reducedSecondNode.symbol isFalseToken]) return reducedSecondNode;
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return reducedFirstNode;
    
    if ([reducedFirstNode isNegationToNode:reducedSecondNode]) return [NyayaNode bottom];
    
    return [NyayaNode conjunction:reducedFirstNode with:reducedSecondNode];
}
@end

@implementation NyayaNodeExpandable (Reductions)
@end

@implementation NyayaNodeXdisjunction (Reductions)
- (NyayaNode*)reduce {
    NyayaNode *reducedFirstNode = [[self firstNode] reduce];
    NyayaNode *reducedSecondNode = [[self secondNode] reduce];
    
    if ([reducedFirstNode.symbol isFalseToken]) return reducedSecondNode;
    if ([reducedSecondNode.symbol isFalseToken]) return reducedFirstNode;
    
    if ([reducedFirstNode.symbol isTrueToken] && reducedSecondNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedSecondNode firstNode];
    if ([reducedFirstNode.symbol isTrueToken]) return [NyayaNode negation:reducedSecondNode];
    
    if ([reducedSecondNode.symbol isTrueToken] && reducedFirstNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedFirstNode firstNode];
    if ([reducedSecondNode.symbol isTrueToken]) return [NyayaNode negation:reducedFirstNode];
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return [NyayaNode bottom];
    
    if ([reducedFirstNode isNegationToNode:reducedSecondNode]) return [NyayaNode top];
    
    return [NyayaNode xdisjunction:reducedFirstNode with:reducedSecondNode];
}
@end

@implementation NyayaNodeImplication (Reductions)
- (NyayaNode*)reduce {
    NyayaNode *reducedFirstNode = [[self firstNode] reduce];
    if ([reducedFirstNode.symbol isFalseToken]) return [NyayaNode top];
    
    NyayaNode *reducedSecondNode = [[self secondNode] reduce];
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
- (NyayaNode*)reduce {
    NyayaNode *reducedFirstNode = [[self firstNode] reduce];
    NyayaNode *reducedSecondNode = [[self secondNode] reduce];
    
    if ([reducedFirstNode.symbol isTrueToken]) return reducedSecondNode;
    if ([reducedSecondNode.symbol isTrueToken]) return reducedFirstNode;
    
    if ([reducedFirstNode.symbol isFalseToken] && reducedSecondNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedSecondNode firstNode];
    if ([reducedFirstNode.symbol isFalseToken]) return [NyayaNode negation:reducedSecondNode];
    
    if ([reducedSecondNode.symbol isFalseToken] && reducedFirstNode.type == NyayaNegation) return [(NyayaNodeNegation*)reducedFirstNode firstNode];
    if ([reducedSecondNode.symbol isFalseToken]) return [NyayaNode negation:reducedFirstNode];
    
    if ([reducedFirstNode isEqual:reducedSecondNode]) return [NyayaNode top];
    
    if ([reducedFirstNode isNegationToNode:reducedSecondNode]) return [NyayaNode bottom];
    
    return [NyayaNode bicondition:reducedFirstNode with:reducedSecondNode];
}
@end

@implementation NyayaNodeFunction (Reductions)
@end