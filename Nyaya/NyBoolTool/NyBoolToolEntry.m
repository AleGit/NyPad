//
//  NyBoolToolEntry.m
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyBoolToolEntry.h"

@implementation NyBoolToolEntry

- (id)initWithDate:(NSDate *)date input:(NSString *)input {
    self = [super init];
    if (self) {
        _date = date;
        _input = input;
    }
    return self;
}

+ (id)entryWithDate:(NSDate *)date input:(NSString *)input {
    return [[NyBoolToolEntry alloc] initWithDate:date input:input];
    
}

@end
