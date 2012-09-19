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

@end
