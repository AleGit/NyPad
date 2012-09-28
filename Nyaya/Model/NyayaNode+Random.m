//
//  NyayaNode+Random.m
//  Nyaya
//
//  Created by Alexander Maringele on 27.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode+Random.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Type.h"

@interface NSIndexSet (Random)

- (NSUInteger)randomIndex;

@end


@implementation NSIndexSet (Random)

- (NSUInteger)randomIndex {
    NSUInteger xth = arc4random() % [self count];
    __block NSUInteger ith = 0;
    __block NSUInteger result = NSNotFound;
    
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (ith == xth) {
            result = idx;
            *stop = YES;
        }
        ith++;
    }];
    
    return result;
}

@end

@implementation NyayaNode (Random)


+ (NyayaNode *)randomNodeWithRootTypes:(NSIndexSet *)rootTypes
                             nodeTypes:(NSIndexSet *)nodeTypes
                               lengths:(NSRange)lengths
                             variables:(NSArray *)variables {
    NyayaNode* result = nil;
    NSUInteger maxLength = lengths.location + lengths.length;
    
    NyayaNodeType rootType = (NyayaNodeType)[rootTypes randomIndex];
    
    NSMutableSet *atomSet = [NSMutableSet setWithCapacity:[variables count]];
    
    for (NSString *var in variables) {
        [atomSet addObject:[NyayaNode atom:var]];
    }
    
    NSArray *atoms = [atomSet allObjects];
    
    maxLength = maxLength - 1 - [atoms count]; // root leaves
    
    
    
    
    return result;
    
}

@end
