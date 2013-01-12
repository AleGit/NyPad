//
//  NSSet+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSSet+NyayaToken.h"

@implementation NSSet (NyayaToken)

+ (NSMutableSet*)localizedTokens: (NSArray*)defaultTokens {
    NSMutableSet *set = [NSMutableSet setWithArray:defaultTokens];
    
    NSString *key = [defaultTokens objectAtIndex:0];
    NSArray *localizedTokens = [NSLocalizedString(key, key) componentsSeparatedByString:@","];
    
    [set addObjectsFromArray:localizedTokens];
    [set removeEmptyTokens];
    return set;
}

+ (NSArray*)defaultTrueTokens  { return @[@"T",@"⊤",@"1",@"\\top"]; }
+ (NSArray*)defaultFalseTokens { return @[@"F",@"⊥",@"0",@"\\bot"]; }
+ (NSArray*)defaultNotTokens   { return @[@"!",@"¬",@"\\neg"]; }
+ (NSArray*)defaultAndTokens   { return @[@"&",@"∧",@".",@"•",@"\\wedge"]; }
+ (NSArray*)defaultOrTokens   { return @[@"|",@"∨",@"+",@"\\vee"]; }
+ (NSArray*)defaultBicTokens   { return @[@"=",@"↔",@"<>",@"≡",@"≣",@"\\leftrightarrow"]; }
+ (NSArray*)defaultImpTokens   { return @[@">",@"→",@"\\rightarrow"]; }
+ (NSArray*)defaultXorTokens   { return @[@"^",@"⊻",@"⊕",@"\\oplus"]; }
+ (NSArray*)defaultLparTokens  { return @[@"("]; }
+ (NSArray*)defaultRparTokens  { return @[@")"]; }
+ (NSArray*)defaultCommaTokens { return @[@","]; }
+ (NSArray*)defaultSemicolonTokens  { return @[@";"]; }
+ (NSArray*)defaultEntailmentTokens { return @[@"⊨"]; }

+ (NSMutableSet*)allTokens {
    static dispatch_once_t pred = 0;
    __strong static NSMutableSet* _tokens = nil;
    dispatch_once(&pred, ^{ _tokens = [NSMutableSet setWithObject:@" "]; });
    return _tokens;
}

+ (NSSet*)trueTokens {
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultTrueTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}

+ (NSSet*)falseTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultFalseTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)notTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultNotTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)andTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultAndTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)orTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultOrTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)bicTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultBicTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)impTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultImpTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)xorTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultXorTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)lparTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultLparTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)rparTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultRparTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)commaTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultCommaTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)semicolonTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultSemicolonTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}
+ (NSSet*)entailmentTokens{
    static dispatch_once_t pred = 0;
    __strong static NSSet* _tokens = nil;
    dispatch_once(&pred, ^{
        NSMutableSet*set = [self localizedTokens:[self defaultEntailmentTokens]];
        [set minusSet:[self allTokens]];
        [set removeEmptyTokens];
        [[self allTokens] unionSet:set];
        _tokens = [set copy];
    });
    return _tokens;
}

@end

@implementation NSMutableSet (NyayaToken)

- (void)removeEmptyTokens {
    [self removeObject:@""];
    [self removeObject:@" "];
}

@end
