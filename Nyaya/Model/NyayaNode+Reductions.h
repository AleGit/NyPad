//
//  NyayaNode+Reductions.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NSArray (Reductions)
- (NSMutableArray*)reducedNodes:(BOOL)unique;
- (NSMutableArray*)negatedNodes:(BOOL)unique;
- (NSMutableArray*)substitute:(NSMutableSet*)substitutes;
- (BOOL)containsComplementaryNodes;
- (BOOL)containsTop;
- (BOOL)containsBottom;
@end

@interface NSMutableArray (Reductions)

- (void)xorConsolidate;
- (void)bicConsolidate;

@end

@interface NSMutableSet (Reductions)

- (id)objectSubstitute:(id)obj;
- (id)objectIsEqual:(id)obj;
@end

@interface NyayaNode (Reductions)

- (NyayaNode*)reduce:(NSInteger)maxSize;
- (NyayaNode*)substitute:(NSMutableSet*)substitutes;
- (NSMutableArray*)naryDisjunction;
- (NSMutableArray*)naryConjunction;
- (NSMutableArray*)naryXdisjunction;
- (NSMutableArray*)naryBiconditional;

@end
