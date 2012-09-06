//
//  NyayaNode+Valuation.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//


#import "NyayaNode+Valuation.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Type.h"
#import "NyayaStore.h"

@implementation NyayaNode (Valuation)
- (BOOL)evaluationValue {
    _evaluationValue = [[NyayaStore sharedInstance] evaluationValueForName:self.symbol];
    return _evaluationValue;
}

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

@implementation NyayaNodeVariable (Valuation)

- (void)setEvaluationValue:(BOOL)evaluationValue {
    _evaluationValue = evaluationValue;
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
