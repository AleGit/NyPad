//
//  DemoLeaf.h
//  Nyaya
//
//  Created by Alexander Maringele on 20.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "DemoNode.h"

@interface DemoLeaf : DemoNode

@property (nonatomic, assign) NSUInteger value;

+ (DemoLeaf*)leafWithValue:(NSUInteger)value;

@end
