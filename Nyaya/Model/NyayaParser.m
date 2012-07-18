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
    NSString* _token;
}
@end

@implementation NyayaParser

@synthesize input = _input;
@synthesize tokens = _tokens;

- (BOOL)nextToken {
    _index++;
    if (_index < [_tokens count]) {
        _token = [_tokens objectAtIndex:_index];
        return YES;
    }
    return NO;
}

- (void)tokenize {
    NSMutableArray *tokens = [NSMutableArray array];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:@"(¬|!)|(∧|&)|(∨|\\|)|(→|>)|↔|\\(|\\)|,|;|\\w+"
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

- (void)resetWithString:(NSString*)input {
    _input = input;
    _index = 0;
    [self tokenize];
    _token = [_tokens objectAtIndex:_index];
    
}

- (id)initWithString:(NSString*)input {
    self = [super init];
    if (self) {
        [self resetWithString:input];
    }
    
    return self;
}


- (NSArray*)parseSequence {   // sequence    = formula   { ";" formula }
    return nil;
}
    
- (NyayaNode*)parseFormula {  // formula     = junction  [ ( "→" | "↔" ) formula }
    NyayaNode *formula =  [self parseJunction];
    
    if ([_token isImplication]) {
        [self nextToken]; // consume ">"
        return [NyayaNode implication:formula with:[self parseFormula]];
    }
    
    return formula;
    
}
    
- (NyayaNode*)parseJunction { // junction    = negation  { ( "∨" | "∧" ) negation }
    NyayaNode *junction = [self parseNegation];
    
    while ([_token isJunction]) {
        NSString *tok = _token;
        [self nextToken];
         
        if ([tok isDisjunction]) {
            
            junction = [NyayaNode disjunction:junction with:[self parseNegation]];
        }
        else 
            junction = [NyayaNode conjunction:junction with:[self parseNegation]];
        
    }
        
    
    
    
    return junction;
}

// negation    = "¬" negation | term | "(" formula ")"
- (NyayaNode*)parseNegation { 
    if ([_token isNegation]) {
        [self nextToken];
        return [NyayaNode negation:[self parseNegation]];
        
    }
    else if ([_token isLeftParenthesis]) {
        [self nextToken];
        NyayaNode *f = [self parseFormula];
        if ([_token isRightParenthesis]) [self nextToken];
        else NSLog(@"ERROR missing right parenthesis");
        return f;
    }
    else {
        return [self parseTerm];
    }
}

// term = identifier [ tuple ]
- (NyayaNode*)parseTerm {     
    NSString *identifier = _token;
    [self nextToken];
    
    NSArray *tuple = [self parseTuple];
    
    if (tuple) return [NyayaNode function:identifier with:tuple];
    
    return [NyayaNode constant:identifier];
}
 
// tuple = "(" [ formula { "," formula } ] ")"
- (NSArray*)parseTuple {   
    if (![_token isLeftParenthesis]) return nil;
    
    NSMutableArray *ma = [NSMutableArray array];
    
    [self nextToken]; // "(" consumed
    
    while (![_token isRightParenthesis]) {
        NyayaNode *formula = [self parseFormula];
        if (formula) [ma addObject:formula];
        
        if ([_token isComma]) 
            [self nextToken]; // consume ","
        else if (![_token isRightParenthesis]) 
            NSLog(@"parseTuple ERROR");
        
    }
    
    [self nextToken]; // ")" consumed
         

    
    return [ma copy];
}



@end
