//
//  NyayaNode+Resolution.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Resolution)

- (NSArray*)conjunctionOfDisjunctions; // cnf is conjunction (AND) of disjunctions (OR) of literals: (a or b) AND (a or !b)
- (NSArray*)disjunctionOfConjunctions; // dnf is disjunction (OR) of conjunctions (AND) of literals: (a and b) OR (a and !b)


@end
