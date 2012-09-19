//
//  NyayaNode+Transformations.m
//  Nyaya
//
//  Created by Alexander Maringele on 19.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Transformations.h"
#import "NyayaNode+Derivations.h"

@implementation NyayaNode (Transformations)

/*     []      !a & (b+c)
        &
      /   \
  [0]     [1]
    !       +
    |      / \
 [0.0] [1.0]  [1.1]
    a    b      c
*/
- (NyayaNode*)nodeByReplacingNodeAtIndexPath:(NSIndexPath*)indexPath withNode:(NyayaNode*)node {
    if ([indexPath length] == 0) {
        return node;
    }
    else {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.nodes count]];
        NSIndexPath *subpath = [NSIndexPath indexPathWithIndexes:nil length:0];
        for (NSUInteger idx = 1; idx < [indexPath length]; idx++) {
            NSLog(@"%@ %@", indexPath, subpath);
            subpath  = [subpath indexPathByAddingIndex:[indexPath indexAtPosition:idx]];
        }
        
        [self.nodes enumerateObjectsUsingBlock:^(NyayaNode *obj, NSUInteger idx, BOOL *stop) {
            NyayaNode *subnode = nil;
            if ([indexPath indexAtPosition:0] == idx) {
                subnode = [obj nodeByReplacingNodeAtIndexPath:subpath withNode:node];
            }
            else {
                subnode = obj;
            }
            [array addObject:subnode];
            
        }];
        return [self copyWith:array];
    }
}

@end
