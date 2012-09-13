//
//  NyayaNode+Reductions.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NSArray (Reductions)
- (NSMutableArray*)reducedNodes:(BOOL)unique originals:(NSMutableSet*)set;
- (NSMutableArray*)negatedNodes:(BOOL)unique originals:(NSMutableSet*)set;
- (BOOL)containsComplementaryNodes;
- (BOOL)containsTop;
- (BOOL)containsBottom;
@end

@interface NSMutableArray (Reductions)

- (void)xorConsolidateOriginals: (NSMutableSet*)set;
- (void)bicConsolidateOriginals: (NSMutableSet*)set;

@end

@interface NSMutableSet (Reductions)

- (id)addObjectAndGetOriginal:(id)obj;
@end

@interface NyayaNode (Reductions)

- (NyayaNode*)reduce:(NSInteger)maxSize originals:(NSMutableSet*)set;
- (NSMutableArray*)naryDisjunction;
- (NSMutableArray*)naryConjunction;
- (NSMutableArray*)naryXdisjunction;
- (NSMutableArray*)naryBiconditional;

@end
