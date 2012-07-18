//
//  NyayaNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode () {
    NyayaBool _value;
    
}
@end

@implementation NyayaNode

@synthesize type = _type;
@synthesize symbol = _symbol;
@synthesize nodes = _nodes;

+ (NyayaNode*)constant:(NSString *)name with:(NyayaBool)value {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = name;
    node->_type = NyayaConstant;
    node->_value = value;
    return node;
}

+ (NyayaNode*)constant:(NSString*)name {
    if ([name isEqualToString:@"T"]) return [self constant:name with:NyayaTrue];
    else if ([name isEqualToString:@"1"]) return [self constant:name with:NyayaTrue];
    else if ([name isEqualToString:@"F"]) return [self constant:name with:NyayaFalse];
    else if ([name isEqualToString:@"0"]) return [self constant:name with:NyayaFalse];
    else return [self constant:name with:NyayaUndefined];
}

+ (NyayaNode*)negation:(NyayaNode *)firstNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"¬";
    node->_type = NyayaNegation;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObject:firstNode];
    return node;
}

+ (NyayaNode*)conjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"∧";
    node->_type = NyayaConjunction;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)disjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"∨";
    node->_type = NyayaDisjunction;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)implication:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = @"→";
    node->_type = NyayaImplication;
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)function:(NSString *)name with:(NSArray *)nodes {
    NyayaNode*node=[[NyayaNode alloc] init];
    node->_symbol = name;
    node->_type = NyayaFunction;
    node->_nodes = [nodes copy];
    return node;
}

- (NyayaBool)value {
    NSUInteger count = [self.nodes count];
    NyayaNode *first = (count > 0) ? [self.nodes objectAtIndex:0] : nil;
    NyayaNode *second = (count > 1) ? [self.nodes objectAtIndex:1] : nil;
    
    switch(_type) {
        case NyayaConstant:
            return _value;
            
        case NyayaNegation:
            if ([first value] == NyayaFalse) return NyayaTrue;
            if ([first value] == NyayaTrue) return NyayaFalse;
            return NyayaUndefined;
            
        case NyayaDisjunction:
            if ([first value] == NyayaTrue || [second value] == NyayaTrue) return NyayaTrue;
            if ([first value] == NyayaFalse && [second value] == NyayaFalse) return NyayaFalse;
            return NyayaUndefined;
            
        case NyayaConjunction:
            if ([first value] == NyayaFalse || [second value] == NyayaFalse) return NyayaFalse;
            if ([first value] == NyayaTrue && [second value] == NyayaTrue) return NyayaTrue;
            return NyayaUndefined;
            
        case NyayaImplication:
            if ([first value] == NyayaFalse || [second value] == NyayaTrue) return NyayaTrue;
            if ([first value] == NyayaTrue && [second value] == NyayaFalse) return NyayaFalse;
            return NyayaUndefined;
        
        case NyayaFunction: // NIY
        default:
            return NyayaUndefined;
    }
}

- (NSString*)treeDescription {
    NSUInteger count = [self.nodes count];
    NyayaNode *first = (count > 0) ? [self.nodes objectAtIndex:0] : nil;
    NyayaNode *second = (count > 1) ? [self.nodes objectAtIndex:1] : nil;
    switch (_type) {
        case NyayaConstant:
            return _symbol;
        case NyayaNegation:
            return [NSString stringWithFormat:@"(%@%@)", self.symbol, [first treeDescription]];
        case NyayaConjunction:
        case NyayaDisjunction:
        case NyayaImplication:
            return [NSString stringWithFormat:@"(%@%@%@)", [first treeDescription], self.symbol, [second treeDescription]];
        case NyayaFunction:
        default:
            return [NSString stringWithFormat:@"%@(%@)", 
                    self.symbol, [[self.nodes valueForKey:@"treeDescription"] componentsJoinedByString:@","]];  
            
            
            
    }
}

