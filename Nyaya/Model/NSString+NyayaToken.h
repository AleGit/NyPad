//
//  NSString+NyayaToken.h
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NyayaToken)

- (BOOL)isNegation;
- (BOOL)isConjunction;
- (BOOL)isDisjunction;
- (BOOL)isJunction;
- (BOOL)isImplication;

- (NSString*)complementaryLiteral;
- (BOOL)isComplement:(NSString*)s;

- (BOOL)isIdentifier;
- (BOOL)isLeftParenthesis;
- (BOOL)isRightParenthesis;
- (BOOL)isComma;
- (BOOL)isSemicolon;



@end
