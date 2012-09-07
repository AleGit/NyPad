//
//  NyayaParser.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NyayaNode;

/*
enum { NyayaParserStateInput = 1, 
    NyayaParserStateSequence, NyayaParserStateFormula, NyayaParserStateJunction, NyayaParserStateNegation, NyayaParserStateTerm, NyayaParserStateTuple,
    NyayaParserStateFinished
};
typedef NSUInteger NyayaParserState;
*/

enum { 
    NyayaErrorNoToken = 1, 
    NyayaErrorNoIdentifier=2, 
    NyayaErrorNoLeftParenthesis=4, 
    NyayaErrorNoRightParenthesis=8,
    NyayaErrorNoNegation=16,
    NyayaErrorNoBinaryConnector=32,
    NyayaErrorUnusedToken = 64,
    NyayaErrorFunctionNotSupported = 128
};
typedef NSUInteger NyayaErrorState;



@interface NyayaParser : NSObject

@property (readonly) NSString* input;
@property (readonly) NSArray* tokens;
@property (readonly) NyayaErrorState firstErrorState;

+ (id)parserWithString:(NSString*)input;
- (id)initWithString:(NSString*)input;

- (BOOL)hasErrors;
- (NSString*)errorDescriptions;

- (NyayaNode*)parseFormula;         // formula      = entailment
- (NyayaNode*)parseEntailment;      // entailment   = sequence [ |= entailment ]
- (NyayaNode*)parseSequence;        // sequence     = bicondition { SEMICOLON bicondition }
- (NyayaNode*)parseBicondition;     // bicondition  = implication[ BIC bicondition ]
- (NyayaNode*)parseImplication;     // implication  = xdisjunction [ IMP implication ]
- (NyayaNode*)parseXdisjunction;    // xdisjunction = disjunction { XOR disjunction } 
- (NyayaNode*)parseDisjunction;     // disjunction  = conjunction { OR conjunction }
- (NyayaNode*)parseConjunction;     // conjunction  = negation    { AND negation }
- (NyayaNode*)parseNegation;        // negation     = NOT negation | term | LPAR formula RPAR
- (NyayaNode*)parseTerm;            // term         = identifier [ LPAR RPAR | LPAR tuple RPAR ]
- (NSArray*)parseTuple;             // tuple        = formula { COMMA formula }


@end
