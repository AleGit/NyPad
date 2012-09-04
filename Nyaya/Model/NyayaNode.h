//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - enums

enum { NyayaUndefined=0, NyayaFalse, NyayaTrue };
typedef NSUInteger NyayaBool;

enum { // NyayaUndefined=0
    NyayaConstant=1, NyayaVariable,
    NyayaNegation,
    NyayaConjunction, NyayaDisjunction, NyayaXdisjunction, NyayaImplication, NyayaBicondition,
    NyayaFunction
    , NyayaSequence     // a conjunction with lower precedence than everything but eintailment
    , NyayaEntailment   // an implication with lowest precedence
};
typedef NSUInteger NyayaNodeType;


@interface NyayaNode : NSObject <NSCopying> {
@protected
    NSString *_descriptionCache;
    NSString *_symbol;
    NyayaBool _displayValue;
    BOOL _evaluationValue;
    NSArray *_nodes;
}

@property (nonatomic, readonly) NyayaNodeType type; 
@property (nonatomic, readonly) NSString *symbol;       // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, readonly) NyayaBool displayValue;   // user evaluations (default=undefined)
@property (nonatomic, readonly) BOOL evaluationValue;     // truth table evaluations

@property (nonatomic, weak) NyayaNode *parent;

// @property (nonatomic, readonly) NSString* de;

#pragma mark - node factory

- (NSUInteger)arity;

#pragma mark - normal forms
- (NyayaNode*)std;      // substitute ;⊨


- (NyayaNode*)imf;      // equivalent formula without implications or biconditions
- (NyayaNode*)nnf;      // equivalent formula in negation normal form (includes imf)
- (NyayaNode*)cnf;      // equivalent formula in conjunctive normal form (includes nnf, imf)
- (NyayaNode*)dnf;      // equivalent formula in disjunctive normal form (includes nnf, imf)

- (BOOL)isImfFormula;   // (sub)formula is implication free
- (BOOL)isNnfFormula;   // (sub)formula is in negation normal form
- (BOOL)isCnfFormula;   // (sub)formula is in conjunctive normal form
- (BOOL)isDnfFormula;   // (sub)formula is in disjunctive normal form

- (BOOL)isLiteral;

- (BOOL)isImfTransformationNode;
- (BOOL)isNnfTransformationNode;
- (BOOL)isCnfTransformationNode;
- (BOOL)isDnfTransformationNode;

#pragma mark - transformations

- (void)replaceNode:(NyayaNode*)n1 withNode:(NyayaNode*)n2;

#pragma mark - output

- (NSString*)treeDescription;

- (NSArray*)conjunctionOfDisjunctions; // cnf is conjunction (AND) of disjunctions (OR) of literals: (a or b) AND (a or !b)
- (NSArray*)disjunctionOfConjunctions; // dnf is disjunction (OR) of conjunctions (AND) of literals: (a and b) OR (a and !b)

- (NSSet*)setOfSubformulas;     // set of subformulas (strings)
- (NSSet*)setOfVariables;       // set of variables (nodes)

- (void)fillHeadersAndEvals:(NSMutableDictionary*)headersAndEvals;

@end

#pragma mark -
@interface NyayaNodeVariable : NyayaNode

- (void)setDisplayValue:(NyayaBool)displayValue;
- (void)setEvaluationValue:(BOOL)evaluationValue;

@end

