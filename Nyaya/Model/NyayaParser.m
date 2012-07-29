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

@interface NyayaParser () {
    NSUInteger _index;
    NSInteger _level;
    NSString* _token;
    NSMutableArray* _errors;
}
@end

@implementation NyayaParser

@synthesize input = _input;
@synthesize tokens = _tokens;
@synthesize firstErrorState = _errorState;

+ (id)parserWithString:(NSString*)input {
    return [[NyayaParser alloc]initWithString:input];
}

- (id)initWithString:(NSString*)input {
    self = [super init];
    if (self) {
        _input = input;
        _index = 0;
        _level = 0;
        _errorState = NyayaUndefined;
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
                                  regularExpressionWithPattern:NYAYA_TOKENS // @"(¬|!)|(∧|&)|(∨|\\|)|(→|>)|(↔|<>)|\\(|\\)|,|;|\\w+"
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
    if (_errorState == NyayaUndefined) {
        _errorState = errorState;   // first error
    }
    
    NSUInteger _idx = _index+1;
    
    NSString* description = [NSString stringWithFormat:@"%@::%@::%@::%d",
                             [[_tokens subarrayWithRange:NSMakeRange(0, _index)] componentsJoinedByString:@""],
                             _token ? _token : @" ",
                             _idx < [_tokens count] ? [[_tokens subarrayWithRange:NSMakeRange(_idx, [_tokens count]-_idx)] componentsJoinedByString:@""] : @"",
                             errorState];
    [_errors addObject:description];
}

- (BOOL)hasErrors {
    return [_errors count] > 0;
}

- (NSString*)errorDescriptions {
    return [_errors componentsJoinedByString:@"•"];
}


- (NSArray*)parseSequence {   // sequence    = [identifier "=" ] formula   { ";" [identifier "=" ] formula }
    return nil;
    
}
    
- (NyayaNode*)parseFormula {  // formula     = junction  [ ( "→" | "↔" ) formula }
    NyayaNode *result;
    _level++;
    
    if (_token) {
        result = [self parseJunction];      // consumes junction
        
        if ([_token isImplicationToken]) {
            [self nextToken]; // consume ">"
            result = [NyayaNode implication:result with:[self parseFormula]];
        }
        else if ([_token isBiconditionToken]) {
            
            [self nextToken]; // consume "<>"
            result = [NyayaNode bicondition:result with:[self parseFormula]];
        }
    }
    else {
        [self addErrorDescription: NyayaErrorNoToken];
    }
    
    _level--;
    if (_level == 0 && _token && ![_errors count]) [self addErrorDescription:NyayaErrorUnusedToken];
    return result;
    
}
    
- (NyayaNode*)parseJunction { // junction    = negation  { ( "∨" | "∧" ) negation }
    NyayaNode *junction = [self parseNegation];
    
    while ([_token isJunctionToken]) {
        NSString *tok = _token;
        
        
        NyayaNode *node = nil; 
        while (!node && _token) {
            [self nextToken];
            node = [self parseNegation];
        }
        
        
        
         
        if (node && [tok isDisjunctionToken]) {
            
            junction = [NyayaNode disjunction:junction with:node];
        }
        else if (node)
            junction = [NyayaNode conjunction:junction with:node];
        
        // if (!node) break;
        
    }
    
    if ([_token isNegationToken] || [_token isIdentifierToken]) [self addErrorDescription:NyayaErrorNoBinaryConnector];
        
    if (_token)
       
        NSLog(@"token: %@", _token);     
    
    return junction;
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
        
        if (tuple) result = [NyayaNode function:identifier with:tuple];
        else result = [NyayaNode atom:identifier];
    }
    else {
        [self addErrorDescription: NyayaErrorNoIdentifier];    }
    
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
