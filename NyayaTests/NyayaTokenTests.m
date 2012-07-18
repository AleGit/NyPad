//
//  NyayaTokenTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaTokenTests.h"
#import "NSString+NyayaToken.h"

@implementation NyayaTokenTests

- (void)testIsNegation {
    STAssertTrue([@"¬" isNegation],nil);
    STAssertTrue([@"!" isNegation],nil);
    STAssertFalse([@"∨" isNegation],nil);
    STAssertFalse([@"|" isNegation],nil);
    STAssertFalse([@"∧" isNegation],nil);
    STAssertFalse([@"&" isNegation],nil);
    STAssertFalse([@"→" isNegation],nil);
    STAssertFalse([@">" isNegation],nil);
    
    STAssertFalse([@"(" isNegation],nil);
    STAssertFalse([@")" isNegation],nil);
    STAssertFalse([@";" isNegation],nil);
    STAssertFalse([@"," isNegation],nil);
}

- (void)testIsConjunction {
    STAssertFalse([@"¬" isConjunction],nil);
    STAssertFalse([@"!" isConjunction],nil);
    STAssertFalse([@"∨" isConjunction],nil);
    STAssertFalse([@"|" isConjunction],nil);
    STAssertTrue([@"∧" isConjunction],nil);
    STAssertTrue([@"&" isConjunction],nil);
    STAssertFalse([@"→" isConjunction],nil);
    STAssertFalse([@">" isConjunction],nil);
    
    STAssertFalse([@"(" isConjunction],nil);
    STAssertFalse([@")" isConjunction],nil);
    STAssertFalse([@";" isConjunction],nil);
    STAssertFalse([@"," isConjunction],nil);
}

- (void)testIsDisjunction {
    STAssertFalse([@"¬" isDisjunction],nil);
    STAssertFalse([@"!" isDisjunction],nil);
    STAssertTrue([@"∨" isDisjunction],nil);
    STAssertTrue([@"|" isDisjunction],nil);
    STAssertFalse([@"∧" isDisjunction],nil);
    STAssertFalse([@"&" isDisjunction],nil);
    STAssertFalse([@"→" isDisjunction],nil);
    STAssertFalse([@">" isDisjunction],nil);
    
    STAssertFalse([@"(" isDisjunction],nil);
    STAssertFalse([@")" isDisjunction],nil);
    STAssertFalse([@";" isDisjunction],nil);
    STAssertFalse([@"," isDisjunction],nil);
}

- (void)testIsJunction {
    STAssertFalse([@"¬" isJunction],nil);
    STAssertFalse([@"!" isJunction],nil);
    STAssertTrue([@"∨" isJunction],nil);
    STAssertTrue([@"|" isJunction],nil);
    STAssertTrue([@"∧" isJunction],nil);
    STAssertTrue([@"&" isJunction],nil);
    STAssertFalse([@"→" isJunction],nil);
    STAssertFalse([@">" isJunction],nil);
    
    STAssertFalse([@"(" isJunction],nil);
    STAssertFalse([@")" isJunction],nil);
    STAssertFalse([@";" isJunction],nil);
    STAssertFalse([@"," isJunction],nil);
}



- (void)testIsImplication {
    STAssertFalse([@"¬" isImplication],nil);
    STAssertFalse([@"!" isImplication],nil);
    STAssertFalse([@"∨" isImplication],nil);
    STAssertFalse([@"|" isImplication],nil);
    STAssertFalse([@"∧" isImplication],nil);
    STAssertFalse([@"&" isImplication],nil);
    STAssertTrue([@"→" isImplication],nil);
    STAssertTrue([@">" isImplication],nil);
    
    STAssertFalse([@"(" isImplication],nil);
    STAssertFalse([@")" isImplication],nil);
    STAssertFalse([@";" isImplication],nil);
    STAssertFalse([@"," isImplication],nil);
}

- (void)testIsComplement {
    STAssertTrue([@"¬atom" isComplement:@"atom"],nil);
    STAssertTrue([@"atom" isComplement:@"¬atom"],nil);
    STAssertTrue([@"¬¬atom" isComplement:@"¬atom"],nil);
    STAssertTrue([@"¬¬atom" isComplement:@"¬¬¬atom"],nil);
    
    STAssertFalse([@"x" isComplement:@"x"],nil);
    STAssertFalse([@"x" isComplement:@"¬y"],nil);
    STAssertFalse([@"¬¬x" isComplement:@"¬y"],nil);
    STAssertFalse([@"¬¬x" isComplement:@"¬¬x"],nil);
                  
}



- (void)testIsLeftParenthesis {
    STAssertFalse([@"¬" isLeftParenthesis],nil);
    STAssertFalse([@"!" isLeftParenthesis],nil);
    STAssertFalse([@"∨" isLeftParenthesis],nil);
    STAssertFalse([@"|" isLeftParenthesis],nil);
    STAssertFalse([@"∧" isLeftParenthesis],nil);
    STAssertFalse([@"&" isLeftParenthesis],nil);
    STAssertFalse([@"→" isLeftParenthesis],nil);
    STAssertFalse([@">" isLeftParenthesis],nil);
    
    STAssertTrue([@"(" isLeftParenthesis],nil);
    STAssertFalse([@")" isLeftParenthesis],nil);
    STAssertFalse([@";" isLeftParenthesis],nil);
    STAssertFalse([@"," isLeftParenthesis],nil);
}

- (void)testIsRightParenthesis {
    STAssertFalse([@"¬" isRightParenthesis],nil);
    STAssertFalse([@"!" isRightParenthesis],nil);
    STAssertFalse([@"∨" isRightParenthesis],nil);
    STAssertFalse([@"|" isRightParenthesis],nil);
    STAssertFalse([@"∧" isRightParenthesis],nil);
    STAssertFalse([@"&" isRightParenthesis],nil);
    STAssertFalse([@"→" isRightParenthesis],nil);
    STAssertFalse([@">" isRightParenthesis],nil);
    
    STAssertFalse([@"(" isRightParenthesis],nil);
    STAssertTrue([@")" isRightParenthesis],nil);
    STAssertFalse([@";" isRightParenthesis],nil);
    STAssertFalse([@"," isRightParenthesis],nil);
}

- (void)testIsComma {
    STAssertFalse([@"¬" isComma],nil);
    STAssertFalse([@"!" isComma],nil);
    STAssertFalse([@"∨" isComma],nil);
    STAssertFalse([@"|" isComma],nil);
    STAssertFalse([@"∧" isComma],nil);
    STAssertFalse([@"&" isComma],nil);
    STAssertFalse([@"→" isComma],nil);
    STAssertFalse([@">" isComma],nil);
    
    STAssertFalse([@"(" isComma],nil);
    STAssertFalse([@")" isComma],nil);
    STAssertFalse([@";" isComma],nil);
    STAssertTrue([@"," isComma],nil);
}

- (void)sSemicolon {
    STAssertFalse([@"¬" isSemicolon],nil);
    STAssertFalse([@"!" isSemicolon],nil);
    STAssertFalse([@"∨" isSemicolon],nil);
    STAssertFalse([@"|" isSemicolon],nil);
    STAssertFalse([@"∧" isSemicolon],nil);
    STAssertFalse([@"&" isSemicolon],nil);
    STAssertFalse([@"→" isSemicolon],nil);
    STAssertFalse([@">" isSemicolon],nil);
    
    STAssertFalse([@"(" isSemicolon],nil);
    STAssertFalse([@")" isSemicolon],nil);
    STAssertTrue([@";" isSemicolon],nil);
    STAssertFalse([@"," isSemicolon],nil);
}

@end
