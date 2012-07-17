//
//  NyayaNode.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "OldNyayaNode.h"

@implementation OldNyayaNode

@synthesize token = _token;
@synthesize nodes = _nodes;

- (id)initWithToken:(NSString *)token {
    self = [super init];
    if (self) {
        _token = token;
        _nodes = [NSMutableArray array];
    }
    return self;
}

@end
