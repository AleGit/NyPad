//
//  NSArray+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 07.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSArray+NyayaToken.h"

@implementation NSArray (NyayaToken)

+ (NSArray*)localizedTokens: (NSArray*)defaultTokens {
    NSString *key = [defaultTokens objectAtIndex:0];
    NSArray *localizedTokens = [NSLocalizedString(key, key) componentsSeparatedByString:@","];
    
    NSIndexSet *indexSet = [localizedTokens indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [defaultTokens indexOfObject:obj] == NSNotFound;
    }];
    
    return [defaultTokens arrayByAddingObjectsFromArray:[localizedTokens objectsAtIndexes:indexSet]];
    
}

+ (NSArray*)trueTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"T",@"⊤",@"1"]]; });
    return _tokens;
}

+ (NSArray*)falseTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"F",@"⊥",@"0"]]; });
    return _tokens;
}

+ (NSArray*)notTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"!",@"¬"]]; });
    return _tokens;
}

+ (NSArray*)andTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"&",@"∧",@"."]]; });
    return _tokens;
}

+ (NSArray*)orTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"|",@"∨",@"+"]]; });
    return _tokens;
}

+ (NSArray*)bicTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"=",@"↔",@"<>"]]; });
    return _tokens;
}

+ (NSArray*)impTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@">",@"→"]]; });
    return _tokens;
}

+ (NSArray*)xorTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"^",@"⊻",@"⊕"]]; });
    return _tokens;
}

+ (NSArray*)lparTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"("]]; });
    return _tokens;
}

+ (NSArray*)rparTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@")"]]; });
    return _tokens;
}

+ (NSArray*)commaTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@","]]; });
    return _tokens;
}

+ (NSArray*)semicolonTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@";"]]; });
    return _tokens;
}

+ (NSArray*)entailmentTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSArray localizedTokens:@[@"⊨"]]; });
    return _tokens;
}

@end
