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

- (id)randomObject:(NSUInteger)maxLength;

@end

@implementation NSArray (Random)

- (id)randomObject:(NSUInteger)maxLength {
    if (maxLength == 0) maxLength = 1;
    
    NyayaNode *node = nil;
    
    do {
        NSUInteger xth = arc4random() % [self count];
        node = [self objectAtIndex:xth];
    }
    while (maxLength < [node length]);
    
    return node;
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

+ (NyayaNode*)randomTree {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:NyayaNegation];
    [indexSet addIndex:NyayaConjunction];
    [indexSet addIndex:NyayaDisjunction];
    [indexSet addIndex:NyayaImplication];
    return [NyayaNode randomTreeWithRootTypes:indexSet
                                    nodeTypes:indexSet
                                      lengths:NSMakeRange(1,11)
                                    variables:@[@"p",@"q",@"r"]];
}

+ (NyayaNode *)randomTreeWithRootTypes:(NSIndexSet *)rootTypes
                             nodeTypes:(NSIndexSet *)nodeTypes
                               lengths:(NSRange)lengths
                             variables:(NSArray *)variables {
    if (!nodeTypes) nodeTypes = rootTypes;
    
    NyayaNode* result = nil;
    NyayaNode* first = nil;
    NyayaNode* second = nil;
    
    NSUInteger minLength = lengths.location;
    NSUInteger maxLength = lengths.location + lengths.length;
    if (minLength < maxLength)
        minLength += arc4random() % lengths.length;
    
    // NyayaNodeType rootType = (NyayaNodeType)[rootTypes randomIndex];
    
    NSMutableArray *subTrees = [NSMutableArray arrayWithCapacity:maxLength];
    
    for (NSString *var in variables) {
        [subTrees addObject:[NyayaNode atom:var]];
    }
    
    NyayaNodeType rootType = [rootTypes randomIndex];
    
    NyayaNodeType type = rootType;
    
    if (maxLength < 2) return [subTrees randomObject:1];
        
    do  {
        NSUInteger count = 0;
        do {
            first = [subTrees randomObject: maxLength -1 - (type != NyayaNegation)];
            second = type != NyayaNegation ? [subTrees randomObject: maxLength - 1 - [first length]] : nil;
        }
        while ([second isEqual: first] && ++count < [subTrees count]*3);
        
        switch (type) {
            case NyayaNegation:
                result = [NyayaNode negation:first];
                break;
            case NyayaDisjunction:
                result = [NyayaNode conjunction:first with:second];
                break;
            case NyayaConjunction:
                result = [NyayaNode disjunction:first with:second];
                break;
            case NyayaImplication:
                result = [NyayaNode implication:first with:second];
                break;
            case NyayaConstant:
                if ([subTrees count] % 2) result = [NyayaNode atom:@"T"];
                else result = [NyayaNode atom:@"F"];
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
