//
//  UIView+Nyaya.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSObject+Nyaya.h"

@implementation NSObject (NyayaCopy)

- (id)trueDeepCopy {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
}

@end
