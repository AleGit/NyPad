//
//  NSSet+NyayaLiteral.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//


#import "NSSet+NyayaLiteral.h"
#import "NSString+NyayaToken.h"

@implementation NSSet (NyayaLiteral)

- (BOOL)containsComplementary:(NSString*)literal {
    return [self containsObject:[literal complementaryLiteral]];
}

- (BOOL)containsComplementaryLiterals {
    __block BOOL contains = NO;
    [self enumerateObjectsUsingBlock:^(NSString *literal, BOOL *stop) {
        if ([self containsComplementary:literal]) {
            contains = YES; *stop=YES;
        }
    }];
    
    return contains;
}

@end
