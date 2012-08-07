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
    STAssertFalse([@"↔" isNegationToken],nil);
    STAssertFalse([@"<>" isNegationToken],nil);
    
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
    STAssertFalse([@"↔" isConjunctionToken],nil);
    STAssertFalse([@"<>" isConjunctionToken],nil);
    
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
    STAssertFalse([@"↔" isDisjunctionToken],nil);
    STAssertFalse([@"<>" isDisjunctionToken],nil);
    
    STAssertFalse([@"(" isDisjunctionToken],nil);
    STAssertFalse([@")" isDisjunctionToken],nil);
    STAssertFalse([@";" isDisjunctionToken],nil);
    STAssertFalse([@"," isDisjunctionToken],nil);
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
    STAssertFalse([@"↔" isImplicationToken],nil);
    STAssertFalse([@"<>" isImplicationToken],nil);
    
    STAssertFalse([@"(" isImplicationToken],nil);
    STAssertFalse([@")" isImplicationToken],nil);
    STAssertFalse([@";" isImplicationToken],nil);
    STAssertFalse([@"," isImplicationToken],nil);
}

- (void)testIsBicondition {
    STAssertFalse([@"¬" isBiconditionToken],nil);
    STAssertFalse([@"!" isBiconditionToken],nil);
    STAssertFalse([@"∨" isBiconditionToken],nil);
    STAssertFalse([@"|" isBiconditionToken],nil);
    STAssertFalse([@"∧" isBiconditionToken],nil);
    STAssertFalse([@"&" isBiconditionToken],nil);
    STAssertFalse([@"→" isBiconditionToken],nil);
    STAssertFalse([@">" isBiconditionToken],nil);
    STAssertTrue([@"↔" isBiconditionToken],nil);
    STAssertTrue([@"<>" isBiconditionToken],nil);
    
    STAssertFalse([@"(" isBiconditionToken],nil);
    STAssertFalse([@")" isBiconditionToken],nil);
    STAssertFalse([@";" isBiconditionToken],nil);
    STAssertFalse([@"," isBiconditionToken],nil);
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
    STAssertFalse([@"↔" isLeftParenthesis],nil);
    STAssertFalse([@"<>" isLeftParenthesis],nil);
    
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
    STAssertFalse([@"↔" isRightParenthesis],nil);
    STAssertFalse([@"<>" isRightParenthesis],nil);
    
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
    STAssertFalse([@"↔" isComma],nil);
    STAssertFalse([@"<>" isComma],nil);
    
    STAssertFalse([@"(" isComma],nil);
    STAssertFalse([@")" isComma],nil);
    STAssertFalse([@";" isComma],nil);
    STAssertTrue([@"," isComma],nil);
}

- (void)testIsSemicolon {
    STAssertFalse([@"¬" isSemicolon],nil);
    STAssertFalse([@"!" isSemicolon],nil);
    STAssertFalse([@"∨" isSemicolon],nil);
    STAssertFalse([@"|" isSemicolon],nil);
    STAssertFalse([@"∧" isSemicolon],nil);
    STAssertFalse([@"&" isSemicolon],nil);
    STAssertFalse([@"→" isSemicolon],nil);
    STAssertFalse([@">" isSemicolon],nil);
    STAssertFalse([@"↔" isSemicolon],nil);
    STAssertFalse([@"<>" isSemicolon],nil);
    
    STAssertFalse([@"(" isSemicolon],nil);
    STAssertFalse([@")" isSemicolon],nil);
    STAssertTrue([@";" isSemicolon],nil);
    STAssertFalse([@"," isSemicolon],nil);
}



- (void)testIsComplement {
    STAssertTrue([@"¬atom" hasComplement:@"atom"],nil);
    STAssertTrue([@"atom" hasComplement:@"¬atom"],nil);
    STAssertTrue([@"¬¬atom" hasComplement:@"¬atom"],nil);
    STAssertTrue([@"¬¬atom" hasComplement:@"¬¬¬atom"],nil);
    
    STAssertFalse([@"x" hasComplement:@"x"],nil);
    STAssertFalse([@"x" hasComplement:@"¬y"],nil);
    STAssertFalse([@"¬¬x" hasComplement:@"¬y"],nil);
    STAssertFalse([@"¬¬x" hasComplement:@"¬¬x"],nil);
    
    STAssertTrue([@"¬atom&y" hasComplement:@"atom&y"],nil);
    STAssertTrue([@"atom&y" hasComplement:@"¬atom&y"],nil);
    STAssertTrue([@"¬¬atom&y" hasComplement:@"¬atom&y"],nil);
    STAssertTrue([@"¬¬atom&y" hasComplement:@"¬¬¬atom&y"],nil);
    
    STAssertFalse([@"x&y" hasComplement:@"x&y"],nil);
    STAssertFalse([@"x&y" hasComplement:@"¬y&y"],nil);
    STAssertFalse([@"¬¬x&y" hasComplement:@"¬y&y"],nil);
    STAssertFalse([@"¬¬x&y" hasComplement:@"¬¬x&y"],nil);
    
}

- (void)testIsIdentifierTokenTrue {
    for (NSString *input in @[@"ä"]) {
        STAssertTrue([input isIdentifierToken], input);
    }
}


- (void)testIsIdentifierTokenFalse {
    for (NSString *input in @[@"frm", @"NOT", @"AND", @"OR"]) {
        STAssertFalse([input isIdentifierToken], input);
    }
}


@end
