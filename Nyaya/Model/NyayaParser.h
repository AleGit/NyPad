//
//  NyayaParser.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

enum { NyayaParserStateInput = 1, 
    NyayaParserStateSequence, NyayaParserStateFormula, NyayaParserStateJunction, NyayaParserStateNegation, NyayaParserStateTerm, NyayaParserStateTuple,
    NyayaParserStateFinished
};
typedef NSUInteger NyayaParserState;

enum { 
    NyayaErrorNoToken = 1, 
    NyayaErrorNoIdentifier=2, 
    NyayaErrorNoLeftParenthesis=4, 
    NyayaErrorNoRightParenthesis=8,
    NyayaErrorNoNegation=16,
    NyayaErrorNoBinaryConnector=32
};
typedef NSUInteger NyayaErrorState;


@class NyayaNode;

@interface NyayaParser : NSObject

@property (readonly) NSString* input;
@property (readonly) NSArray* tokens;
@property (readonly) NyayaErrorState firstErrorState;

- (void)resetWithString:(NSString*)input;
- (id)initWithString:(NSString*)input;

- (BOOL)hasErrors;
- (NSString*)errorDescriptions;

- (NSArray*)parseSequence;   // sequence    = formula   { ";" formula }
- (NyayaNode*)parseFormula;  // formula     = junction  [ ( "→" | "↔" ) formula }
- (NyayaNode*)parseJunction; // junction    = negation  { ( "∨" | "∧" ) negation }
- (NyayaNode*)parseNegation; // negation    = "¬" negation | term | "(" formula ")"
- (NyayaNode*)parseTerm;     // term        = identifier [ tuple ]
- (NSArray*)parseTuple;      // tuple       = "(" formula { "," formula } ")"

@end
