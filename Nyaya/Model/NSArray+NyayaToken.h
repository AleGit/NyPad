//
//  NSArray+NyayaToken.h
//  Nyaya
//
//  Created by Alexander Maringele on 07.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NyayaToken)

+ (NSArray*)trueTokens;
+ (NSArray*)falseTokens;
+ (NSArray*)notTokens;
+ (NSArray*)andTokens;
+ (NSArray*)orTokens;
+ (NSArray*)bicTokens;
+ (NSArray*)impTokens;
+ (NSArray*)xorTokens;
+ (NSArray*)lparTokens;
+ (NSArray*)rparTokens;
+ (NSArray*)commaTokens;
+ (NSArray*)semicolonTokens;

@end
