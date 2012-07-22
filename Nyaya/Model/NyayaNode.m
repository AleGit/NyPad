//
//  NyayaNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"
#import "NyayaStore.h"

@interface NyayaNode () {
    @protected
    NyayaBool _value;
}
- (void)setValue:(NyayaBool)value;
- (NyayaNode*)nodeAtIndex:(NSUInteger)index;
@end

#pragma mark - node sub class interfaces

@interface NyayaNodeConstant : NyayaNode
@end

@interface NyayaNodeNegation : NyayaNode 
@end

@interface NyayaNodeConjunction : NyayaNode 
@end

@interface NyayaNodeDisjunction : NyayaNode 
@end

@interface NyayaNodeImplication : NyayaNode 
@end

@interface NyayaNodeBicondition : NyayaNode 
@end

@interface NyayaNodeFunction : NyayaNode 
@end

#pragma mark - node sub class implementations
    
@implementation NyayaNodeConstant

- (NyayaNodeType)type { 
    return NyayaConstant; 
}

- (void)setEvaluation:(BOOL)evaluation {
    // ignore because it's a constant!
}
@end

@implementation NyayaNodeNegation

- (NyayaNodeType)type {
    return NyayaNegation;
}

- (NyayaBool)value {
    NyayaBool firstValue = [[self nodeAtIndex:0] value];
    if (firstValue == NyayaFalse) return NyayaTrue;
    else if (firstValue == NyayaTrue) return NyayaFalse;
    else return NyayaUndefined;
}

- (BOOL)evaluation {
    return ![[self nodeAtIndex:0] evaluation]; 
}

