//
//  DemoNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DemoNode.h"

@implementation DemoNode

@synthesize nodes = _nodes;

- (id)init {
    self = [super init];
    if (self) {
        _nodes = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)value {
    NSUInteger value = 0;
    for (DemoNode *node in _nodes) {
        value += node.value;
    }
    return value;
}


@end
