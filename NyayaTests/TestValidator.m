//
//  NyayaTestsValidator.m
//  Nyaya
//
//  Created by Alexander Maringele on 02.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TestValidator.h"

@implementation TestValidator

- (id)initWithInput:(NSString*)input {
    self = [super init];
    if (self) {
        _input = input;
    }
    return self;
}

+ (id)validatorWithInput:(NSString*)input {
    return [[super alloc] initWithInput:input];
}

- (BOOL)validate {
    
    return YES;
}

@end