- (NSString*)description {
    NSUInteger count = [self.nodes count];
    NyayaNode *first = (count > 0) ? [self.nodes objectAtIndex:0] : nil;
    NyayaNode *second = (count > 1) ? [self.nodes objectAtIndex:1] : nil;
    NSString *left = nil;
    NSString *right = nil;
    
    switch (_type) {
        case NyayaConstant:
            return _symbol;
        case NyayaNegation:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                    right = [first description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [first description]];
                    break;
            }
            return [NSString stringWithFormat:@"%@%@", self.symbol, right];
            
        case NyayaConjunction:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaConjunction: // a ∧ b ∧ c = (a ∧ b) ∧ c (left associative) 
                    left = [first description];
                    break;
                default:
                    left = [NSString stringWithFormat:@"(%@)", [first description]];
                    break;
            }
            
            switch(second.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                // case NyayaConjunction: // a ∧ (b ∧ c) = a ∧ b ∧ c (semantically)
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            
            
            return [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
        case NyayaDisjunction:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaDisjunction:  // a ∨ b ∨ c ≡ (a ∨ b) ∨ c (left associative) 
                    left = [first description];
                    break;
                default:
                    left = [NSString stringWithFormat:@"(%@)", [first description]];
                    break;
            }
            
            switch(second.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                // case NyayaDisjunction: // a ∨ (b ∨ c) = a ∨ b ∨ c (sematnically)
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            
            
            return [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];

        
        case NyayaImplication:
            switch(first.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaConjunction:
                case NyayaDisjunction:
                    left = [first description];
                    break;
                default:
                    left = [NSString stringWithFormat:@"(%@)", [first description]];
                    break;
            }
            
            switch(second.type) {
                case NyayaConstant:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaConjunction:
                case NyayaDisjunction:
                case NyayaImplication:  // right associative
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            return [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
        case NyayaFunction:
            right = [[self.nodes valueForKey:@"description"] componentsJoinedByString:@","];
            return [NSString stringWithFormat:@"%@(%@)", self.symbol, right]; 
            
        default:
            return @"NIY";
    }
}

#pragma mark - cnf, dnf, nnf, imf

- (NyayaNode*)copyWith:(NSArray*)nodes {
    NyayaNode *node=[[NyayaNode alloc] init];
    
    node->_symbol = self.symbol;
    node->_type = self.type;
    node->_value = self.value;
    
    node->_nodes = [nodes copy];
    
    return node;
    
}

- (NyayaNode*)copyImf {
    NSMutableArray *nodes = nil;
    
    if (self.nodes) {
        nodes = [NSMutableArray array];
        for (NyayaNode *n in self.nodes) {
            [nodes addObject:[n imf]];
        }
    }
    
    return [self copyWith:nodes];
    
}

- (NyayaNode*)copyNnf {
    NSMutableArray *nodes = nil;
    
    if (self.nodes) {
        nodes = [NSMutableArray array];
        for (NyayaNode *n in self.nodes) {
            [nodes addObject:[n nnf]];
        }
    }
    
    return [self copyWith:nodes];
    
}

- (NyayaNode*)imf {
    if (self.type == NyayaImplication) {
        NyayaNode *first = [[self.nodes objectAtIndex:0] imf];
        NyayaNode *second = [[self.nodes objectAtIndex:1] imf];
        NyayaNode *notfirst = [NyayaNode negation:first];
        return [NyayaNode disjunction: notfirst with: second];
    }
    else {
        return [self copyImf];
    }
}


- (NyayaNode*)nnf {
    // precondition 'self' is implication free, {¬ ∨ ∧} is a adequate set of boolean functions
    if (self.type == NyayaNegation) {
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
                return [NyayaNode disjunction: [[NyayaNode negation:first] nnf]
                                         with: [[NyayaNode negation:second] nnf] ];
        
            default: // nnf(!f(a,b,c)) = !f(nnf(a),nnf(b),nnf(c))
                return [self copyNnf];
        }
    }
    else {
        return [self copyNnf];
    }
}





+ (NyayaNode*)cnfDistribution:(NyayaNode*)first with:(NyayaNode*)second {
    if (first.type == NyayaConjunction) {
        NyayaNode *n11 = [first.nodes objectAtIndex:0];
        NyayaNode *n12 = [first.nodes objectAtIndex:1];
        
        return [NyayaNode conjunction:[NyayaNode cnfDistribution:n11 with:second] 
                                 with:[NyayaNode cnfDistribution:n12 with:second]];
        
        
        
    }
    else if (second.type == NyayaConjunction) {
        NyayaNode *n21 = [second.nodes objectAtIndex:0];
        NyayaNode *n22 = [second.nodes objectAtIndex:1];
        
        return [NyayaNode conjunction:[NyayaNode cnfDistribution:first with:n21] 
                                 with:[NyayaNode cnfDistribution:first with:n22]];
        
    }
    else { // no conjunctions
        return [NyayaNode disjunction:first with:second];
    }
}

- (NyayaNode*)cnf {
    // precondition 'self' is implication free and in negation normal form
    switch(self.type) {
        case NyayaConjunction:
            return [NyayaNode conjunction:[[self.nodes objectAtIndex:0] cnf] 
                                     with:[[self.nodes objectAtIndex:1] cnf]];
            
            
        case NyayaDisjunction:
            return [NyayaNode cnfDistribution:[[self.nodes objectAtIndex:0] cnf] 
                                      with:[[self.nodes objectAtIndex:1] cnf]];
            
        default:
            return self;
    }
}



+ (NyayaNode*)dnfDistribution:(NyayaNode*)first with:(NyayaNode*)second {
    if (first.type == NyayaDisjunction) {
        NyayaNode *n11 = [first.nodes objectAtIndex:0];
        NyayaNode *n12 = [first.nodes objectAtIndex:1];
        
        return [NyayaNode disjunction:[NyayaNode dnfDistribution:n11 with:second] 
                                 with:[NyayaNode dnfDistribution:n12 with:second]];
        
        
        
    }
    else if (second.type == NyayaDisjunction) {
        NyayaNode *n21 = [second.nodes objectAtIndex:0];
        NyayaNode *n22 = [second.nodes objectAtIndex:1];
        
        return [NyayaNode disjunction:[NyayaNode dnfDistribution:first with:n21] 
                                 with:[NyayaNode dnfDistribution:first with:n22]];
        
    }
    else { // no disjunction
        return [NyayaNode conjunction:first with:second];
    }
}

- (NyayaNode *)dnf {
    // precondition 'self' is implication free and in negation normal form
    switch(self.type) {
        case NyayaDisjunction:
            return [NyayaNode disjunction:[[self.nodes objectAtIndex:0] dnf] 
                                     with:[[self.nodes objectAtIndex:1] dnf]];
            
            
        case NyayaConjunction:
            return [NyayaNode dnfDistribution:[[self.nodes objectAtIndex:0] dnf] 
                                      with:[[self.nodes objectAtIndex:1] dnf]];
            
        default:
            return self;
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





@end
