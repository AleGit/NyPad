//
//  NyayaNode+Derivations.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Derivations.h"
#import "NyayaNode+Display.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Type.h"

@implementation NyayaNode (Derivations)

- (NyayaNode*)copyWith:(NSArray*)nodes {
    NyayaNode *node = nil;
    
    node = [[[self class] alloc] init];
    
    node->_symbol = self.symbol;
    node->_displayValue = self.displayValue;
    node->_evaluationValue = self.evaluationValue;
    node->_nodes = [nodes mutableCopy];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    
    return node;
}

- (NyayaNode*)std {
    return [self copy];
}

- (NyayaNode*)copyImf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // NSArray *nodes = [self valueForKeyPath:@"nodes.deriveImf"];
    NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[self.nodes count]];
    for (NyayaNode *node in self.nodes) {
        NyayaNode *imf = [node deriveImf:maxSize-1];
        if (!imf) return nil;
        [nodes addObject:imf];
    }
    
    return [self copyWith:nodes];
}

- (NyayaNode*)copyNnf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // NSArray *nodes = [self valueForKeyPath:@"nodes.deriveNnf"];
    NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[self.nodes count]];
    
    for (NyayaNode *node in self.nodes) {
        NyayaNode *nnf = [node deriveNnf:maxSize-1];
        if (!nnf) return nil;
        [nodes addObject:nnf];
    }
    
    return [self copyWith:nodes];
}

- (NyayaNode*)deriveImf:(NSInteger)maxSize {
    if (maxSize < 0)
        return nil;
    // no precondition
    return [self copy];
}

- (NyayaNode*)deriveNnf:(NSInteger)maxSize {
    if (maxSize < 0)
        return nil;
    // precondition 'self' is implication free
    return [self copy];
}

- (NyayaNode*)deriveCnf:(NSInteger)maxSize {
    if (maxSize < 0)
        return nil;
    // precondition 'self' is implication free and in negation normal form
    return [self copy];
}

- (NyayaNode *)deriveDnf:(NSInteger)maxSize {
    if (maxSize < 0)
        return nil;
    // precondition 'self' is implication free and in negation normal form
    return [self copy];
}

/* ********************* */
/* ********************* */

- (NSSet*)subNodeSet {
    NSMutableSet *set = [NSMutableSet setWithObject:self];
    
    NSArray *sets = [self valueForKeyPath:@"nodes.subNodeSet"];
    for (NSSet* nodeset in sets) {
        [set unionSet:nodeset];
    }
    
    return set;
}

//- (NyayaNode*)compressWith:(NSSet*)subNodeSet {
//    NyayaNode *node = nil;
//}
//
//- (NyayaNode*)compress {
//    NyayaNode *std = [self std]; // remove sequence and entailment
//    return [std compressWith:[std subNodeSet]];
//}


@end

@implementation NyayaNodeVariable (Derivations)
@end

@implementation NyayaNodeConstant (Derivations)
@end

@implementation NyayaNodeUnary (Derivations)

- (NyayaNode*)deriveImf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // imf(a)   =  a
    // imf(¬P)  = ¬imf(P)
    // imf(P∨Q) = imf(P) ∨ imf(Q)
    // imf(P∧Q) = imf(P) ∧ imf(Q)
    return [self copyImf:maxSize-1];
}

- (NyayaNode*)deriveNnf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    return [self copyNnf:maxSize-1];
}

@end

@implementation NyayaNodeNegation (Derivations)

