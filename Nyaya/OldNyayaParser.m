//
//  NyayaParser.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "OldNyayaParser.h"
#import "OldNyayaNode.h"

@interface NSString (TOKEN) 

- (BOOL)isDisjunction;
- (BOOL)isConjunction;
- (BOOL)isJunction;

@end

@implementation NSString (TOKEN)

- (BOOL)isDisjunction {
    return [self isEqual:@"|"] || [self isEqual:@"∨"];
}
- (BOOL)isConjunction {
    return [self isEqual:@"&"] || [self isEqual:@"∧"];
}
- (BOOL)isJunction {
    return [self isDisjunction] || [self isConjunction];
}

- (BOOL)isNegation {
    return [self isEqual:@"!"] || [self isEqual:@"¬"];
}

@end

enum { sequence, formula, junction, negation, term, tuple };

@interface OldNyayaParser () {
    NSUInteger _index;
}

- (NSArray*)sequence;
- (OldNyayaNode*)formula;
- (OldNyayaNode*)junction;
- (OldNyayaNode*)negation;
- (OldNyayaNode*)term;
- (OldNyayaNode*)identifier;
// - (void) tuple;

- (BOOL)nextToken;
- (NSString*)theToken;
- (void)tokenize;
    
@end

@implementation OldNyayaParser

@synthesize input = _input;
@synthesize tokens = _tokens;
@synthesize sequence = _sequence;

#pragma mark - parser

// SEQUENCE = FORMULA { ";" FORMULA }
// FORMULA = JUNCTION [ ( "→" | "↔" ) FORMULA ]
// JUNCTION = NEGATION { ( "∨" | "∧" ) NEGATION }
// NEGATION = { "¬" } ( TERM | "(" FORMULA ")" )
// TERM = IDENTIFIER [ "(" TUPLE ")" ]
// TUPLE = FORMULA { "," FORMULA }


- (NSArray*)sequence {
    NSMutableArray *sequence = [NSMutableArray array];
    
    while ([self theToken]) {
        OldNyayaNode *formula = [self formula];
        [sequence addObject:formula];
        // check theToken for ";"?
    }
    
    return [sequence copy];
}



- (OldNyayaNode*)formula {
    
    OldNyayaNode *node = [self junction];
    
    if ([[self theToken] isJunction]) {
        OldNyayaNode *junction = [[OldNyayaNode alloc] initWithToken:[self theToken]];
        [self nextToken];
        
        [junction.nodes addObject:node];
        [junction.nodes addObject:[self formula]];
        
        return junction;
        
    }

    return node;    
    
}
- (OldNyayaNode*)junction {
    
    OldNyayaNode *node = [self negation];
    
    return node;
    
}
- (OldNyayaNode*)negation {
    OldNyayaNode *node = [self term];
    
    return node;
    
}
- (OldNyayaNode*)term {
    OldNyayaNode *node = [self identifier];
    
    return node;
    
}
- (OldNyayaNode*)identifier {
    OldNyayaNode *node = [[OldNyayaNode alloc] initWithToken:[self theToken]];
    
    return node;
    
}

- (void) parse: (NSString *)input {
    _input = input;
    [self tokenize];
    _sequence = [self sequence];
}

#pragma mark - lexxer

- (BOOL)nextToken {
    _index++;
    return _index < [_tokens count];
}

- (NSString*)theToken {
    if (_index < [_tokens count]) return [_tokens objectAtIndex:_index];
    else return nil;
    
}

- (void)tokenize {
    _index = (NSUInteger)0;
    
    NSMutableArray *tokens = [NSMutableArray array];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:@"(¬|!)|(∧|&)|(∨|\\|)|(→|>)|↔|\\(|\\)|\\w+"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    [regex enumerateMatchesInString:_input 
                            options:0 
                              range:NSMakeRange(0, [_input length]) 
                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSString *s = [_input substringWithRange:[match range]];
                             [tokens addObject:s];
                         }];
    
    _tokens = [tokens copy];
    
}







@end
