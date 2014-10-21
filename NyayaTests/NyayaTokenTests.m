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
    XCTAssertTrue([@"¬" isNegationToken]);
    XCTAssertTrue([@"!" isNegationToken]);
    
    XCTAssertFalse([@"∨" isNegationToken]);
    XCTAssertFalse([@"|" isNegationToken]);
    XCTAssertFalse([@"∧" isNegationToken]);
    XCTAssertFalse([@"&" isNegationToken]);
    XCTAssertFalse([@"→" isNegationToken]);
    XCTAssertFalse([@">" isNegationToken]);
    XCTAssertFalse([@"↔" isNegationToken]);
    XCTAssertFalse([@"<>" isNegationToken]);
    
    XCTAssertFalse([@"(" isNegationToken]);
    XCTAssertFalse([@")" isNegationToken]);
    XCTAssertFalse([@";" isNegationToken]);
    XCTAssertFalse([@"," isNegationToken]);
}

- (void)testIsConjunction {
    XCTAssertFalse([@"¬" isConjunctionToken]);
    XCTAssertFalse([@"!" isConjunctionToken]);
    XCTAssertFalse([@"∨" isConjunctionToken]);
    XCTAssertFalse([@"|" isConjunctionToken]);
    XCTAssertTrue([@"∧" isConjunctionToken]);
    XCTAssertTrue([@"&" isConjunctionToken]);
    XCTAssertFalse([@"→" isConjunctionToken]);
    XCTAssertFalse([@">" isConjunctionToken]);
    XCTAssertFalse([@"↔" isConjunctionToken]);
    XCTAssertFalse([@"<>" isConjunctionToken]);
    
    XCTAssertFalse([@"(" isConjunctionToken]);
    XCTAssertFalse([@")" isConjunctionToken]);
    XCTAssertFalse([@";" isConjunctionToken]);
    XCTAssertFalse([@"," isConjunctionToken]);
}

- (void)testIsDisjunction {
    XCTAssertFalse([@"¬" isDisjunctionToken]);
    XCTAssertFalse([@"!" isDisjunctionToken]);
    XCTAssertTrue([@"∨" isDisjunctionToken]);
    XCTAssertTrue([@"|" isDisjunctionToken]);
    XCTAssertFalse([@"∧" isDisjunctionToken]);
    XCTAssertFalse([@"&" isDisjunctionToken]);
    XCTAssertFalse([@"→" isDisjunctionToken]);
    XCTAssertFalse([@">" isDisjunctionToken]);
    XCTAssertFalse([@"↔" isDisjunctionToken]);
    XCTAssertFalse([@"<>" isDisjunctionToken]);
    
    XCTAssertFalse([@"(" isDisjunctionToken]);
    XCTAssertFalse([@")" isDisjunctionToken]);
    XCTAssertFalse([@";" isDisjunctionToken]);
    XCTAssertFalse([@"," isDisjunctionToken]);
}



- (void)testIsImplication {
    XCTAssertFalse([@"¬" isImplicationToken]);
    XCTAssertFalse([@"!" isImplicationToken]);
    XCTAssertFalse([@"∨" isImplicationToken]);
    XCTAssertFalse([@"|" isImplicationToken]);
    XCTAssertFalse([@"∧" isImplicationToken]);
    XCTAssertFalse([@"&" isImplicationToken]);
    XCTAssertTrue([@"→" isImplicationToken]);
    XCTAssertTrue([@">" isImplicationToken]);
    XCTAssertFalse([@"↔" isImplicationToken]);
    XCTAssertFalse([@"<>" isImplicationToken]);
    
    XCTAssertFalse([@"(" isImplicationToken]);
    XCTAssertFalse([@")" isImplicationToken]);
    XCTAssertFalse([@";" isImplicationToken]);
    XCTAssertFalse([@"," isImplicationToken]);
}

- (void)testIsBicondition {
    XCTAssertFalse([@"¬" isBiconditionToken]);
    XCTAssertFalse([@"!" isBiconditionToken]);
    XCTAssertFalse([@"∨" isBiconditionToken]);
    XCTAssertFalse([@"|" isBiconditionToken]);
    XCTAssertFalse([@"∧" isBiconditionToken]);
    XCTAssertFalse([@"&" isBiconditionToken]);
    XCTAssertFalse([@"→" isBiconditionToken]);
    XCTAssertFalse([@">" isBiconditionToken]);
    XCTAssertTrue([@"↔" isBiconditionToken]);
    XCTAssertTrue([@"<>" isBiconditionToken]);
    
    XCTAssertFalse([@"(" isBiconditionToken]);
    XCTAssertFalse([@")" isBiconditionToken]);
    XCTAssertFalse([@";" isBiconditionToken]);
    XCTAssertFalse([@"," isBiconditionToken]);
}



