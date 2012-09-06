//
//  NyayaNode+Derivations.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Derivations)

- (NyayaNode*)copyWith:(NSArray*)nodes;
- (NyayaNode*)copyImf;
- (NyayaNode*)copyNnf;

- (NyayaNode*)std;      // substitute sequence and entailment with conjunction and implication
- (NyayaNode*)imf;      // equivalent formula without implications or biconditions
- (NyayaNode*)nnf;      // equivalent formula in negation normal form (includes imf)
- (NyayaNode*)cnf;      // equivalent formula in conjunctive normal form (includes nnf, imf)
- (NyayaNode*)dnf;      // equivalent formula in disjunctive normal form (includes nnf, imf)

/* ********************* */
/* ********************* */

- (NSSet*)subNodeSet;
// - (NyayaNode*)compressWith;

@end
