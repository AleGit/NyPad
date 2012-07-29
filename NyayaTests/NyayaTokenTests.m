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
    STAssertTrue([@"¬" isNegationToken],nil);
    STAssertTrue([@"!" isNegationToken],nil);
    STAssertFalse([@"∨" isNegationToken],nil);
    STAssertFalse([@"|" isNegationToken],nil);
    STAssertFalse([@"∧" isNegationToken],nil);
    STAssertFalse([@"&" isNegationToken],nil);
    STAssertFalse([@"→" isNegationToken],nil);
    STAssertFalse([@">" isNegationToken],nil);
    
    STAssertFalse([@"(" isNegationToken],nil);
    STAssertFalse([@")" isNegationToken],nil);
    STAssertFalse([@";" isNegationToken],nil);
    STAssertFalse([@"," isNegationToken],nil);
}

- (void)testIsConjunction {
    STAssertFalse([@"¬" isConjunctionToken],nil);
    STAssertFalse([@"!" isConjunctionToken],nil);
    STAssertFalse([@"∨" isConjunctionToken],nil);
    STAssertFalse([@"|" isConjunctionToken],nil);
    STAssertTrue([@"∧" isConjunctionToken],nil);
    STAssertTrue([@"&" isConjunctionToken],nil);
    STAssertFalse([@"→" isConjunctionToken],nil);
    STAssertFalse([@">" isConjunctionToken],nil);
    
    STAssertFalse([@"(" isConjunctionToken],nil);
    STAssertFalse([@")" isConjunctionToken],nil);
    STAssertFalse([@";" isConjunctionToken],nil);
    STAssertFalse([@"," isConjunctionToken],nil);
}

- (void)testIsDisjunction {
    STAssertFalse([@"¬" isDisjunctionToken],nil);
    STAssertFalse([@"!" isDisjunctionToken],nil);
    STAssertTrue([@"∨" isDisjunctionToken],nil);
    STAssertTrue([@"|" isDisjunctionToken],nil);
    STAssertFalse([@"∧" isDisjunctionToken],nil);
    STAssertFalse([@"&" isDisjunctionToken],nil);
    STAssertFalse([@"→" isDisjunctionToken],nil);
    STAssertFalse([@">" isDisjunctionToken],nil);
    
    STAssertFalse([@"(" isDisjunctionToken],nil);
    STAssertFalse([@")" isDisjunctionToken],nil);
    STAssertFalse([@";" isDisjunctionToken],nil);
    STAssertFalse([@"," isDisjunctionToken],nil);
}

- (void)testIsJunction {
    STAssertFalse([@"¬" isJunctionToken],nil);
    STAssertFalse([@"!" isJunctionToken],nil);
    STAssertTrue([@"∨" isJunctionToken],nil);
    STAssertTrue([@"|" isJunctionToken],nil);
    STAssertTrue([@"∧" isJunctionToken],nil);
    STAssertTrue([@"&" isJunctionToken],nil);
    STAssertFalse([@"→" isJunctionToken],nil);
    STAssertFalse([@">" isJunctionToken],nil);
    
    STAssertFalse([@"(" isJunctionToken],nil);
    STAssertFalse([@")" isJunctionToken],nil);
    STAssertFalse([@";" isJunctionToken],nil);
    STAssertFalse([@"," isJunctionToken],nil);
}



- (void)testIsImplication {
    STAssertFalse([@"¬" isImplicationToken],nil);
    STAssertFalse([@"!" isImplicationToken],nil);
    STAssertFalse([@"∨" isImplicationToken],nil);
    STAssertFalse([@"|" isImplicationToken],nil);
    STAssertFalse([@"∧" isImplicationToken],nil);
    STAssertFalse([@"&" isImplicationToken],nil);
    STAssertTrue([@"→" isImplicationToken],nil);
    STAssertTrue([@">" isImplicationToken],nil);
    
    STAssertFalse([@"(" isImplicationToken],nil);
    STAssertFalse([@")" isImplicationToken],nil);
    STAssertFalse([@";" isImplicationToken],nil);
    STAssertFalse([@"," isImplicationToken],nil);
}

- (void)testIsComplement {
    STAssertTrue([@"¬atom" isComplementLiteral:@"atom"],nil);
    STAssertTrue([@"atom" isComplementLiteral:@"¬atom"],nil);
    STAssertTrue([@"¬¬atom" isComplementLiteral:@"¬atom"],nil);
    STAssertTrue([@"¬¬atom" isComplementLiteral:@"¬¬¬atom"],nil);
    
    STAssertFalse([@"x" isComplementLiteral:@"x"],nil);
    STAssertFalse([@"x" isComplementLiteral:@"¬y"],nil);
    STAssertFalse([@"¬¬x" isComplementLiteral:@"¬y"],nil);
    STAssertFalse([@"¬¬x" isComplementLiteral:@"¬¬x"],nil);
                  
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
