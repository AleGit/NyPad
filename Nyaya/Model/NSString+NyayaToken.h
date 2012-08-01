//
//  NSString+NyayaToken.h
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const NYAYA_TOKENS;

@interface NSString (NyayaToken)

- (BOOL)isTrueToken;
- (BOOL)isFalseToken;

- (BOOL)isNegationToken;
- (BOOL)isConjunctionToken;
- (BOOL)isDisjunctionToken;
- (BOOL)isJunctionToken;
- (BOOL)isImplicationToken;
- (BOOL)isBiconditionToken;

- (BOOL)isIdentifierToken;
- (BOOL)isLeftParenthesis;
- (BOOL)isRightParenthesis;
- (BOOL)isComma;
- (BOOL)isSemicolon;

- (NSString*)complementaryString;
- (BOOL)hasComplement:(NSString*)string;

@end
