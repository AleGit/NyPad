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

@interface NSArray (Random)

- (id)randomObject;

@end

@implementation NSArray (Random)

- (id)randomObject {
    NSUInteger xth = arc4random() % [self count];
    return [self objectAtIndex:xth];
}
@end

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

+ (NyayaNode*)randomNode {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:NyayaNegation];
    [indexSet addIndex:NyayaConjunction];
    [indexSet addIndex:NyayaDisjunction];
    [indexSet addIndex:NyayaImplication];
    return [NyayaNode randomNodeWithRootTypes:indexSet
                                    nodeTypes:indexSet
                                      lengths:NSMakeRange(5,5)
                                    variables:@[@"p",@"q",@"r"]];
}

+ (NyayaNode *)randomNodeWithRootTypes:(NSIndexSet *)rootTypes
                             nodeTypes:(NSIndexSet *)nodeTypes
                               lengths:(NSRange)lengths
                             variables:(NSArray *)variables {
    if (!nodeTypes) nodeTypes = rootTypes;
    
    NyayaNode* result = nil;
    NyayaNode* first = nil;
    NyayaNode* second = nil;
    NSUInteger minLength = lengths.location;
    NSUInteger maxLength = minLength + lengths.length;
    
    // NyayaNodeType rootType = (NyayaNodeType)[rootTypes randomIndex];
    
    NSMutableArray *subTrees = [NSMutableArray arrayWithCapacity:maxLength];
    
    for (NSString *var in variables) {
        [subTrees addObject:[NyayaNode atom:var]];
    }
    
    NyayaNodeType rootType = [rootTypes randomIndex];
    NyayaNodeType type = rootType;
    
    do  {
        do {
            first = [subTrees randomObject];
            second = type != NyayaNegation ? [subTrees randomObject] : nil;
        }
        while (maxLength <= ([first length] + [second length]));
        
        switch (type) {
            case NyayaNegation:
                result = [NyayaNode negation:first];
                break;
            case NyayaDisjunction:
                result = [NyayaNode conjunction:first with:second];
                break;
            case NyayaConjunction:
                result = [NyayaNode conjunction:first with:second];
                break;
            case NyayaImplication:
                result = [NyayaNode conjunction:first with:second];
                break;
            default:
                continue;
        }
        
        [subTrees addObject:result];
        type = [nodeTypes randomIndex];
    }
    while ([result length] < minLength);
    
    
    
    
    
    
    return result;
    
}

@end
