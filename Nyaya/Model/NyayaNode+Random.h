//
//  NyayaNode+Random.h
//  Nyaya
//
//  Created by Alexander Maringele on 27.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Random)

+ (NyayaNode*)randomNodeWithRootTypes:(NSIndexSet*)rootTypes        // possible root node type(s)
                            nodeTypes:(NSIndexSet*)nodeTypes        // possible sub node type(s),
                              lengths:(NSRange)lengths              // number of nodes and leafs
                            variables:(NSArray*)variables;          // ["p","q","r"]

@end
