//
//  NSSet+NyayaToken.h
//  Nyaya
//
//  Created by Alexander Maringele on 05.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (NyayaToken)

+ (NSSet*)trueTokens;
+ (NSSet*)falseTokens;
+ (NSSet*)notTokens;
+ (NSSet*)andTokens;
+ (NSSet*)orTokens;
+ (NSSet*)bicTokens;
+ (NSSet*)impTokens;
+ (NSSet*)xorTokens;
+ (NSSet*)lparTokens;
+ (NSSet*)rparTokens;
+ (NSSet*)commaTokens;
+ (NSSet*)semicolonTokens;
+ (NSSet*)entailmentTokens;

@end

@interface NSMutableSet (NyayaToken)

- (void)removeEmptyTokens;

@end
