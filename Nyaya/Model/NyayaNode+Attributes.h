//
//  NyayaNode+Attributes.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Attributes)

- (NSUInteger)arity;

- (BOOL)isImplicationFree;          // (sub)formula is implication free
- (BOOL)isNegationNormalForm;       // (sub)formula is in negation normal form
- (BOOL)isConjunctiveNormalForm;    // (sub)formula is in conjunctive normal form
- (BOOL)isDisjunctiveNormalForm;    // (sub)formula is in disjunctive normal form


- (BOOL)isLiteral;

- (BOOL)isImfTransformationNode;
- (BOOL)isNnfTransformationNode;
- (BOOL)isCnfTransformationNode;
- (BOOL)isDnfTransformationNode;

@end
