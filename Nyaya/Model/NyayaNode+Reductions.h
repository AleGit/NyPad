//
//  NyayaNode+Reductions.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NSSet (Reductions)
- (BOOL)containsComplementaryNodes;
- (BOOL)containsTop;
- (BOOL)containsBottom;
@end

@interface NyayaNode (Reductions)

- (NyayaNode*)reduce:(NSInteger)maxSize;
- (NSMutableSet*)naryDisjunction:(NSInteger)maxSize;
- (NSMutableSet*)naryConjunction:(NSInteger)maxSize;

@end
