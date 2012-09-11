//
//  NyayaNode_Cluster.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"
#import "NyayaParser.h"
#import "TruthTable.h"
#import "BddNode.h"


enum { NyayaUndefined=0, NyayaFalse, NyayaTrue };
typedef NSUInteger NyayaBool;

enum { // NyayaUndefined=0
    NyayaConstant=1, NyayaVariable,
    NyayaNegation,
    NyayaConjunction, NyayaDisjunction, NyayaXdisjunction, NyayaImplication, NyayaBicondition,
    NyayaFunction
    , NyayaSequence     // a conjunction with lower precedence than everything but eintailment
    , NyayaEntailment   // an implication with lowest precedence
};
typedef NSUInteger NyayaNodeType;

@interface NyayaNode () {
    
    @protected
    
    NSString *_descriptionCache;
    NSString *_symbol;
    NyayaBool _displayValue;
    BOOL _evaluationValue;
    NSMutableArray *_nodes;
    
    BOOL _hasParsingErrors;
    
    NyayaNode *_reducedNode;
    
    NyayaNode *_imfNode;
    NyayaNode *_nnfNode;
    NyayaNode *_cnfNode;
    NyayaNode *_dnfNode;

    TruthTable *_truthTable;
    BddNode *_bddNode;
    
    // consolidation
    
}
- (BOOL)isNegationToNode:(NyayaNode*)other;
- (NyayaNode*)nodeAtIndex:(NSUInteger)index;
@end

#pragma mark - node sub class interfaces

// arity    abstract classes         concrete classes
//
// 0        NyayaNode            -   NyayaNode(Variable|Constant)
//              |
// 1        NyayaNodeUnary       -   NyayaNodeNegation
//              |
// 2        NyayaNodeBinary      -   NyayaNode(Conjunction|Disjunction|Bicondition|Implication|Xdisjunction)

@interface NyayaNodeVariable : NyayaNode
@end

@interface NyayaNodeConstant : NyayaNode
@end

@interface NyayaNodeUnary : NyayaNode
- (NyayaNode*)firstNode;
@end

@interface NyayaNodeNegation : NyayaNodeUnary
@end

@interface NyayaNodeBinary : NyayaNodeUnary
- (NyayaNode*)secondNode;
@end

@interface NyayaNodeJunction : NyayaNodeBinary
@end

@interface NyayaNodeConjunction : NyayaNodeJunction
@end

@interface NyayaNodeSequence : NyayaNodeConjunction
@end

@interface NyayaNodeDisjunction : NyayaNodeJunction
@end

@interface NyayaNodeExpandable : NyayaNodeBinary
@end

@interface NyayaNodeImplication : NyayaNodeExpandable
@end

@interface NyayaNodeEntailment : NyayaNodeImplication
@end

@interface NyayaNodeBicondition : NyayaNodeExpandable
@end

@interface NyayaNodeXdisjunction : NyayaNodeExpandable
@end

@interface NyayaNodeFunction : NyayaNode {
    NSUInteger _arity;
}
@end
