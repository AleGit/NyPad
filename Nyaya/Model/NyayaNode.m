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

@interface NyayaNode () {
    
@protected
    NSString *_descriptionCache;
    NyayaBool _displayValue;
    BOOL _evaluationValue;
}
- (NyayaNode*)nodeAtIndex:(NSUInteger)index;
- (NyayaNode*)copyImf;
- (NyayaNode*)copyNnf;

@end

#pragma mark - node sub class interfaces

// arity    abstract classes         concrete classes
//
// 0        NyayaNode            -   NyayaNode(Variable|Constant)
//              |
// 1        NyayaNodeUnary       -   NyayaNodeNegation
//              |        
// 2        NyayaNodeBinary      -   NyayaNode(Conjunction|Disjunction|Bicondition|Implication|Xdisjunction)

@interface NyayaNodeConstant : NyayaNode
@end

@interface NyayaNodeUnary : NyayaNode
- (NyayaNode*)firstNode;
- (NyayaBool)firstValue;
@end

@interface NyayaNodeNegation : NyayaNodeUnary 
@end

@interface NyayaNodeBinary : NyayaNodeUnary
- (NyayaNode*)secondNode;
- (NyayaBool)secondValue;
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

#pragma mark - node sub class implementations

@implementation NyayaNodeVariable

- (NyayaNodeType)type { 
    return NyayaVariable;
}

- (void)setDisplayValue:(NyayaBool)displayValue {
    [[NyayaStore sharedInstance] setDisplayValue:displayValue forName:self.symbol];
    
}
- (void)setEvaluationValue:(BOOL)evaluationValue {
    [[NyayaStore sharedInstance] setEvaluationValue:evaluationValue forName:self.symbol];
}

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

- (NyayaNodeType)type { 
    return NyayaConstant; 
}

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

- (NyayaNode*)imf {
    // imf(a)   =  a
    // imf(¬P)  = ¬imf(P)
    // imf(P∨Q) = imf(P) ∨ imf(Q)
    // imf(P∧Q) = imf(P) ∧ imf(Q)
    return [self copyImf];
}

- (BOOL)isImfFormula {
    return [[self firstNode] isImfFormula];
}


- (NyayaNode*)nnf {
    return [self copyNnf];
}

@end

@implementation NyayaNodeNegation

- (NyayaNodeType)type {
    return NyayaNegation;
}

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    
    if (firstValue == NyayaFalse) _displayValue = NyayaTrue;
    else if (firstValue == NyayaTrue) _displayValue = NyayaFalse;
    else return _displayValue = NyayaUndefined;
    
    return _displayValue;
}

- (BOOL)evaluationValue {
    _evaluationValue = ![[self firstNode] evaluationValue];
    return _evaluationValue; 
}

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NSString *right = nil;
    
    switch(first.type) {
        case NyayaConstant:     // leaf                 : ¬T    ≡ ¬(T)
        case NyayaVariable:     // leaf                 : ¬a    ≡ ¬(a)
        case NyayaNegation:     // right associative    : ¬¬P   ≡ ¬(¬P)
        case NyayaFunction:     // prefix notation      : ¬f(…) ≡ ¬(f(…))
            right = [first description];
            break;
        default:
            right = [NSString stringWithFormat:@"(%@)", [first description]];
            break;
    }
    _descriptionCache =  [NSString stringWithFormat:@"%@%@", self.symbol, right];
    
    return _descriptionCache;
}

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

- (NyayaNodeType)type {
    return NyayaDisjunction;
}

- (NyayaBool)displayValue { 
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaTrue || secondValue == NyayaTrue) _displayValue = NyayaTrue;
    else if (firstValue == NyayaFalse && secondValue == NyayaFalse) _displayValue = NyayaFalse;
    else _displayValue = NyayaUndefined;
    
    return _displayValue;
}

