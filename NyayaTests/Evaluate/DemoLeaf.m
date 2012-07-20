//
//  DemoLeaf.m
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DemoLeaf.h"

@implementation DemoLeaf

@synthesize value = _value;

+ (DemoLeaf*)leafWithValue:(NSUInteger)value {
    DemoLeaf *leaf = [[DemoLeaf alloc] init];
    leaf.value = value;
    return leaf;
}

- (NSMutableArray *)nodes {
    return nil;
}

@end
