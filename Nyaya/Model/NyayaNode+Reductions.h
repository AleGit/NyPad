//
//  NyayaNode+Reductions.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NSArray (Reductions)
- (NSMutableArray*)reducedNodes;
- (NSMutableArray*)negatedNodes;
- (BOOL)containsComplementaryNodes;
- (BOOL)containsTop;
- (BOOL)containsBottom;
@end

@interface NyayaNode (Reductions)

- (NyayaNode*)reduce:(NSInteger)maxSize;
- (NSMutableArray*)naryDisjunction;
- (NSMutableArray*)naryConjunction;

@end
