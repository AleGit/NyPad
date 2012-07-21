//
//  SimpleFactory.m
//  Nyaya
//
//  Created by Alexander Maringele on 21.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "SimpleFactory.h"

@implementation SimpleFactory

@synthesize name = _name;

+ (id)factoryWithName:(NSString *)name {
    id factory = [[self alloc] initWithName:name];
    return factory;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) _name = name;
    return self;
}
- (NSString*)greeting {
    return [NSString stringWithFormat:@"Hello, I'm Simple %@", _name];
}

@end

@implementation StarFactory

@synthesize name = _name;

+ (id)factoryWithName:(NSString *)name {
    id factory = [[self alloc] initWithName:name];
    return factory;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) _name = name;
    return self;
}
- (NSString*)greeting {
    return [NSString stringWithFormat:@"Hello, I'm Star %@", _name];
}

@end

