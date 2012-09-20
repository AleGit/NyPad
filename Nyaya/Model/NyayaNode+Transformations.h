//
//  NyayaNode+Transformations.h
//  Nyaya
//
//  Created by Alexander Maringele on 19.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Transformations)

- (NyayaNode*)nodeByReplacingNodeAtIndexPath:(NSIndexPath*)indexPath withNode:(NyayaNode*)node;

// - (NyayaNode*)nodeAtIndexPath:(NSIndexPath*)indexPath;

- (NSString*)switchKey;
- (NyayaNode*)switchedNode;

- (NSString*)collapseKey;
- (NyayaNode*)collapsedNode;

- (NSString*)imfKey;
- (NyayaNode*)imfNode;

- (NSString*)nnfKey;
- (NyayaNode*)nnfNode;

- (NSString*)cnfLeftKey;
- (NSString*)cnfRightKey;
- (NSString*)dnfLeftKey;
- (NSString*)dnfRightKey;

- (NyayaNode*)distributedNodeToIndex:(NSUInteger)idx;

@end
