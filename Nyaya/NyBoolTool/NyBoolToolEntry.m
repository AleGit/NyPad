//
//  NyBoolToolEntry.m
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyBoolToolEntry.h"

@implementation NyBoolToolEntry

- (id)initWithTitle:(NSString *)title input:(NSString *)input {
    self = [super init];
    if (self) {
        _title = title;
        _input = input;
    }
    return self;
}

+ (id)entryWithTitle:(NSString *)title input:(NSString *)input {
    return [[NyBoolToolEntry alloc] initWithTitle:title input:input];
    
}

@end