- (NSString*)description {
    NSString *result = nil;
    NyayaNode *first = [self nodeAtIndex:0];
    NSString *right = nil;
    
    switch(first.type) {
        case NyayaConstant:
        case NyayaVariable:
        case NyayaNegation:
        case NyayaFunction: // NIY
            right = [first description];
            break;
        default:
            right = [NSString stringWithFormat:@"(%@)", [first description]];
            break;
    }
    result =  [NSString stringWithFormat:@"%@%@", self.symbol, right];
    
    return [result stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
}

@end

@implementation NyayaNodeDisjunction

- (NyayaNodeType)type {
    return NyayaDisjunction;
}

- (NyayaBool)value { 
    NyayaBool firstValue = [[self nodeAtIndex:0] value];
    NyayaBool secondValue = [[self nodeAtIndex:1] value];
    
    if (firstValue == NyayaTrue || secondValue == NyayaTrue) return NyayaTrue;
    else if (firstValue == NyayaFalse && secondValue == NyayaFalse) return NyayaFalse;
    else return NyayaUndefined;
}

- (BOOL)evaluation {
    return [[self nodeAtIndex:0] evaluation] || [[self nodeAtIndex:1] evaluation]; 
}

- (NSString*)description {
    NSString *result = nil;
    NyayaNode *first = [self nodeAtIndex:0];
    NyayaNode *second = [self nodeAtIndex:1];
    NSString *left = nil;
    NSString *right = nil;
    
    switch(first.type) {
        case NyayaConstant:
        case NyayaVariable:
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
                case NyayaVariable:
                case NyayaNegation:
                case NyayaFunction: // NIY
                    // case NyayaDisjunction: // a ∨ (b ∨ c) = a ∨ b ∨ c (sematnically)
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            
            
            result =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
    return [result stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
}
@end

@implementation NyayaNodeConjunction

- (NyayaNodeType)type {
    return NyayaConjunction;
}

- (NyayaBool)value { 
    NyayaBool firstValue = [[self nodeAtIndex:0] value];
    NyayaBool secondValue = [[self nodeAtIndex:1] value];
    
    if (firstValue == NyayaFalse || secondValue == NyayaFalse) return NyayaFalse;
    else if (firstValue == NyayaTrue && secondValue == NyayaTrue) return NyayaTrue;
    else return NyayaUndefined;
}

- (BOOL)evaluation {
    return [[self nodeAtIndex:0] evaluation] && [[self nodeAtIndex:1] evaluation]; 
}

- (NSString*)description {
    NSString *result = nil;
    NyayaNode *first = [self nodeAtIndex:0];
    NyayaNode *second = [self nodeAtIndex:1];
    NSString *left = nil;
    NSString *right = nil;
    
    
        switch(first.type) {
            case NyayaConstant:
            case NyayaVariable:
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
                case NyayaVariable:
                case NyayaNegation:
                case NyayaFunction: // NIY
                    // case NyayaConjunction: // a ∧ (b ∧ c) = a ∧ b ∧ c (semantically)
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            
            
            result =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
            
    return [result stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
}
@end

@implementation NyayaNodeImplication

- (NyayaNodeType)type {
    return NyayaImplication;
}

- (NyayaBool)value {
    NyayaBool firstValue = [[self nodeAtIndex:0] value];
    NyayaBool secondValue = [[self nodeAtIndex:1] value];
    
    if (firstValue == NyayaFalse || secondValue == NyayaTrue) return NyayaTrue;
    else if (firstValue == NyayaTrue && secondValue == NyayaFalse) return NyayaFalse;
    else return NyayaUndefined;
}

- (BOOL)evaluation {
    return ![[self nodeAtIndex:0] evaluation] || [[self nodeAtIndex:1] evaluation]; 
}

- (NSString*)description {
    NSString *result = nil;
    NyayaNode *first = [self nodeAtIndex:0];
    NyayaNode *second = [self nodeAtIndex:1];
    NSString *left = nil;
    NSString *right = nil;
    
    switch(first.type) {
        case NyayaConstant:
        case NyayaVariable:
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
                case NyayaVariable:
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
            result =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
    return [result stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
}
@end

@implementation NyayaNodeBicondition

- (NyayaNodeType)type {
    return NyayaBicondition;
}

- (NyayaBool)value { 
    NyayaBool firstValue = [[self nodeAtIndex:0] value];
    NyayaBool secondValue = [[self nodeAtIndex:1] value];
    
    if (firstValue == NyayaUndefined || secondValue == NyayaUndefined) return NyayaUndefined;
    else if (firstValue == secondValue) return NyayaTrue;
    else return NyayaFalse;
}

- (BOOL)evaluation {
    return (![[self nodeAtIndex:0] evaluation] || [[self nodeAtIndex:1] evaluation])
    && (![[self nodeAtIndex:1] evaluation] || [[self nodeAtIndex:0] evaluation]); 
}

- (NSString*)description {
    NSString *result = nil;
    NyayaNode *first = [self nodeAtIndex:0];
    NyayaNode *second = [self nodeAtIndex:1];
    NSString *left = nil;
    NSString *right = nil;
    
    
            switch(first.type) {
                case NyayaConstant:
                case NyayaVariable:
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
                case NyayaVariable:
                case NyayaNegation:
                case NyayaFunction: // NIY
                case NyayaConjunction:
                case NyayaDisjunction:
                case NyayaBicondition:  // right associative
                    right = [second description];
                    break;
                default:
                    right = [NSString stringWithFormat:@"(%@)", [second description]];
                    break;
            }
            result =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
            
    return [result stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
}
@end

@implementation NyayaNodeFunction

- (NyayaNodeType)type {
    return NyayaFunction;
}

- (NSString*)description {
    NSString *right = [[self.nodes valueForKey:@"description"] componentsJoinedByString:@","];
    return [NSString stringWithFormat:@"%@(%@)", self.symbol, right]; 
}

@end

#pragma mark - noder root class implementation
@implementation NyayaNode

@synthesize symbol = _symbol;
@synthesize nodes = _nodes;
@synthesize value = _value;
@synthesize evaluation = _evaluation;

- (NyayaNodeType)type {
    return NyayaVariable;
}

- (void)setValue:(NyayaBool)value {
    _value = value;
}

- (NyayaNode*)nodeAtIndex:(NSUInteger)index {
    return [_nodes count] > index ? [_nodes objectAtIndex:index] : nil;
}

+ (NyayaNode*)atom:(NSString*)name {
    NyayaStore *store = [NyayaStore sharedInstance];
    NyayaNode *node = [store nodeForName:name];
    if (!node) {
        if ([name isEqualToString:@"T"] || [name isEqualToString:@"1"]) {
            node = [[NyayaNodeConstant alloc] init];
            node->_value = NyayaTrue;
            node->_evaluation = TRUE;            
        }
        else if ([name isEqualToString:@"F"] || [name isEqualToString:@"0"]) {
            node = [[NyayaNodeConstant alloc] init];
            node->_value = NyayaFalse;
            node->_evaluation = FALSE; 
        }
        else {
            node = [[NyayaNode alloc] init];
            node->_value = NyayaUndefined;
        };
        
        node->_symbol = name;
        [store setNode:node forName:node.symbol];
    }
    return node;
}

+ (NyayaNode*)negation:(NyayaNode *)firstNode {
    NyayaNode*node=[[NyayaNodeNegation alloc] init];
    node->_symbol = @"¬";
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode, nil];
    return node;
}

+ (NyayaNode*)conjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeConjunction alloc] init];
    node->_symbol = @"∧";
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)disjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeDisjunction alloc] init];
    node->_symbol = @"∨";
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)implication:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeImplication alloc] init];
    node->_symbol = @"→";
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)bicondition:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeBicondition alloc] init];
    node->_symbol = @"↔";
    node->_value = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    return node;
}

+ (NyayaNode*)function:(NSString *)name with:(NSArray *)nodes {
    NyayaNode*node=[[NyayaNodeFunction alloc] init];
    // node->isa = [NyayaNodeFunction class];
    node->_symbol = name;
    node->_nodes = [nodes copy];
    return node;
}

