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

@implementation NyayaNode (Derivations)

- (NyayaNode*)copyWith:(NSArray*)nodes {
    NyayaNode *node = nil;
    
    node = [[[self class] alloc] init];
    
    node->_symbol = self.symbol;
    node->_displayValue = self.displayValue;
    node->_evaluationValue = self.evaluationValue;
    node->_nodes = [nodes copy];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    
    return node;
}

- (NyayaNode*)copyImf {
    NSArray *nodes = [self valueForKeyPath:@"nodes.imf"];
    return [self copyWith:nodes];
}

- (NyayaNode*)copyNnf {
    NSArray *nodes = [self valueForKeyPath:@"nodes.nnf"];
    
    return [self copyWith:nodes];
}

- (NyayaNode*)imf {
    // no precondition
    return [self copy];
}

- (NyayaNode*)nnf {
    // precondition 'self' is implication free
    return [self copy];
}

- (NyayaNode*)cnf {
    // precondition 'self' is implication free and in negation normal form
    return [self copy];
}

- (NyayaNode *)dnf {
    // precondition 'self' is implication free and in negation normal form
    return [self copy];
}

@end

@implementation NyayaNodeVariable (Derivations)
@end

@implementation NyayaNodeConstant (Derivations)
@end

@implementation NyayaNodeUnary (Derivations)

- (NyayaNode*)imf {
    // imf(a)   =  a
    // imf(¬P)  = ¬imf(P)
    // imf(P∨Q) = imf(P) ∨ imf(Q)
    // imf(P∧Q) = imf(P) ∧ imf(Q)
    return [self copyImf];
}

- (NyayaNode*)nnf {
    return [self copyNnf];
}

@end

@implementation NyayaNodeNegation (Derivations)

- (NyayaNode*)nnf {
    NyayaNode *node = [self.nodes objectAtIndex:0];
    
    NSUInteger count = [node.nodes count];
    NyayaNode *first = (count > 0) ? [node.nodes objectAtIndex:0] : nil;
    NyayaNode *second = (count > 1) ? [node.nodes objectAtIndex:1] : nil;
    
    switch (node.type) {
        case NyayaNegation: // nnf(!!P) = nnf(P)
            return [first nnf];
        case NyayaDisjunction: // nnf(!(P|Q)) = nnf(!P) & nnf(!Q)
            return [NyayaNode conjunction: [[NyayaNode negation:first] nnf]
                                     with: [[NyayaNode negation:second] nnf] ];
            
        case NyayaConjunction:  // nnf(!(P&Q)) = nnf(!P) | nnf(!Q)
        case NyayaSequence:
            return [NyayaNode disjunction: [[NyayaNode negation:first] nnf]
                                     with: [[NyayaNode negation:second] nnf] ];
            
        default: // nnf(!f(a,b,c)) = !f(nnf(a),nnf(b),nnf(c))
            return [self copyNnf];
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

- (NyayaNode*)cnf {
    
    // dnf (a | (b & c)) = (a | b) & (a | c)
    // dnf ((a & b) | c)) = (a | c) & (b | c)
    // dnf ((a & b) | (c & d)) = (a | c) & (a | d) &| (b | c) & (b | d)
    return [self cnfDistribution:[[self.nodes objectAtIndex:0] cnf]
                            with:[[self.nodes objectAtIndex:1] cnf]];
}

- (NyayaNode *)dnf {
    return [NyayaNode disjunction:[[self.nodes objectAtIndex:0] dnf]
                             with:[[self.nodes objectAtIndex:1] dnf]];
}

@end

@implementation NyayaNodeSequence (Derivations)

@end

@implementation NyayaNodeConjunction (Derivations)

- (NyayaNode*)cnf {
    // cnf (A & B) = cnf (A) & cnf (B)
    return [NyayaNode conjunction:[[self firstNode] cnf]
                             with:[[self secondNode] cnf]];
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

- (NyayaNode*)dnf {
    // dnf (a & (b | c)) = (a & b) | (a & c)
    // dnf ((a | b) & c)) = (a & c) | (b & c)
    // dnf ((a | b) & (c | d)) = (a & c) | (a & d) | (b & c) | (b & d)
    return [self dnfDistribution:[[self firstNode] dnf]
                            with:[[self secondNode] dnf]];
}

@end

@implementation NyayaNodeExpandable (Derivations)
@end

@implementation NyayaNodeXdisjunction (Derivations)
- (NyayaNode*)imf {
    // imf(P ⊻ Q) = (imf(P) ∨ imf(Q)) ∧ (!imf(P) ∨ !imf(Q))
    NyayaNode *first = [[self firstNode] imf];
    NyayaNode *second = [[self secondNode] imf];
    return [NyayaNode conjunction:[NyayaNode disjunction:first
                                                    with:second]
                             with:[NyayaNode  disjunction:[NyayaNode negation:first]
                                                     with:[NyayaNode negation:second]]];
}

@end

@implementation NyayaNodeImplication (Derivations)

- (NyayaNode*)imf {
    // imf(P → Q) = ¬imf(P) ∨ imf(Q)
    NyayaNode *first = [[self firstNode] imf];
    NyayaNode *second = [[self secondNode] imf];
    return [NyayaNode disjunction: [NyayaNode negation:first] with: second];
}

@end

@implementation NyayaNodeEntailment (Derivations)
@end

@implementation NyayaNodeBicondition (Derivations)

- (NyayaNode*)imf {
    // imf(P ↔ Q) = imf(P → Q) ∧ imf(Q → P) = (¬imf(P) ∨ Q) ∧ (P ∨ ¬imf(Q))
    NyayaNode *first = [[self firstNode] imf];
    NyayaNode *second = [[self secondNode] imf];
    
    return [NyayaNode conjunction:[NyayaNode disjunction:[NyayaNode negation:first] with:second]
                             with:[NyayaNode disjunction:[NyayaNode negation:second] with:first]];
    
    //    return [NyayaNode conjunction: [[NyayaNode implication:first with:second] imf]
    //                             with: [[NyayaNode implication:second with:first] imf]];
}
@end

@implementation NyayaNodeFunction (Derivations)
@end


