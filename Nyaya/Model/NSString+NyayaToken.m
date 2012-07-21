//
//  NSString+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSString+NyayaToken.h"

@implementation NSString (NyayaToken)

- (BOOL)isNegation {
    
    
    return [self isEqualToString:@"¬"]
    || [self isEqualToString:@"!"];
}

- (BOOL)isConjunction {
    return [self isEqualToString:@"∧"]
    || [self isEqualToString:@"&"];
    
}

- (BOOL)isDisjunction {
    return [self isEqualToString:@"∨"]
    || [self isEqualToString:@"|"];
    
}

- (BOOL)isJunction {
    return [self isDisjunction] || [self isConjunction];
}

- (BOOL)isImplication {
    
    return [self isEqualToString:@"→"]
    || [self isEqualToString:@">"];
    
}

- (BOOL)isBicondition {
    
    return [self isEqualToString:@"↔"]
    || [self isEqualToString:@"<>"];
    
}

- (NSString*)complementaryLiteral {
    if ([self hasPrefix:@"¬"]) return [self substringFromIndex:1];
    else return [@"¬" stringByAppendingString:self];
}

- (BOOL)isComplement:(NSString *)s {
    
    return ( 
            [self length] == [s length] + 1                 // ¬atom atom
            && [self hasPrefix:@"¬"] && [self hasSuffix:s])
    || ( 
        [self length] + 1 == [s length]                     // atom ¬atom
        && [s hasPrefix:@"¬"] && [s hasSuffix:self]);
    
    // return [self isEqualToString:[s complementaryLiteral]];
}

- (BOOL)isIdentifier {
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

@end