- (NyayaNode*)deriveNnf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    NyayaNode *node = [self.nodes objectAtIndex:0];
    
    NSUInteger count = [node.nodes count];
    NyayaNode *first = (count > 0) ? [node.nodes objectAtIndex:0] : nil;
    NyayaNode *second = (count > 1) ? [node.nodes objectAtIndex:1] : nil;
    
    switch (node.type) {
        case NyayaNegation: // nnf(!!P) = nnf(P)
            return [first deriveNnf:maxSize-1];
        case NyayaDisjunction: { // nnf(!(P|Q)) = nnf(!P) & nnf(!Q)
            NyayaNode *ld = [[NyayaNode negation:first] deriveNnf:maxSize-1];
            NyayaNode *rd = [[NyayaNode negation:second] deriveNnf:maxSize-1];
            if (!ld || !rd || maxSize < ([ld count] + [rd count])) return nil;
            else return [NyayaNode conjunction: ld with: rd ];
        }
            
        case NyayaConjunction:  // nnf(!(P&Q)) = nnf(!P) | nnf(!Q)
        case NyayaSequence: {
            NyayaNode *ld = [[NyayaNode negation:first] deriveNnf:maxSize-1];
            NyayaNode *rd = [[NyayaNode negation:second] deriveNnf:maxSize-1];
            if (!ld || !rd || maxSize < ([ld count] + [rd count])) return nil;
            else return [NyayaNode disjunction: ld with: rd ];
        }
            
        default: // nnf(!f(a,b,c)) = !f(nnf(a),nnf(b),nnf(c))
            return [self copyNnf:maxSize-1];
    }
}
@end

@implementation NyayaNodeBinary (Derivations)
@end

@implementation NyayaNodeJunction (Derivations)
@end

@implementation NyayaNodeDisjunction (Derivations)

- (NyayaNode*)cnfDistribution:(NyayaNode*)first with:(NyayaNode*)second {
    if (first.type == NyayaConjunction) {
        NyayaNode *n11 = [first.nodes objectAtIndex:0];
        NyayaNode *n12 = [first.nodes objectAtIndex:1];
        
        return [NyayaNode conjunction:[self cnfDistribution:n11 with:second]
                                 with:[self cnfDistribution:n12 with:second]];
        
        
        
    }
    else if (second.type == NyayaConjunction) {
        NyayaNode *n21 = [second.nodes objectAtIndex:0];
        NyayaNode *n22 = [second.nodes objectAtIndex:1];
        
        return [NyayaNode conjunction:[self cnfDistribution:first with:n21]
                                 with:[self cnfDistribution:first with:n22]];
        
    }
    else { // no conjunctions (literals only)
        return [NyayaNode disjunction:first with:second];
    }
}

- (NyayaNode*)deriveCnf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    
    // dnf (a | (b & c)) = (a | b) & (a | c)
    // dnf ((a & b) | c)) = (a | c) & (b | c)
    // dnf ((a & b) | (c & d)) = (a | c) & (a | d) &| (b | c) & (b | d)
    NyayaNode *ld = [[self.nodes objectAtIndex:0] deriveCnf:maxSize-1];
    NyayaNode *rd = [[self.nodes objectAtIndex:1] deriveCnf:maxSize-1];
    if (!ld || !rd || maxSize < ([ld count] + [rd count])) return nil;
    
    return [self cnfDistribution:ld with: rd];
}

- (NyayaNode *)deriveDnf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    NyayaNode *ld = [[self.nodes objectAtIndex:0] deriveDnf:maxSize-1];
    NyayaNode *rd = [[self.nodes objectAtIndex:1] deriveDnf:maxSize-1];
    if (!ld || !rd || maxSize < ([ld count] + [rd count])) return nil;
    
    return [NyayaNode disjunction:ld with:rd];
}

@end

@implementation NyayaNodeSequence (Derivations)

- (NyayaNode*)std {
    NyayaNode *first = [[self firstNode] std];
    NyayaNode *second = [[self secondNode] std];
    return [NyayaNode conjunction:first with:second];
}

@end

@implementation NyayaNodeConjunction (Derivations)

- (NyayaNode*)deriveCnf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // cnf (A & B) = cnf (A) & cnf (B)
    
    NyayaNode *ld = [[self firstNode] deriveCnf:maxSize-1];
    NyayaNode *rd = [[self secondNode] deriveCnf:maxSize-1];
    if (!ld || !rd || maxSize < ([ld count] + [rd count])) return nil;
    
    return [NyayaNode conjunction:ld with:rd];
}