- (BOOL)evaluationValue {
    _evaluationValue = [[self firstNode] evaluationValue] | [[self secondNode] evaluationValue]; 
    return _evaluationValue;
}

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    NSString *left = nil;
    NSString *right = nil;
    
    switch(first.type) {
        case NyayaConstant:     // leaf                 : T ∨ …     ≡ (T) ∨ …
        case NyayaVariable:     // leaf                 : a ∨ …     ≡ (a) ∨ …
        case NyayaNegation:     // higher precedence    : ¬P ∨ …    ≡ (¬P) ∨ …
        // case NyayaConjunction:  // higher precedence
        case NyayaDisjunction:  // left associative     : a ∨ b ∨ c ≡ (a ∨ b) ∨ c
        case NyayaFunction:     // prefix notation      : f(…) ∨ …  ≡ (f(…)) ∨ …
            left = [first description];
            break;
        default:
            left = [NSString stringWithFormat:@"(%@)", [first description]];
            break;
    }
    
    switch(second.type) {
        case NyayaConstant:     // leaf                 : … ∨ T     ≡ … ∨ (T)
        case NyayaVariable:     // leaf                 : … ∨ a     ≡ … ∨ (a)
        case NyayaNegation:     // higher precedencd    : … ∨ ¬P    ≡ … ∨ (¬P)
        // case NyayaConjunction:  // higher precedence
        case NyayaFunction:     // prefix notation      : … ∨ f(…)  ≡ … ∨ (f(…))
        // case NyayaDisjunction:  // semantically equal   : a ∨ b ∨ c = a ∨ (b ∨ c)
            right = [second description];
            break;
        default:
            right = [NSString stringWithFormat:@"(%@)", [second description]];
            break;
    }
    
    
    _descriptionCache =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
    
    return _descriptionCache;
}

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

- (BOOL)isCnfFormula {
    return ([[self firstNode] isLiteral] || ([self firstNode].type == NyayaDisjunction && [[self firstNode] isCnfFormula]))  
    && ([[self secondNode] isLiteral] ||  ([self secondNode].type == NyayaDisjunction && [[self secondNode] isCnfFormula]));      
}

- (NyayaNode *)dnf {
    return [NyayaNode disjunction:[[self.nodes objectAtIndex:0] dnf] 
     with:[[self.nodes objectAtIndex:1] dnf]];
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

- (NyayaNodeType)type {
    return NyayaSequence;
}

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    _descriptionCache =   [NSString stringWithFormat:@"%@%@ %@", [first description], [self symbol], [second description]];
    return _descriptionCache;
}

@end

@implementation NyayaNodeConjunction

- (NyayaNodeType)type {
    return NyayaConjunction;
}

- (NyayaBool)displayValue { 
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaFalse || secondValue == NyayaFalse) _displayValue = NyayaFalse;
    else if (firstValue == NyayaTrue && secondValue == NyayaTrue) _displayValue = NyayaTrue;
    else _displayValue = NyayaUndefined;
    
    return _displayValue;
}

- (BOOL)evaluationValue {
    _evaluationValue = [[self firstNode] evaluationValue] & [[self secondNode] evaluationValue]; 
    return _evaluationValue;
}

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    NSString *left = nil;
    NSString *right = nil;
    
    
    switch(first.type) {
        case NyayaConstant:     // leaf                 : T ∧ …     ≡ (T) ∧ …
        case NyayaVariable:     // leaf                 : a ∧ …     ≡ (a) ∧ …
        case NyayaNegation:     // higher precedence    : ¬P ∧ …    ≡ (¬P) ∧ …
        case NyayaConjunction:  // left associative     : a ∧ b ∧ c ≡ (a ∨ b) ∧ c 
        case NyayaFunction:     // prefix notation      : f(…) ∧ …  ≡ (f(…)) ∧ … 
            left = [first description];
            break;
        default:
            left = [NSString stringWithFormat:@"(%@)", [first description]];
            break;
    }
    
    switch(second.type) {
        case NyayaConstant:     // leaf                 : … ∧ T     ≡ … ∧ (T)
        case NyayaVariable:     // leaf                 : … ∧ a     ≡ … ∧ (a)
        case NyayaNegation:     // higher precedencd    : … ∧ ¬P    ≡ … ∧ (¬P)
        case NyayaFunction:     // prefix notation      : … ∧ f(…)  ≡ … ∧ (f(…))
     // case NyayaConjunction:  // semantically equal   : a ∧ b ∧ c = a ∧ (b ∧ c)
            right = [second description];
            break;
        default:
            right = [NSString stringWithFormat:@"(%@)", [second description]];
            break;
    }
    
    _descriptionCache =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
    
    return _descriptionCache;
}

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

