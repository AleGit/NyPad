//
//  NyayaNode+Description.m
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Description.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Type.h"

@implementation NyayaNode (Description)

- (NSString*)description {
    _descriptionCache = _symbol;
    return _descriptionCache;
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

@end

@implementation NyayaNodeNegation (Description)

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

@end

@implementation NyayaNodeDisjunction (Description)

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
@end

@implementation NyayaNodeSequence (Description)

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    _descriptionCache =   [NSString stringWithFormat:@"%@%@ %@", [first description], [self symbol], [second description]];
    return _descriptionCache;
}

@end

@implementation NyayaNodeConjunction (Description)

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

@end

@implementation NyayaNodeXdisjunction (Description)

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

@end

@implementation NyayaNodeImplication (Description)

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

@end

@implementation NyayaNodeEntailment (Description)

- (NSString*)description {
    NyayaNode *first = [self firstNode];
    NyayaNode *second = [self secondNode];
    _descriptionCache =   [NSString stringWithFormat:@"%@ %@ %@", [first description], [self symbol], [second description]];
    return _descriptionCache;
}

@end

@implementation NyayaNodeBicondition (Description)

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

@end

@implementation NyayaNodeFunction (Description)

- (NSString*)description {
    NSString *right = [[self.nodes valueForKey:@"description"] componentsJoinedByString:@","];
    _descriptionCache = [NSString stringWithFormat:@"%@(%@)", self.symbol, right];
    return _descriptionCache;
}

@end

//@implementation NyayaNodeDisjunction (Description)

// @end