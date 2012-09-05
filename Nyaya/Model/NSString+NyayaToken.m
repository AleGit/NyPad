//
//  NSString+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSString+NyayaToken.h"
#import "NSSet+NyayaToken.h"

NSString *const NYAYA_TOKEN_PATTERN =
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

NSString *const NYAYA_CONNECTIVES_ASCII    = @"F,T,!,&,|,^,=,>";      // comma separated list of ascii symbols for connectives (unused)
NSString *const NYAYA_CONNECTIVES_STANDARD = @"⊥,⊤,¬,∧,∨,⊻,↔,→";      // comma separated list of standard symbols for connectives (unused)
NSString *const NYAYA_CONNECTIVES_BOOLEAN  = @"0,1,!,.,+,⊕,↔,→";      // comma separated list of boolean symbols for connectives (unused)

NSString *const NYAYA_TOKEN_PATTERN_KEY = @"NYAYA_TOKEN_PATTERN";
NSString *const NYAYA_CONNECTIVES_ASCII_KEY = @"NYAYA_CONNECTIVES_ASCII";
NSString *const NYAYA_CONNECTIVES_STANDARD_KEY = @"NYAYA_CONNECTIVES_STANDARD";
NSString *const NYAYA_CONNECTIVES_BOOLEAN_KEY = @"NYAYA_CONNECTIVES_BOOLEAN";

@implementation NSRegularExpression (NyayaToken)
+ (NSRegularExpression*)nyayaTokenRegex {
    static dispatch_once_t pred = 0;
    __strong static NSRegularExpression *_regex = nil;
    dispatch_once(&pred, ^{
        NSError *error;
        _regex = [NSRegularExpression regularExpressionWithPattern:[NSString nyayaTokenPattern]
                                                           options:NSRegularExpressionCaseInsensitive
                                                             error:&error];
    });
    
    return _regex;
    
}
@end

@implementation NSString (NyayaToken)

+ (NSString*)nyayaTokenPattern {
    static dispatch_once_t pred = 0;
    __strong static NSString *_pattern = nil;
    dispatch_once(&pred, ^{
        _pattern = NSLocalizedString(NYAYA_TOKEN_PATTERN_KEY, nil);
        if ([_pattern isEqualToString:NYAYA_TOKEN_PATTERN_KEY]) {
            _pattern = NYAYA_TOKEN_PATTERN;
        }
    });
    return _pattern;
}

+ (NSSet*)tokenKeywords {
    static dispatch_once_t pred = 0;
    __strong static NSMutableSet* _keywords = nil;
    dispatch_once(&pred, ^{
        _keywords = [NSMutableSet setWithObject:@"frm"];        // BoolTool keyword
        [_keywords unionSet:[NSSet notTokens]];
        [_keywords unionSet:[NSSet andTokens]];
        [_keywords unionSet:[NSSet orTokens]];
        [_keywords unionSet:[NSSet bicTokens]];
        [_keywords unionSet:[NSSet impTokens]];
        [_keywords unionSet:[NSSet xorTokens]];
        
        [_keywords unionSet:[NSSet lparTokens]];
        [_keywords unionSet:[NSSet rparTokens]];
        [_keywords unionSet:[NSSet commaTokens]];
        
        [_keywords unionSet:[NSSet semicolonTokens]];
        [_keywords unionSet:[NSSet entailmentTokens]];
    });
    return _keywords;
}

- (BOOL)isTrueToken {
    return [[NSSet trueTokens] containsObject:self];
}

- (BOOL)isFalseToken {
    return [[NSSet falseTokens] containsObject:self];
}

- (BOOL)isNegationToken {
    return [[NSSet notTokens] containsObject:self];
}

- (BOOL)isConjunctionToken {
    return [[NSSet andTokens] containsObject:self];
}

- (BOOL)isDisjunctionToken {
    return [[NSSet orTokens] containsObject:self];
}

- (BOOL)isBiconditionToken {
    return [[NSSet bicTokens] containsObject:self];
}

- (BOOL)isImplicationToken {
    return [[NSSet impTokens] containsObject:self];
}

- (BOOL)isXdisjunctionToken {
    return [[NSSet xorTokens] containsObject:self];
}

- (BOOL)isLeftParenthesis {
    return [[NSSet lparTokens] containsObject:self];
}

- (BOOL)isRightParenthesis {
    return [[NSSet rparTokens] containsObject:self];
}

- (BOOL)isComma {
    return [[NSSet commaTokens] containsObject:self];
}

- (BOOL)isSemicolon {
    return [[NSSet semicolonTokens] containsObject:self];
}

- (BOOL)isEntailment {
    return [[NSSet entailmentTokens] containsObject:self];
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
