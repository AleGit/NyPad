//
//  NSString+NyayaToken.h
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (NyayaToken)
+ (NSRegularExpression*)nyayaTokenRegex;
@end

@interface NSString (NyayaToken)

+ (NSString*)nyayaTokenPattern;

- (BOOL)isTrueToken;    // are identifiers too
- (BOOL)isFalseToken;   // are identifiers too

- (BOOL)isNegationToken;
- (BOOL)isConjunctionToken;
- (BOOL)isDisjunctionToken;
- (BOOL)isImplicationToken;
- (BOOL)isBiconditionToken;
- (BOOL)isXdisjunctionToken;

- (BOOL)isIdentifierToken;
- (BOOL)isLeftParenthesis;
- (BOOL)isRightParenthesis;
- (BOOL)isComma;
- (BOOL)isSemicolon;
- (BOOL)isEntailment;

- (NSString*)complementaryString;
- (BOOL)hasComplement:(NSString*)string;

- (NSString*)capitalizedHtmlEntityFreeString;

@end
