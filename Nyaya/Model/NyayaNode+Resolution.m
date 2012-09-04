//
//  NyayaNode+Resolution.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Resolution.h"

@implementation NyayaNode (Resolution)

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


@end
