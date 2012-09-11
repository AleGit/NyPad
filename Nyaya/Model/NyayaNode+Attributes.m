//
//  NyayaNode+Attributes.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Attributes.h"
#import "NyayaNode+Type.h"
#import "NyayaNode_Cluster.h"

@implementation NyayaNode (Attributes)



- (NSUInteger)arity {
    return 0;   // default (constants and variables)
}

- (BOOL)isImplicationFree {
    return YES;
}

- (BOOL)isNegationNormalForm {
    return [self isImplicationFree];
}

- (BOOL)isConjunctiveNormalForm {
    return [self isNegationNormalForm];
}

- (BOOL)isDisjunctiveNormalForm {
    return [self isNegationNormalForm];
}

- (BOOL)isLiteral {
    return NO;
}

- (BOOL)isImfTransformationNode {
    return NO;
}
- (BOOL)isNnfTransformationNode {
    return NO;
}
- (BOOL)isCnfTransformationNode{
    return NO;
}
- (BOOL)isDnfTransformationNode{
    return NO;
}

@end

@implementation NyayaNodeVariable (Attributes)

- (BOOL)isLiteral {
    return YES;
}

@end

@implementation NyayaNodeConstant (Attributes)

- (BOOL)isLiteral {
    return YES;
}
@end

@implementation NyayaNodeUnary (Attributes)

- (NSUInteger)arity {
    return 1;
}

- (BOOL)isImplicationFree {
    return [[self firstNode] isImplicationFree];
}
@end

@implementation NyayaNodeNegation (Attributes)

- (BOOL)isNegationNormalForm {
    return [self firstNode].type <= NyayaVariable;
}

- (BOOL)isLiteral {
    // a negation in nnf is a literal
    return [self isNegationNormalForm];
}

- (BOOL)isNnfTransformationNode {
    switch ([self firstNode].type) {
        case NyayaNegation:         // !!P         => P
        case NyayaConjunction:      // !(P & Q)    => !P | !Q
        case NyayaSequence:         // !(P ; Q)    => !P | !Q
        case NyayaDisjunction:      // !(P | Q)    => !P & !Q
            return YES;
        default:
            return NO;
    }
}

@end

@implementation NyayaNodeBinary (Attributes)

- (NSUInteger)arity {
    return 2;
}

- (BOOL)isImplicationFree {
    return [[self firstNode] isImplicationFree] && [[self secondNode] isImplicationFree];
}

- (BOOL)isNegationNormalForm {
    return [[self firstNode] isNegationNormalForm] && [[self secondNode] isNegationNormalForm];
}
@end

@implementation NyayaNodeJunction (Attributes)
@end

@implementation NyayaNodeDisjunction (Attributes)

- (BOOL)isConjunctiveNormalForm {
    return ([[self firstNode] isLiteral] || ([self firstNode].type == NyayaDisjunction && [[self firstNode] isConjunctiveNormalForm]))
    && ([[self secondNode] isLiteral] ||  ([self secondNode].type == NyayaDisjunction && [[self secondNode] isConjunctiveNormalForm]));
}

- (BOOL)isDisjunctiveNormalForm {
    return [[self firstNode] isDisjunctiveNormalForm] && [[self secondNode] isDisjunctiveNormalForm];
}

- (BOOL)isCnfTransformationNode {
    return [self firstNode].type == NyayaConjunction ||
    [self secondNode].type == NyayaConjunction;
}

@end

@implementation NyayaNodeSequence (Attributes)
@end

@implementation NyayaNodeConjunction (Attributes)

- (BOOL)isConjunctiveNormalForm {
    return [[self firstNode] isConjunctiveNormalForm] && [[self secondNode] isConjunctiveNormalForm];
}

- (BOOL)isDisjunctiveNormalForm {
    return ([[self firstNode] isLiteral] || ([self firstNode].type == NyayaConjunction && [[self firstNode] isDisjunctiveNormalForm]))
    && ([[self secondNode] isLiteral] ||  ([self secondNode].type == NyayaConjunction && [[self secondNode] isDisjunctiveNormalForm]));
}

- (BOOL)isDnfTransformationNode {
    return [self firstNode].type == NyayaDisjunction ||
    [self secondNode].type == NyayaDisjunction;
}


@end

@implementation NyayaNodeExpandable (Attributes)

- (BOOL)isImplicationFree {
    return NO;
}

- (BOOL)isNegationNormalForm {
    return NO;
}

- (BOOL)isImfTransformationNode {
    return YES;
}

@end

@implementation NyayaNodeXdisjunction (Attributes)
@end

@implementation NyayaNodeImplication (Attributes)
@end

@implementation NyayaNodeEntailment (Attributes)
@end

@implementation NyayaNodeBicondition (Attributes)
@end

@implementation NyayaNodeFunction (Attributes)

- (NSUInteger) arity {
    return [self.nodes count];
}

@end