- (BOOL)isCnfFormula {
    return [[self firstNode] isCnfFormula] && [[self secondNode] isCnfFormula];    
}

- (NyayaNode*)dnf {
    // dnf (a & (b | c)) = (a & b) | (a & c)
    // dnf ((a | b) & c)) = (a & c) | (b & c)
    // dnf ((a | b) & (c | d)) = (a & c) | (a & d) | (b & c) | (b & d)
    return [self dnfDistribution:[[self firstNode] dnf] 
                                 with:[[self secondNode] dnf]];
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
- (NyayaNodeType)type {
    return NyayaXdisjunction;
}

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaUndefined || secondValue == NyayaUndefined) _displayValue = NyayaUndefined;
    else if (firstValue == secondValue) _displayValue = NyayaFalse;
    else _displayValue = NyayaTrue;
    
    return _displayValue;
}

- (BOOL)evaluationValue {
    _evaluationValue = [[self firstNode] evaluationValue] ^ [[self secondNode] evaluationValue];
    return _evaluationValue;
}

- (NSString*)description {
    
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    NSString *left = [first description];           // xor has lowest precedence and xor ist left associative
    NSString *right = nil;
    
    switch(second.type) {
        case NyayaXdisjunction:
            right = [NSString stringWithFormat:@"(%@)", [second description]];
            // a XOR (b XOR c)
            break;
        default:
            right = [second description];
            break;
    }
    _descriptionCache =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
    
    return _descriptionCache;
}

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

@implementation NyayaNodeImplication

- (NyayaNodeType)type {
    return NyayaImplication;
}

- (NyayaBool)displayValue {
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaFalse || secondValue == NyayaTrue) _displayValue = NyayaTrue;
    else if (firstValue == NyayaTrue && secondValue == NyayaFalse) _displayValue = NyayaFalse;
    else _displayValue = NyayaUndefined;
    
    return _displayValue;
}

- (BOOL)evaluationValue {
    _evaluationValue = ![[self firstNode] evaluationValue] | [[self secondNode] evaluationValue];
    return _evaluationValue;
}

- (NSString*)description {
    
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    NSString *left = nil;
    NSString *right = nil;
    
    switch(first.type) {
        case NyayaConstant:     // leaf                 : T → …     ≡ (T) → …
        case NyayaVariable:     // leaf                 : a → …     ≡ (a) → …
        case NyayaNegation:     // higher precedence    : ¬P → …    ≡ (¬P) → …
        case NyayaConjunction:  // higher precedence    : P ∧ Q → … ≡ (P ∧ Q) → …
        case NyayaDisjunction:  // higher precedence    : P ∨ Q → … ≡ (P ∨ Q) → …
        case NyayaXdisjunction: // higher precedence    : P ⊕ Q → … ≡ (P ⊕ Q) → …
        case NyayaFunction:     // prefix notation      : f(…) → …  ≡ (f(…)) → …
            left = [first description];
            break;
        default:
            left = [NSString stringWithFormat:@"(%@)", [first description]];
            break;
    }
    
    switch(second.type) {
        case NyayaConstant:     // leaf                 : … → T     ≡ … → (T)
        case NyayaVariable:     // leaf                 : … → a     ≡ … → (a)
        case NyayaNegation:     // higher precedence    : … → ¬P    ≡ … → (¬P)
        case NyayaConjunction:  // higher precedence    : … → P ∧ Q ≡ … → (P ∧ Q)
        case NyayaDisjunction:  // higher precedence    : … → P ∨ Q ≡ … → (P ∨ Q)
        case NyayaXdisjunction: // higher precedence    : … → P ⊕ Q ≡ … → (P ⊕ Q)
        case NyayaFunction:     // prefix notation      : f(…) → …  ≡ … → (f(…))
        case NyayaImplication:  // right associative    : a → b → c = a → (b → c)
            right = [second description];
            break;
        default:
            right = [NSString stringWithFormat:@"(%@)", [second description]];
            break;
    }
    _descriptionCache =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
    
    return _descriptionCache;
}

