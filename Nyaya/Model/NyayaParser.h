//
//  NyayaParser.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyayaNode.h"

@interface NyayaParser : NSObject

@property (readonly) NSString* input;
@property (readonly) NSArray* tokens;

- (void)resetWithString:(NSString*)input;
- (id)initWithString:(NSString*)input;

- (NSArray*)parseSequence;   // sequence    = formula   { ";" formula }
- (NyayaNode*)parseFormula;  // formula     = junction  [ ( "→" | "↔" ) formula }
- (NyayaNode*)parseJunction; // junction    = negation  { ( "∨" | "∧" ) negation }
- (NyayaNode*)parseNegation; // negation    = "¬" negation | term | "(" formula ")"
- (NyayaNode*)parseTerm;     // term        = identifier [ "(" ")" | "(" tuple ")" ]
- (NSArray*)parseTuple;      // tuple       = formula { "," formula }

@end
