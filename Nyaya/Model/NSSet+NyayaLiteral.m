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

- (BOOL)containsContemplementOf:(NSString*)string {
    return [self containsObject:[string complementaryString]];
}

- (BOOL)containsContemplementaryStrings {
    __block BOOL contains = NO;
    [self enumerateObjectsUsingBlock:^(NSString *string, BOOL *stop) {
        if ([self containsContemplementOf:string]) {
            contains = YES; *stop=YES;
        }
    }];
    
    return contains;
}

@end