- (NyayaNode*)imf {
    // imf(P → Q) = ¬imf(P) ∨ imf(Q)
    NyayaNode *first = [[self firstNode] imf];
    NyayaNode *second = [[self secondNode] imf];
    return [NyayaNode disjunction: [NyayaNode negation:first] with: second];
}

@end

@implementation NyayaNodeEntailment

- (NyayaNodeType)type {
    return NyayaEntailment;
}

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    _descriptionCache =   [NSString stringWithFormat:@"%@ %@ %@", [first description], [self symbol], [second description]];
    return _descriptionCache;
}

@end

@implementation NyayaNodeBicondition

- (NyayaNodeType)type {
    return NyayaBicondition;
}

- (NyayaBool)displayValue { 
    NyayaBool firstValue = [self firstValue];
    NyayaBool secondValue = [self secondValue];
    
    if (firstValue == NyayaUndefined || secondValue == NyayaUndefined) _displayValue = NyayaUndefined;
    else if (firstValue == secondValue) _displayValue = NyayaTrue;
    else _displayValue = NyayaFalse;
    
    return _displayValue;
}

- (BOOL)evaluationValue {
    _evaluationValue = (![[self firstNode] evaluationValue] | [[self secondNode] evaluationValue])
    & (![[self secondNode] evaluationValue] | [[self firstNode] evaluationValue]); 
    return _evaluationValue;
}

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    NSString *left = nil;
    NSString *right = nil;
    
    
    switch(first.type) {
        case NyayaConstant:     // leaf                 : T ↔ …     ≡ (T) ↔ …
        case NyayaVariable:     // leaf                 : a → …     ≡ (a) ↔ …
        case NyayaNegation:     // higher precedence    : ¬P → …    ≡ (¬P) ↔ …
        case NyayaConjunction:  // higher precedence    : P ∧ Q ↔ … ≡ (P ∧ Q) ↔ …
        case NyayaDisjunction:  // higher precedence    : P ∨ Q ↔ … ≡ (P ∨ Q) ↔ …
        case NyayaXdisjunction: // higher precedence    : P ⊕ Q ↔ … ≡ (P ↔ Q) → …
        case NyayaFunction:     // prefix notation      : f(…) ↔ …  ≡ (f(…)) ↔ …
            left = [first description];
            break;
        default:
            left = [NSString stringWithFormat:@"(%@)", [first description]];
            break;
    }
    
    switch(second.type) {
        case NyayaConstant:     // leaf                 : … ↔ T     ≡ … ↔ (T)
        case NyayaVariable:     // leaf                 : … ↔ a     ≡ … ↔ (a)
        case NyayaNegation:     // higher precedence    : … ↔ ¬P    ≡ … ↔ (¬P)
        case NyayaConjunction:  // higher precedence    : … ↔ P ∧ Q ≡ … ↔ (P ∧ Q)
        case NyayaDisjunction:  // higher precedence    : … ↔ P ∨ Q ≡ … ↔ (P ∨ Q)
        case NyayaXdisjunction: // higher precedence    : … ↔ P ⊕ Q ≡ … ↔ (P ⊕ Q)
        case NyayaFunction:     // prefix notation      : … ↔ f(…)  ≡ … ↔ … ↔ (f(…))
        case NyayaBicondition:  // right associative    : a ↔ b ↔ c = a ↔ (b → c)
            right = [second description];
            break;
        default:
            right = [NSString stringWithFormat:@"(%@)", [second description]];
            break;
    }
    _descriptionCache =  [NSString stringWithFormat:@"%@ %@ %@", left, self.symbol, right];
    
    return _descriptionCache;
}

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

