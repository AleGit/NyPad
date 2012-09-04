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

- (BOOL)isImfFormula;   // (sub)formula is implication free
- (BOOL)isNnfFormula;   // (sub)formula is in negation normal form
- (BOOL)isCnfFormula;   // (sub)formula is in conjunctive normal form
- (BOOL)isDnfFormula;   // (sub)formula is in disjunctive normal form

- (BOOL)isLiteral;

- (BOOL)isImfTransformationNode;
- (BOOL)isNnfTransformationNode;
- (BOOL)isCnfTransformationNode;
- (BOOL)isDnfTransformationNode;

@end
