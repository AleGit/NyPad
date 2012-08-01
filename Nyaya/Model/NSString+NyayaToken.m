//
//  NSString+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSString+NyayaToken.h"

NSString *const NYAYA_TOKENS = 
    @"¬|!"      // negation
    "|∧|&"      // conjunction
    "|∨|\\|"    // disjunction
    "|→|>"      // implication
    "|↔|<>"     // bicondition
    "|\\("      // left parenthesis
    "|\\)"      // right parenthesis
    "|,"        // comma
    "|;"        // semicolon
    "|\\w+"     // identifier
    ;

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

- (NSString*)complementaryString {
    if ([self hasPrefix:@"¬"] || [self hasPrefix:@"!"]) return [self substringFromIndex:1];
    else return [@"¬" stringByAppendingString:self];
}

- (BOOL)hasComplement:(NSString *)string {
    return ( 
            [self length] == [string length] + 1                 // ¬string string
            && [self hasPrefix:@"¬"] && [self hasSuffix:string])
    || ( 
        [self length] + 1 == [string length]                     // string ¬string
        && [string hasPrefix:@"¬"] && [string hasSuffix:self]);
}

@end
