//
//  NSString+NyayaToken.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NSString+NyayaToken.h"



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

+ (NSArray*)tokensForKey:(NSString*)ascii utf8:(NSString*)utf8 tokens:(NSArray*)additionals{
    
    NSMutableArray *tokens = [@[ascii, utf8] mutableCopy];
    [tokens addObjectsFromArray:[NSLocalizedString(ascii, utf8) componentsSeparatedByString:@","]];
    for (NSString *addition in additionals) {
        if ([tokens indexOfObject:addition] == NSNotFound) {
            [tokens addObject:addition];
        }
    }
    return tokens;
}

+ (NSArray*)trueTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @"T";
        NSString *utf8 = @"⊤";
        NSArray *additionals = @[@"1"];
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)falseTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @"F";
        NSString *utf8 = @"⊥";
        NSArray *additionals = @[@"0"];
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)notTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @"!";
        NSString *utf8 = @"¬";
        NSArray *additionals = nil;
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)andTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @"&";
        NSString *utf8 = @"∧";
        NSArray *additionals = @[@"."];
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)orTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @"|";
        NSString *utf8 = @"∨";
        NSArray *additionals = @[@"+"];
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)bicTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{ 
        NSString *ascii = @"<>";
        NSString *utf8 = @"↔";
        NSArray *additionals = nil;
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)impTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @">";
        NSString *utf8 = @"→";
        NSArray *additionals = nil;
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)xorTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @"^";
        NSString *utf8 = @"⊻";
        NSArray *additionals = @[@"⊕"];
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)lparTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @"(";
        NSString *utf8 = @"(";
        NSArray *additionals = nil;
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)rparTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @")";
        NSString *utf8 = @")";
        NSArray *additionals = nil;
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)commaTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @",";
        NSString *utf8 = @",";
        NSArray *additionals = nil;
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSArray*)semicolonTokens
{
    static dispatch_once_t pred = 0;
    __strong static NSArray* _tokens = nil;
    dispatch_once(&pred, ^{
        NSString *ascii = @";";
        NSString *utf8 = @";";
        NSArray *additionals = nil;
        _tokens = [NSString tokensForKey:ascii utf8:utf8 tokens:additionals]; });
    return _tokens;
}

+ (NSSet*)tokenKeywords {
    static dispatch_once_t pred = 0;
    __strong static NSMutableSet* _keywords = nil;
    dispatch_once(&pred, ^{
        _keywords = [NSMutableSet setWithObject:@"frm"];        // BoolTool keyword
        [_keywords addObjectsFromArray:[NSString notTokens]];
        [_keywords addObjectsFromArray:[NSString andTokens]];
        [_keywords addObjectsFromArray:[NSString orTokens]];
        [_keywords addObjectsFromArray:[NSString bicTokens]];
        [_keywords addObjectsFromArray:[NSString impTokens]];
        [_keywords addObjectsFromArray:[NSString xorTokens]];
        
        [_keywords addObjectsFromArray:[NSString lparTokens]];
        [_keywords addObjectsFromArray:[NSString rparTokens]];
        [_keywords addObjectsFromArray:[NSString commaTokens]];
    });
    return _keywords;

    
}

- (BOOL)isTrueToken {
    return [[NSString trueTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isFalseToken {
    return [[NSString falseTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isNegationToken {
    return [[NSString notTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isConjunctionToken {
    return [[NSString andTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isDisjunctionToken {
    return [[NSString orTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isBiconditionToken {
    return [[NSString bicTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isImplicationToken {
    return [[NSString impTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isXdisjunctionToken {
    return [[NSString xorTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isLeftParenthesis {
    return [[NSString lparTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isRightParenthesis {
    return [[NSString rparTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isComma {
    return [[NSString commaTokens] indexOfObject:self] != NSNotFound;
}

- (BOOL)isSemicolon {
    return [[NSString semicolonTokens] indexOfObject:self] != NSNotFound;
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

@end
