//
//  NyayaNode+Valuation.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//


#import "NyayaNode+Valuation.h"
#import "NyayaNode_Cluster.h"
#import "NyayaStore.h"

@implementation NyayaNode (Valuation)
- (BOOL)evaluationValue {
    _evaluationValue = [[NyayaStore sharedInstance] evaluationValueForName:self.symbol];
    return _evaluationValue;
}
@end

@implementation NyayaNodeVariable (Valuation)

- (void)setEvaluationValue:(BOOL)evaluationValue {
    [[NyayaStore sharedInstance] setEvaluationValue:evaluationValue forName:self.symbol];
}

@end

@implementation NyayaNodeConstant (Valuation)
@end

@implementation NyayaNodeUnary (Valuation)
@end

@implementation NyayaNodeNegation (Valuation)

- (BOOL)evaluationValue {
    _evaluationValue = ![[self firstNode] evaluationValue];
    return _evaluationValue;
}
@end

@implementation NyayaNodeBinary (Valuation)
@end

@implementation NyayaNodeJunction (Valuation)
@end

@implementation NyayaNodeDisjunction (Valuation)

- (BOOL)evaluationValue {
    _evaluationValue = [[self firstNode] evaluationValue] | [[self secondNode] evaluationValue];
    return _evaluationValue;
}
@end

@implementation NyayaNodeSequence  (Valuation)
@end

@implementation NyayaNodeConjunction (Valuation)
- (BOOL)evaluationValue {
    _evaluationValue = [[self firstNode] evaluationValue] & [[self secondNode] evaluationValue];
    return _evaluationValue;
}
@end

@implementation NyayaNodeExpandable (Valuation)
@end

@implementation NyayaNodeXdisjunction (Valuation)

- (BOOL)evaluationValue {
    _evaluationValue = [[self firstNode] evaluationValue] ^ [[self secondNode] evaluationValue];
    return _evaluationValue;
}
@end

@implementation NyayaNodeImplication (Valuation)

- (BOOL)evaluationValue {
    _evaluationValue = ![[self firstNode] evaluationValue] | [[self secondNode] evaluationValue];
    return _evaluationValue;
}
@end

@implementation NyayaNodeEntailment (Valuation)
@end

@implementation NyayaNodeBicondition (Valuation)

- (BOOL)evaluationValue {
    _evaluationValue = (![[self firstNode] evaluationValue] | [[self secondNode] evaluationValue])
    & (![[self secondNode] evaluationValue] | [[self firstNode] evaluationValue]);
    return _evaluationValue;
}
@end

@implementation NyayaNodeFunction (Valuation)
@end