- (NSString*)treeDescription {
    switch (self.type) {
        case NyayaVariable:
        case NyayaConstant:
            return _symbol;
        case NyayaNegation:
            return [NSString stringWithFormat:@"(%@%@)", 
                    self.symbol, [[self nodeAtIndex:0] treeDescription]];
        case NyayaConjunction:
        case NyayaDisjunction:
        case NyayaImplication:
        case NyayaBicondition:
            return [NSString stringWithFormat:@"(%@%@%@)", 
                    [[self nodeAtIndex:0] treeDescription], 
                    self.symbol, 
                    [[self nodeAtIndex:1] treeDescription]];
        case NyayaFunction:
        default:
            return [NSString stringWithFormat:@"%@(%@)", 
                    self.symbol, 
                    [[self.nodes valueForKey:@"treeDescription"] componentsJoinedByString:@","]];  
            
            
            
    }
}

- (NSString*)description {
    return _symbol;
}

#pragma mark - cnf, dnf, nnf, imf



- (NyayaNode*)copyWith:(NSArray*)nodes {
    NyayaNode *node = nil;
    
    if (self.type == NyayaUndefined) {
        NSLog(@"+++ '%@' '%@' +++", [self description], self.symbol);
        node = [[NyayaStore sharedInstance] nodeForName:self.symbol];
    }
    
    else if (self.type <= NyayaVariable) {
        // node = [[NyayaStore sharedInstance] nodeForName:self.symbol];
        node = self;
    }
    
    if (!node) {
        node = [[[self class] alloc] init];
    
        node->_symbol = self.symbol;
        node->_value = self.value;
        node->_evaluation = self.evaluation;
        node->_nodes = [nodes copy];
    }    
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
    if (self.type == NyayaImplication || self.type == NyayaBicondition) {
        NyayaNode *first = [[self.nodes objectAtIndex:0] imf];
        NyayaNode *second = [[self.nodes objectAtIndex:1] imf];
        
        if (self.type == NyayaImplication) {
            NyayaNode *notfirst = [NyayaNode negation:first];
            return [NyayaNode disjunction: notfirst with: second];
        }
        else {
            return [NyayaNode conjunction: [[NyayaNode implication:first with:second] imf]
                                     with: [[NyayaNode implication:second with:first] imf]];
        }
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
    else { // no conjunctions (literals only)
        return [NyayaNode disjunction:first with:second];
    }
}

- (NyayaNode*)cnf {
    // precondition 'self' is implication free and in negation normal form
    
    switch(self.type) {
        case NyayaConjunction:
            // cnf (A & B) = cnf (A) & cnf (B)
            return [NyayaNode conjunction:[[self.nodes objectAtIndex:0] cnf] 
                                     with:[[self.nodes objectAtIndex:1] cnf]];
            
            
        case NyayaDisjunction:
            // dnf (a | (b & c)) = (a | b) & (a | c)
            // dnf ((a & b) | c)) = (a | c) & (b | c)
            // dnf ((a & b) | (c & d)) = (a | c) & (a | d) &| (b | c) & (b | d)
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
    else { // no disjunctions (literals only)
        return [NyayaNode conjunction:first with:second];
    }
}

- (NyayaNode *)dnf {
    // precondition 'self' is implication free and in negation normal form
    
    switch(self.type) {
        case NyayaDisjunction:
            // dnf (A | B) = dnf(A) | (dnf(B)
            return [NyayaNode disjunction:[[self.nodes objectAtIndex:0] dnf] 
                                     with:[[self.nodes objectAtIndex:1] dnf]];
            
            
        case NyayaConjunction:
            // dnf (a & (b | c)) = (a & b) | (a & c)
            // dnf ((a | b) & c)) = (a & c) | (b & c)
            // dnf ((a | b) & (c | d)) = (a & c) | (a & d) | (b & c) | (b & d)
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

#pragma mark - subformulas

- (NSSet*)subformulas {
    NSSet *set = [NSSet setWithObject:[self description]];
    
    
    for (NSSet* subset in [self valueForKeyPath:@"nodes.subformulas.description"]) {
       
        set = [set setByAddingObjectsFromSet:subset];
    }
     
    
    // set = [set setByAddingObjectsFromSet:[self valueForKeyPath:@"nodes.subformulas.@distinctUnionOfSets.description"]];
    
    // array = [array arrayByAddingObjectsFromArray:[self valueForKeyPath:@"nodes.subformulas.description"]];
    
    return set;
    
}

- (NSArray*)sortedSubformulas {
    NSArray *array = [[self subformulas] allObjects];
    
    return [array sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        if ([obj1 length] < [obj2 length]) return -1;
        else if ([obj1 length] > [obj2 length]) return 1;
        else return [obj1 compare:obj2];
    }];
    
}


- (NSSet*)variables {
    NSSet *result = nil;
    if (self.type == NyayaConstant) result = [NSSet set];
    else if (self.type == NyayaVariable) result = [NSSet setWithObject:self];
    else {
        // return [self valueForKeyPath:@"@distinctUnionOfSets.nodes.variables"];
        // result = [self.nodes valueForKeyPath:@"@distinctUnionOfSets.variables"];
        
        
        for (NSSet* subset in [self valueForKeyPath:@"nodes.variables"]) {
        // for (NSSet* subset in [self.nodes valueForKeyPath:@"variables"]) {
            if (!result) result = subset;
            else result = [result setByAddingObjectsFromSet:subset];
        }
        
        
        
    }
    return result;
    
}



@end
