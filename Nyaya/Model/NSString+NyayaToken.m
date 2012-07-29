//
//  NSString+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSString+NyayaToken.h"

NSString *const NYAYA_TOKENS = @"(¬|!)|(∧|&)|(∨|\\|)|(→|>)|(↔|<>)|\\(|\\)|,|;|\\w+";

@implementation NSString (NyayaToken)

- (BOOL)isTrueToken {
    return [self isEqualToString:@"T"] || [self isEqualToString:@"1"];
}

- (BOOL)isFalseToken {
    return [self isEqualToString:@"F"] || [self isEqualToString:@"0"];
}

- (BOOL)isNegationToken {
    return [self isEqualToString:@"¬"]
    || [self isEqualToString:@"!"];
}

- (BOOL)isConjunctionToken {
    return [self isEqualToString:@"∧"]
    || [self isEqualToString:@"&"];
}

- (BOOL)isDisjunctionToken {
    return [self isEqualToString:@"∨"]
    || [self isEqualToString:@"|"];
}

- (BOOL)isJunctionToken {
    return [self isDisjunctionToken] || [self isConjunctionToken];
}

- (BOOL)isImplicationToken {
    return [self isEqualToString:@"→"]
    || [self isEqualToString:@">"];
}

- (BOOL)isBiconditionToken {
    return [self isEqualToString:@"↔"]
    || [self isEqualToString:@"<>"];
}

- (BOOL)isIdentifierToken {
    NSCharacterSet *noids = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSRange range = [self rangeOfCharacterFromSet:noids];
    
    return range.location == NSNotFound;
}

- (BOOL)isLeftParenthesis {
    return [self isEqualToString:@"("];
}

- (BOOL)isRightParenthesis {
    return [self isEqualToString:@")"];
}

- (BOOL)isComma {
    return [self isEqualToString:@","];
}

- (BOOL)isSemicolon {
    return [self isEqualToString:@";"];
}

- (NSString*)complementaryLiteral {
    if ([self hasPrefix:@"¬"]) return [self substringFromIndex:1];
    else return [@"¬" stringByAppendingString:self];
}

- (BOOL)isComplementLiteral:(NSString *)s {
    return ( 
            [self length] == [s length] + 1                 // ¬atom atom
            && [self hasPrefix:@"¬"] && [self hasSuffix:s])
    || ( 
        [self length] + 1 == [s length]                     // atom ¬atom
        && [s hasPrefix:@"¬"] && [s hasSuffix:self]);
}

@end
