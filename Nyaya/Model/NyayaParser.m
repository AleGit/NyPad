//
//  NyayaParser.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaParser.h"
#import "NyayaNode.h"
#import "NSString+NyayaToken.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode_Cluster.h"

@interface NyayaParser () {
    NSUInteger _index;
    NSInteger _level;
    NSString* _token;
    NSMutableArray* _errors;
}
@end

@implementation NyayaParser

+ (id)parserWithString:(NSString*)input {
    return [[NyayaParser alloc]initWithString:input];
}

- (id)initWithString:(NSString*)input {
    self = [super init];
    if (self) {
        _input = input;
        _index = 0;
        _level = 0;
        _firstErrorState = NyayaUndefined;
        _errors = [NSMutableArray array];
        
        [self tokenize];
        
        if ([_tokens count] > 0)
            _token = [_tokens objectAtIndex:_index];
        else _token = nil;
    }
    
    return self;
}


- (BOOL)nextToken {
    _index++;
    if (_index < [_tokens count]) {
        _token = [_tokens objectAtIndex:_index];
        return YES;
    }
    else _token = nil;
    return NO;
}

- (void)tokenize {
    NSMutableArray *tokens = [NSMutableArray array];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern: // NYAYA_TOKENS
                                  NSLocalizedString(@"NYAYA_TOKENS_PATTERN", nil)
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

- (void)addErrorDescription:(NyayaErrorState)errorState {
    if (_firstErrorState == NyayaUndefined) {
        _firstErrorState = errorState;   // first error
    }
    
    NSUInteger _idx = _index+1;
    NSString* description = nil;
    if (errorState != NyayaErrorFunctionNotSupported) {
        description = [NSString stringWithFormat:@"%@::%@::%@::%d",
                             [[_tokens subarrayWithRange:NSMakeRange(0, _index)] componentsJoinedByString:@""],
                             _token ? _token : @" ",
                             _idx < [_tokens count] ? [[_tokens subarrayWithRange:NSMakeRange(_idx, [_tokens count]-_idx)] componentsJoinedByString:@""] : @"",
                             errorState];
    }
    else {
        description = [NSString stringWithFormat:@"%u",errorState];
    }
    [_errors addObject:description];
}

- (BOOL)hasErrors {
    return [_errors count] > 0;
}

- (NSString*)errorDescriptions {
    return [_errors componentsJoinedByString:@"•"];
}
    
- (NyayaNode*)parseFormula {
    NyayaNode* result = [self parseEntailment];
    if (_level == 0 && _token && ![_errors count]) [self addErrorDescription:NyayaErrorUnusedToken];
    
    // if (!result) result = [[NyayaNode alloc] init];
    return result;
}

- (NyayaNode*)parseEntailment {
    NyayaNode* result = nil;
    _level++;
    result = [self parseSequence];
    if ([_token isEntailment]) {
        [self nextToken];
        result = [NyayaNode entailment:result with:[self parseEntailment]];
    }
    
    _level--;
    return result;
    
}

- (NyayaNode*)parseSequence {
    NyayaNode* result = nil;
    _level++;
    result = [self parseBicondition];
    while ([_token isSemicolon]) {
        [self nextToken];                   // consumes ; token
        result = [NyayaNode sequence:result with:[self parseBicondition]];
    }
    _level--;
    return result;
}

- (NyayaNode*)parseBicondition {
    NyayaNode* result = nil;
    _level++;
    
    // [v2] bicondition = disjunction [ BIC bicondition ]
    // [v3] bicondition = xdisjunction [ BIC bicondition ]
    // [v3.1] bicondition = implication [ BIC bicondition ]
    result = [self parseImplication];       // consumes xdisjunction
    if ([_token isBiconditionToken]) {
        [self nextToken];                   // consumes BIC token
        result = [NyayaNode bicondition:result with:[self parseBicondition]];
    }
    
    _level--;
    return result;
}

- (NyayaNode*)parseImplication {
    NyayaNode* result = nil;
    _level++;

    // [v2] implication = bicondition [ IMP implication ]
    // [v3.1] implication = xdisjunction [ IMP implication ]
    result = [self parseXdisjunction];       // consumes biconditon
    if ([_token isImplicationToken]) {
        [self nextToken];                   // consumes IMP token
        result = [NyayaNode implication:result with:[self parseImplication]];
    }
    
    _level--;
    return result;
}

- (NyayaNode*)parseXdisjunction {
    NyayaNode *result;
    _level++;
    
    // [v.2] formula = implication { XOR implication }
    // [v.3] xdisjunction = disjunction { XOR disjunction }
    result = [self parseDisjunction];       // consumes disjunction
    while ([_token isXdisjunctionToken]) {
        [self nextToken];                   // consumes XOR token
        result = [NyayaNode xdisjunction:result with:[self parseDisjunction]];
    }
    
    _level--;
    if (_level == 0 && _token && ![_errors count]) [self addErrorDescription:NyayaErrorUnusedToken];
    return result;
    
}

- (NyayaNode*)parseDisjunction {
    NyayaNode* result = nil;
    _level++;
    
    // [v.2] disjunction = conjunction { OR conjunction }
    result = [self parseConjunction];       // consumes conjunction
    while ([_token isDisjunctionToken]) {
        [self nextToken];                   // consumes OR token
        result = [NyayaNode disjunction:result with:[self parseConjunction]];
    }
    
    _level--;
    return result;
}

- (NyayaNode*)parseConjunction {
    NyayaNode* result = nil;
    _level++;
    
    // [v.2] conjunction = negation { AND negation }    
    result = [self parseNegation];       // consumes conjunction
    while ([_token isConjunctionToken]
           // || [_token isIdentifierToken] // a b = a & b
           ) {
        // if ([_token isConjunctionToken])
        [self nextToken];                   // consumes AND token
        // else write warning 'a b' was interpreted as 'a & b'
        result = [NyayaNode conjunction: result with:[self parseNegation]];
    }
    
    if ([_token isNegationToken] || [_token isIdentifierToken]) [self addErrorDescription:NyayaErrorNoBinaryConnector];
    
    _level--;
    return result;
}

// negation    = "¬" negation | "(" formula ")" | term 
- (NyayaNode*)parseNegation { 
    NyayaNode *result = nil;
    
    if ([_token isNegationToken]) {
        [self nextToken];       // consume "¬"
        return [NyayaNode negation:[self parseNegation]];
        
    }
    else if ([_token isLeftParenthesis]) {
        [self nextToken];       // consume "("
        result = [self parseFormula];
        
        if ([_token isRightParenthesis]) 
            [self nextToken];   // consume ")"
        else {
            [self addErrorDescription:NyayaErrorNoRightParenthesis];
        }
    }
    else if ([_token isIdentifierToken]) {
        result = [self parseTerm];
    }
    else if (_token) {
        [self addErrorDescription:NyayaErrorNoNegation|NyayaErrorNoLeftParenthesis|NyayaErrorNoIdentifier];
    }
    else {
        [self addErrorDescription:NyayaErrorNoToken];
    }
    
    return result;
}

// term = identifier [ tuple ]
- (NyayaNode*)parseTerm { 
    NyayaNode *result = nil;
    
    if ([_token isIdentifierToken]) {
        
        NSString *identifier = _token;  // store identifier
        [self nextToken];               // consume identifier
        
        NSArray *tuple = [self parseTuple]; // try to parse optional tuple 
        
        if (tuple) {
            result = [NyayaNode function:identifier with:tuple];
            [self addErrorDescription: NyayaErrorFunctionNotSupported];
        }
        else result = [NyayaNode atom:identifier];
    }
    else {
        [self addErrorDescription: NyayaErrorNoIdentifier];
    }
    
    return result;
}
 
// tuple = "(" formula { "," formula } ")"
- (NSArray*)parseTuple {
    NSMutableArray* result = nil;
    
    
    if ([_token isLeftParenthesis]) {                   // a tuple starts with "("
        
        result = [NSMutableArray array];
        
        [self nextToken];                               // consume "("
        
        while (![_token isRightParenthesis]) {          // a tuple ends with ")"
            NyayaNode *formula = [self parseFormula];
            if (formula) {
                [result addObject:formula];
            }
            
            if ([_token isComma])   {                    // tuple members are separeted by ","
                [self nextToken];                           // consume ","
                if ([_token isRightParenthesis])
                    [self addErrorDescription: NyayaErrorNoNegation|NyayaErrorNoLeftParenthesis|NyayaErrorNoIdentifier];
            }
            else if (![_token isRightParenthesis]) {    // or closed by ")"
                [self addErrorDescription: NyayaErrorNoRightParenthesis];
                break;
            }

        }
        
        [self nextToken];                               // consume "("
    }
         

    
    return [result copy];
}



@end
