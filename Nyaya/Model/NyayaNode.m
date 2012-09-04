//
//  NyayaNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"
#import "NyayaStore.h"
#import "NSString+NyayaToken.h"
#import "NSArray+NyayaToken.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Type.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode+Display.h"
#import "NyayaNode+Derivations.h"

@interface NyayaNode ()

- (NyayaNode*)nodeAtIndex:(NSUInteger)index;
@end

#pragma mark - node sub class implementations

@implementation NyayaNodeVariable

- (BOOL)isLiteral {
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (object == self)
        return YES;
    else if (!object || ![object isKindOfClass:[self class]])
        return NO;
    return [self.symbol isEqual:((NyayaNodeVariable*)object).symbol];
}

- (NSUInteger)hash {
    return [self.symbol hash];
}

@end

@implementation NyayaNodeConstant

- (BOOL)isLiteral {
    return YES;
}
@end

@implementation NyayaNodeUnary 

- (NSUInteger)arity {
    return 1;
}

- (NyayaNode*)firstNode {
    return [self nodeAtIndex:0];
}

- (NyayaBool)firstValue {
    return [[self firstNode] displayValue];
}

- (BOOL)isImfFormula {
    return [[self firstNode] isImfFormula];
}
@end

@implementation NyayaNodeNegation

- (BOOL)isNnfFormula {
    return [self firstNode].type <= NyayaVariable;
}