- (NyayaNode*)dnfDistribution:(NyayaNode*)first with:(NyayaNode*)second {
    if (first.type == NyayaDisjunction) {
        NyayaNode *n11 = [first.nodes objectAtIndex:0];
        NyayaNode *n12 = [first.nodes objectAtIndex:1];
        
        return [NyayaNode disjunction:[self dnfDistribution:n11 with:second]
                                 with:[self dnfDistribution:n12 with:second]];
        
    }
    else if (second.type == NyayaDisjunction) {
        NyayaNode *n21 = [second.nodes objectAtIndex:0];
        NyayaNode *n22 = [second.nodes objectAtIndex:1];
        
        return [NyayaNode disjunction:[self dnfDistribution:first with:n21]
                                 with:[self dnfDistribution:first with:n22]];
        
    }
    else { // no disjunctions (literals only)
        return [NyayaNode conjunction:first with:second];
    }
}

- (NyayaNode*)deriveDnf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // dnf (a & (b | c)) = (a & b) | (a & c)
    // dnf ((a | b) & c)) = (a & c) | (b & c)
    // dnf ((a | b) & (c | d)) = (a & c) | (a & d) | (b & c) | (b & d)
    NyayaNode *ld = [[self firstNode] deriveDnf:maxSize-1];
    NyayaNode *rd = [[self secondNode] deriveDnf:maxSize-1];
    if (!ld || !rd || maxSize < ([ld count] + [rd count])) return nil;
    return [self dnfDistribution:ld with:rd];
}

@end

@implementation NyayaNodeExpandable (Derivations)
@end

@implementation NyayaNodeXdisjunction (Derivations)
- (NyayaNode*)deriveImf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // imf(P ⊻ Q) = (imf(P) ∨ imf(Q)) ∧ (!imf(P) ∨ !imf(Q))
    NyayaNode *first = [[self firstNode] deriveImf:maxSize-1];
    NyayaNode *second = [[self secondNode] deriveImf:maxSize-1];
    if (!first || !second|| maxSize < ([first count] + [second count])) return nil;
    
    return [NyayaNode conjunction:[NyayaNode disjunction:first
                                                    with:second]
                             with:[NyayaNode  disjunction:[NyayaNode negation:first]
                                                     with:[NyayaNode negation:second]]];
    
    /*
    return [NyayaNode disjunction:[NyayaNode conjunction:[NyayaNode negation:first]
                                                    with: second]
                             with:[NyayaNode  conjunction:first
                                                     with:[NyayaNode negation:second]]];
     */
}

@end

@implementation NyayaNodeImplication (Derivations)

- (NyayaNode*)deriveImf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // imf(P → Q) = ¬imf(P) ∨ imf(Q)
    NyayaNode *first = [[self firstNode] deriveImf:maxSize-1];
    NyayaNode *second = [[self secondNode] deriveImf:maxSize-1];
    if (!first || !second || maxSize < ([first count] + [second count])) return nil;
    return [NyayaNode disjunction: [NyayaNode negation:first] with: second];
}

@end

@implementation NyayaNodeEntailment (Derivations)

- (NyayaNode*)std {
    NyayaNode *first = [[self firstNode] std];
    NyayaNode *second = [[self secondNode] std];
    return [NyayaNode implication:first with:second];
}
@end

@implementation NyayaNodeBicondition (Derivations)

- (NyayaNode*)deriveImf:(NSInteger)maxSize {
    if (maxSize < 0) return nil;
    // imf(P ↔ Q) = imf(P → Q) ∧ imf(Q → P) = (¬imf(P) ∨ Q) ∧ (P ∨ ¬imf(Q))
    NyayaNode *first = [[self firstNode] deriveImf:maxSize-1];
    NyayaNode *second = [[self secondNode] deriveImf:maxSize-1];
    if (!first || !second || maxSize < ([first count] + [second count])) return nil;
    
    return [NyayaNode conjunction:[NyayaNode disjunction:[NyayaNode negation:first] with:second]
                             with:[NyayaNode disjunction:[NyayaNode negation:second] with:first]];
    
    //    return [NyayaNode conjunction: [[NyayaNode implication:first with:second] imf]
    //                             with: [[NyayaNode implication:second with:first] imf]];
}
@end

@implementation NyayaNodeFunction (Derivations)
@end


