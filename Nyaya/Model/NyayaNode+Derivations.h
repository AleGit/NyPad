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
- (NyayaNode*)copyImf:(NSInteger)maxSize;
- (NyayaNode*)copyNnf:(NSInteger)maxSize;

- (NyayaNode*)std;      // substitute sequence and entailment with conjunction and implication
- (NyayaNode*)deriveImf:(NSInteger)maxSize;      // equivalent formula without implications or biconditions
- (NyayaNode*)deriveNnf:(NSInteger)maxSize;      // equivalent formula in negation normal form (includes imf)
- (NyayaNode*)deriveCnf:(NSInteger)maxSize;      // equivalent formula in conjunctive normal form (includes nnf, imf)
- (NyayaNode*)deriveDnf:(NSInteger)maxSize;      // equivalent formula in disjunctive normal form (includes nnf, imf)

/* ********************* */
/* ********************* */

- (NSSet*)subNodeSet;
// - (NyayaNode*)compressWith;

@end
