//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

enum { NyayaUndefined=0, NyayaFalse, NyayaTrue };
typedef NSUInteger NyayaBool;

enum { // NyayaUndefined=0
    NyayaConstant=1, NyayaVariable,
    NyayaNegation, NyayaConjunction, NyayaDisjunction, 
    NyayaImplication, NyayaBicondition, NyayaFunction 
};
typedef NSUInteger NyayaNodeType;


@interface NyayaNode : NSObject

@property (nonatomic, readonly) NyayaNodeType type; 
@property (nonatomic, readonly) NSString *symbol;       // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, readonly) NyayaBool value;
@property (nonatomic, assign) BOOL evaluation;

+ (NyayaNode*)atom:(NSString*)name;

+ (NyayaNode*)negation:(NyayaNode*)firstNode;
+ (NyayaNode*)conjunction:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)disjunction:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)implication:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)bicondition:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;

+ (NyayaNode*)function:(NSString*)name with:(NSArray*)nodes;

- (NyayaNode*)imf;
- (NyayaNode*)nnf;
- (NyayaNode*)cnf;
- (NyayaNode*)dnf;

- (NSString*)treeDescription;

- (NSArray*)conjunctionOfDisjunctions; // cnf is conjunction (AND) of disjunctions (OR) of literals: (a or b) AND (a or !b)
- (NSArray*)disjunctionOfConjunctions; // dnf is disjunction (OR) of conjunctions (AND) of literals: (a and b) OR (a and !b)

- (NSSet*)subformulas;
- (NSArray*)sortedSubformulas;

- (NSSet*)variables;

@end