- (BOOL)isLiteral {
    // a negation in nnf is a literal
    return [self isNnfFormula];
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

@implementation NyayaNodeBinary

- (NSUInteger)arity {
    return 2;
}

- (NyayaNode*)secondNode {
    return [self nodeAtIndex:1];
}

- (NyayaBool)secondValue {
    return [[self secondNode] displayValue];
}

- (BOOL)isImfFormula {
    return [[self firstNode] isImfFormula] && [[self secondNode] isImfFormula];
}

- (BOOL)isNnfFormula {
    return [[self firstNode] isNnfFormula] && [[self secondNode] isNnfFormula];
}
@end

@implementation NyayaNodeJunction
@end

@implementation NyayaNodeDisjunction

- (BOOL)isCnfFormula {
    return ([[self firstNode] isLiteral] || ([self firstNode].type == NyayaDisjunction && [[self firstNode] isCnfFormula]))  
    && ([[self secondNode] isLiteral] ||  ([self secondNode].type == NyayaDisjunction && [[self secondNode] isCnfFormula]));      
}

- (BOOL)isDnfFormula {
    return [[self firstNode] isDnfFormula] && [[self secondNode] isDnfFormula];    
}

- (BOOL)isCnfTransformationNode {
    return [self firstNode].type == NyayaConjunction ||
    [self secondNode].type == NyayaConjunction;
}

@end

@implementation NyayaNodeSequence

- (NyayaNode*)std {
    NyayaNode *first = [[self firstNode] std];
    NyayaNode *second = [[self secondNode] std];
    return [NyayaNode conjunction:first with:second];
}

@end

@implementation NyayaNodeConjunction

- (BOOL)isCnfFormula {
    return [[self firstNode] isCnfFormula] && [[self secondNode] isCnfFormula];    
}

- (BOOL)isDnfFormula {
    return ([[self firstNode] isLiteral] || ([self firstNode].type == NyayaConjunction && [[self firstNode] isDnfFormula]))  
    && ([[self secondNode] isLiteral] ||  ([self secondNode].type == NyayaConjunction && [[self secondNode] isDnfFormula]));    
}

- (BOOL)isDnfTransformationNode {
    return [self firstNode].type == NyayaDisjunction ||
    [self secondNode].type == NyayaDisjunction;
}


@end

@implementation NyayaNodeExpandable

- (BOOL)isImfFormula {
    return NO;
}

- (BOOL)isNnfFormula {
    return NO;
}

- (BOOL)isImfTransformationNode {
    return YES;
}

@end

@implementation NyayaNodeXdisjunction
@end

@implementation NyayaNodeImplication
@end

@implementation NyayaNodeEntailment

- (NyayaNode*)std {
    NyayaNode *first = [[self firstNode] std];
    NyayaNode *second = [[self secondNode] std];
    return [NyayaNode implication:first with:second];
}

@end

@implementation NyayaNodeBicondition
@end

@implementation NyayaNodeFunction

- (NSUInteger) arity {
    return [self.nodes count];
}

@end

#pragma mark - abstract root node implementation
@implementation NyayaNode

- (id)copyWithZone:(NSZone*)zone {
    
    return [self copyWith:[self valueForKeyPath:@"nodes.copy"]]; // recursive copy
}

- (NyayaNode*)nodeAtIndex:(NSUInteger)index {
    return [_nodes count] > index ? [_nodes objectAtIndex:index] : nil;
}

- (NSUInteger)arity {
    return 0;   // default (constants and variables)
}

#pragma mark default method implementations

- (NSString*)treeDescription {
    switch (self.type) {
        case NyayaVariable:
        case NyayaConstant:
            return _symbol;
        case NyayaNegation:
            return [NSString stringWithFormat:@"(%@%@)", 
                    self.symbol, [[(NyayaNodeUnary*)self firstNode] treeDescription]];
        case NyayaConjunction:
        case NyayaSequence:
        case NyayaDisjunction:
        case NyayaBicondition:
        case NyayaImplication:
        case NyayaXdisjunction:
            return [NSString stringWithFormat:@"(%@%@%@)",
                    [[(NyayaNodeBinary*)self firstNode] treeDescription], 
                    self.symbol, 
                    [[(NyayaNodeBinary*)self secondNode] treeDescription]];
        case NyayaFunction:
        default:
            return [NSString stringWithFormat:@"%@(%@)", 
                    self.symbol, 
                    [[self valueForKeyPath:@"nodes.treeDescription"] componentsJoinedByString:@","]];
    }
}

- (NyayaNode*)std {
    return [self copy];
}

- (BOOL)isImfFormula {
    return YES;
}

- (BOOL)isNnfFormula {
    return [self isImfFormula];
}

- (BOOL)isCnfFormula {
    return [self isNnfFormula];
}

- (BOOL)isDnfFormula {
    return [self isNnfFormula];
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

- (void)replaceNode:(NyayaNode *)n1 withNode:(NyayaNode *)n2 {
    NSUInteger idx = [self.nodes indexOfObject:n1];
    if (idx != NSNotFound) {
        NSMutableArray *nodes = [self.nodes mutableCopy];
        [nodes replaceObjectAtIndex:idx withObject:n2];
        self->_nodes = nodes;
    }
}

#pragma mark - resolution

- (NSArray*)clauses:(NyayaNodeType)separatorType {
    NSArray *array = nil;
    if (self.type == separatorType) {
        for (NyayaNode *node in self.nodes) {
            if (!array) array = [node clauses:separatorType];
            else array = [array arrayByAddingObjectsFromArray:[node clauses:separatorType]];
        }
    }
    else { 
        array = [NSArray arrayWithObject:self];
    }
    return array;
}

- (NSArray*)clauses:(NyayaNodeType)outer clauses:(NyayaNodeType)inner {
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NyayaNode *clause in [self clauses:outer]) {
        NSMutableSet *set = [NSMutableSet set];
        for (NyayaNode *c in [clause clauses:inner]) {
            [set addObject: [c description]]; // c should b a literal
            
            
        }
        [result addObject:[set copy]];
        
    }
    
    return [result copy];
}

- (NSArray*)conjunctionOfDisjunctions { // cnf is conjunction of disjunctions of literals
    // precondition 'self' is in conjunctive normal form (cnf)
    return [self clauses:NyayaConjunction clauses:NyayaDisjunction];
    
}

- (NSArray*)disjunctionOfConjunctions { // dnf is disjunction of conjunctions of literals
    // precondition 'self' is in disjunctive normal form (dnf)
    return [self clauses:NyayaDisjunction clauses:NyayaConjunction];
}

#pragma mark - subformulas, variables and truth tables

- (NSSet*)setOfSubformulas {
    NSMutableSet *set = [NSMutableSet setWithObject:_descriptionCache];
    
    NSArray *sets = [self valueForKeyPath:@"nodes.setOfSubformulas"];
    for (NSSet* nodeset in sets) {
        [set unionSet:nodeset];
    }
    
    return set;
}

- (NSSet*)setOfVariables {
    NSSet *result = nil;
    if (self.type == NyayaConstant) result = [NSSet set];
    else if (self.type == NyayaVariable) result = [NSSet setWithObject:self];
    else {
        // return [self valueForKeyPath:@"@distinctUnionOfSets.nodes.variables"];
        // result = [self.nodes valueForKeyPath:@"@distinctUnionOfSets.variables"];
        
        
        for (NSSet* subset in [self valueForKeyPath:@"nodes.setOfVariables"]) {
            // for (NSSet* subset in [self.nodes valueForKeyPath:@"variables"]) {
            if (!result) result = subset;
            else result = [result setByAddingObjectsFromSet:subset];
        }
        
        // result = [self valueForKeyPath:@"nodes.@distinctUnionOfSets.variables."];
    }
    return result;
}

- (void)fillHeadersAndEvals:(NSMutableDictionary*)headersAndEvals {
    if (![headersAndEvals objectForKey:_descriptionCache]) {
        [headersAndEvals setValue:[NSNumber numberWithBool:_evaluationValue] forKey:_descriptionCache];
        
        for (NyayaNode *node in _nodes) {
            [node fillHeadersAndEvals:headersAndEvals];
        }
    }
}








@end
