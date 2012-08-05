//
//  NyayaParser.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    NyayaErrorUnusedToken = 64
};
typedef NSUInteger NyayaErrorState;


@class NyayaNode;

@interface NyayaParser : NSObject

@property (readonly) NSString* input;
@property (readonly) NSArray* tokens;
@property (readonly) NyayaErrorState firstErrorState;

+ (id)parserWithString:(NSString*)input;
- (id)initWithString:(NSString*)input;

- (BOOL)hasErrors;
- (NSString*)errorDescriptions;

- (NSArray*)parseSequence;   // sequence    = formula   { ";" formula }

- (NyayaNode*)parseFormula;         // formula     = implication { XOR implication }
- (NyayaNode*)parseImplication;     // implication = bicondition [ IMP implication ]
- (NyayaNode*)parseBicondition;     // bicondition = disjunction [ BIC bicondition ]
- (NyayaNode*)parseDisjunction;     // disjunction = conjunction { OR conjunction }
- (NyayaNode*)parseConjunction;     // conjunction = negation    { AND negation }
- (NyayaNode*)parseNegation;        // negation    = NOT negation | term | LPAR formula RPAR
- (NyayaNode*)parseTerm;            // term        = identifier [ LPAR RPAR | LPAR tuple RPAR ]
- (NSArray*)parseTuple;             // tuple       = formula { COMMA formula }

@end