- (void)testIsLeftParenthesis {
    XCTAssertFalse([@"¬" isLeftParenthesis]);
    XCTAssertFalse([@"!" isLeftParenthesis]);
    XCTAssertFalse([@"∨" isLeftParenthesis]);
    XCTAssertFalse([@"|" isLeftParenthesis]);
    XCTAssertFalse([@"∧" isLeftParenthesis]);
    XCTAssertFalse([@"&" isLeftParenthesis]);
    XCTAssertFalse([@"→" isLeftParenthesis]);
    XCTAssertFalse([@">" isLeftParenthesis]);
    XCTAssertFalse([@"↔" isLeftParenthesis]);
    XCTAssertFalse([@"<>" isLeftParenthesis]);
    
    XCTAssertTrue([@"(" isLeftParenthesis]);
    XCTAssertFalse([@")" isLeftParenthesis]);
    XCTAssertFalse([@";" isLeftParenthesis]);
    XCTAssertFalse([@"," isLeftParenthesis]);
}

- (void)testIsRightParenthesis {
    XCTAssertFalse([@"¬" isRightParenthesis]);
    XCTAssertFalse([@"!" isRightParenthesis]);
    XCTAssertFalse([@"∨" isRightParenthesis]);
    XCTAssertFalse([@"|" isRightParenthesis]);
    XCTAssertFalse([@"∧" isRightParenthesis]);
    XCTAssertFalse([@"&" isRightParenthesis]);
    XCTAssertFalse([@"→" isRightParenthesis]);
    XCTAssertFalse([@">" isRightParenthesis]);
    XCTAssertFalse([@"↔" isRightParenthesis]);
    XCTAssertFalse([@"<>" isRightParenthesis]);
    
    XCTAssertFalse([@"(" isRightParenthesis]);
    XCTAssertTrue([@")" isRightParenthesis]);
    XCTAssertFalse([@";" isRightParenthesis]);
    XCTAssertFalse([@"," isRightParenthesis]);
}

- (void)testIsComma {
    XCTAssertFalse([@"¬" isComma]);
    XCTAssertFalse([@"!" isComma]);
    XCTAssertFalse([@"∨" isComma]);
    XCTAssertFalse([@"|" isComma]);
    XCTAssertFalse([@"∧" isComma]);
    XCTAssertFalse([@"&" isComma]);
    XCTAssertFalse([@"→" isComma]);
    XCTAssertFalse([@">" isComma]);
    XCTAssertFalse([@"↔" isComma]);
    XCTAssertFalse([@"<>" isComma]);
    
    XCTAssertFalse([@"(" isComma]);
    XCTAssertFalse([@")" isComma]);
    XCTAssertFalse([@";" isComma]);
    XCTAssertTrue([@"," isComma]);
}

- (void)testIsSemicolon {
    XCTAssertFalse([@"¬" isSemicolon]);
    XCTAssertFalse([@"!" isSemicolon]);
    XCTAssertFalse([@"∨" isSemicolon]);
    XCTAssertFalse([@"|" isSemicolon]);
    XCTAssertFalse([@"∧" isSemicolon]);
    XCTAssertFalse([@"&" isSemicolon]);
    XCTAssertFalse([@"→" isSemicolon]);
    XCTAssertFalse([@">" isSemicolon]);
    XCTAssertFalse([@"↔" isSemicolon]);
    XCTAssertFalse([@"<>" isSemicolon]);
    
    XCTAssertFalse([@"(" isSemicolon]);
    XCTAssertFalse([@")" isSemicolon]);
    XCTAssertTrue([@";" isSemicolon]);
    XCTAssertFalse([@"," isSemicolon]);
}



- (void)testIsComplement {
    XCTAssertTrue([@"¬atom" hasComplement:@"atom"]);
    XCTAssertTrue([@"atom" hasComplement:@"¬atom"]);
    XCTAssertTrue([@"¬¬atom" hasComplement:@"¬atom"]);
    XCTAssertTrue([@"¬¬atom" hasComplement:@"¬¬¬atom"]);
    
    XCTAssertFalse([@"x" hasComplement:@"x"]);
    XCTAssertFalse([@"x" hasComplement:@"¬y"]);
    XCTAssertFalse([@"¬¬x" hasComplement:@"¬y"]);
    XCTAssertFalse([@"¬¬x" hasComplement:@"¬¬x"]);
    
    XCTAssertTrue([@"¬atom&y" hasComplement:@"atom&y"]);
    XCTAssertTrue([@"atom&y" hasComplement:@"¬atom&y"]);
    XCTAssertTrue([@"¬¬atom&y" hasComplement:@"¬atom&y"]);
    XCTAssertTrue([@"¬¬atom&y" hasComplement:@"¬¬¬atom&y"]);
    
    XCTAssertFalse([@"x&y" hasComplement:@"x&y"]);
    XCTAssertFalse([@"x&y" hasComplement:@"¬y&y"]);
    XCTAssertFalse([@"¬¬x&y" hasComplement:@"¬y&y"]);
    XCTAssertFalse([@"¬¬x&y" hasComplement:@"¬¬x&y"]);
    
}

- (void)testIsIdentifierTokenTrue {
    for (NSString *input in @[@"ä"]) {
        XCTAssertTrue([input isIdentifierToken], @"%@",input);
    }
}


- (void)testIsIdentifierTokenFalse {
    for (NSString *input in @[@"frm", @"NOT", @"AND", @"OR"]) {
        XCTAssertFalse([input isIdentifierToken], @"%@",input);
    }
}


@end
