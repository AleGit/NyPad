//
//  NSString+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSString+NyayaToken.h"
#import "NSArray+NyayaToken.h"


NSString *const NYAYA_TOKENS =
    @"⊤|⊥"          // TOP BOTTOM
    "|¬|!"          // NOT   negation
    "|∧|&|\\."      // AND   conjunction
    "|∨|\\+|\\|"    // OR    disjunction
    "|↔|<>"         // BIC   bicondition
    "|→|>"          // IMP   implication
    "|⊻|⊕|\\^"      // XOR   exclusive disjunction
    "|\\("          // LPAR  left parenthesis
    "|\\)"          // RPAR  right parenthesis
    "|,"            // COMMA comma
    "|;"            // SEMIC semicolon
    "|\\w+"         // IDENT identifier
    ;

@implementation NSString (NyayaToken)

+ (NSSet*)tokenKeywords {
    static dispatch_once_t pred = 0;
    __strong static NSMutableSet* _keywords = nil;
    dispatch_once(&pred, ^{
        _keywords = [NSMutableSet setWithObject:@"frm"];        // BoolTool keyword
        [_keywords addObjectsFromArray:[NSArray notTokens]];
        [_keywords addObjectsFromArray:[NSArray andTokens]];
        [_keywords addObjectsFromArray:[NSArray orTokens]];
        [_keywords addObjectsFromArray:[NSArray bicTokens]];
        [_keywords addObjectsFromArray:[NSArray impTokens]];
        [_keywords addObjectsFromArray:[NSArray xorTokens]];
        
        [_keywords addObjectsFromArray:[NSArray lparTokens]];
        [_keywords addObjectsFromArray:[NSArray rparTokens]];
        [_keywords addObjectsFromArray:[NSArray commaTokens]];
    });
    return _keywords;

    
}

- (BOOL)isTrueToken {
    return [[NSArray trueTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isFalseToken {
    return [[NSArray falseTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isNegationToken {
    return [[NSArray notTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isConjunctionToken {
    return [[NSArray andTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isDisjunctionToken {
    return [[NSArray orTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isBiconditionToken {
    return [[NSArray bicTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isImplicationToken {
    return [[NSArray impTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isXdisjunctionToken {
    return [[NSArray xorTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isLeftParenthesis {
    return [[NSArray lparTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isRightParenthesis {
    return [[NSArray rparTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isComma {
    return [[NSArray commaTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isSemicolon {
    return [[NSArray semicolonTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isIdentifierToken {
    // do not use keywords as identifiers
    if ([[NSString tokenKeywords] containsObject:self]) return NO;
    
    /*  // the tokenizer ignores all non word characters (except defined symbols) 
        // so this check is not necessary
    NSCharacterSet *noids = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSRange range = [self rangeOfCharacterFromSet:noids];
    
    if (range.location != NSNotFound) return NO; */
    
    return YES;
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


- (NSString*)capitalizedHtmlEntityFreeString {
    NSMutableString *mutableInput=[self mutableCopy];
    
    [mutableInput replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableInput length])];
    [mutableInput replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableInput length])];
    [mutableInput replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableInput length])];
    
    return [mutableInput capitalizedString];
}

@end