@implementation NyayaNodeFunction

- (NyayaNodeType)type {
    return NyayaFunction;
}

- (NSUInteger) arity {
    return [self.nodes count];
}

- (NSString*)description {
    NSString *right = [[self.nodes valueForKey:@"description"] componentsJoinedByString:@","];
    _descriptionCache = [NSString stringWithFormat:@"%@(%@)", self.symbol, right]; 
    return _descriptionCache;
}

@end

#pragma mark - abstract root node implementation
@implementation NyayaNode

- (id)copyWithZone:(NSZone*)zone {
    
    return [self copyWith:[self valueForKeyPath:@"nodes.copy"]]; // recursive copy
}

- (NyayaNodeType)type {
    return NyayaUndefined;
}

- (NyayaNode*)nodeAtIndex:(NSUInteger)index {
    return [_nodes count] > index ? [_nodes objectAtIndex:index] : nil;
}

#pragma mark node factory
+ (NyayaNode*)atom:(NSString*)name {
    NyayaNode *node = nil;
    if ([name isTrueToken]) {
        node = [[NyayaNodeConstant alloc] init];
        node->_symbol = [[NSArray trueTokens] objectAtIndex:0];
    }
    else if ([name isFalseToken]) {
        node = [[NyayaNodeConstant alloc] init];
        node->_symbol = [[NSArray falseTokens] objectAtIndex:0];
    }
    else { // variable name
        node = [[NyayaNodeVariable alloc] init];
        [[NyayaStore sharedInstance] setDisplayValue:NyayaUndefined forName:name];
        node->_symbol = name;
    };
    
    
    return node;
}

+ (NyayaNode*)negation:(NyayaNode *)firstNode {
    NyayaNode*node=[[NyayaNodeNegation alloc] init];
    node->_symbol = @"¬";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)conjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeConjunction alloc] init];
    node->_symbol = @"∧";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];

    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)sequence:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeSequence alloc] init];
    node->_symbol = @";";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)disjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeDisjunction alloc] init];
    node->_symbol = @"∨";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)implication:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeImplication alloc] init];
    node->_symbol = @"→";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)entailment:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeEntailment alloc] init];
    node->_symbol = @"⊨";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)bicondition:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeBicondition alloc] init];
    node->_symbol = @"↔";
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

+ (NyayaNode*)xdisjunction:(NyayaNode *)firstNode with:(NyayaNode *)secondNode {
    NyayaNode*node=[[NyayaNodeXdisjunction alloc] init];
    node->_symbol = @"⊻"; // @"⊕"; 
    node->_displayValue = NyayaUndefined;
    node->_nodes = [NSArray arrayWithObjects:firstNode,secondNode, nil];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
    
}

+ (NyayaNode*)function:(NSString *)name with:(NSArray *)nodes {
    NyayaNode*node=[[NyayaNodeFunction alloc] init];
    // node->isa = [NyayaNodeFunction class];
    node->_symbol = name;
    node->_nodes = [nodes copy];
    
    [node setValue:node forKeyPath:@"nodes.parent"];
    return node;
}

- (NSUInteger)arity {
    return 0;   // default (constants and variables)
}

#pragma mark default method implementations

- (NyayaBool)displayValue {
    _displayValue = [[NyayaStore sharedInstance] displayValueForName:self.symbol];
    return _displayValue;
}

- (BOOL)evaluationValue {
    _evaluationValue = [[NyayaStore sharedInstance] evaluationValueForName:self.symbol];
    return _evaluationValue;
}

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

- (NSString*)description {
    _descriptionCache = _symbol;
    return _descriptionCache;
}

#pragma mark - normal forms

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
