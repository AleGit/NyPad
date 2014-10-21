//
//  NyayaParserErrorTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 19.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaParserErrorTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"

@interface NyayaParserErrorTests () {
    
    NSArray *_testCases;
}


@end

enum { kTitle, kInput, kOutput, kErrorState, kErrors, kC  }; 

@implementation NyayaParserErrorTests

- (void)setUp
{
    [super setUp];
    
    _testCases = [NSArray arrayWithObjects:                  
                  [NSArray arrayWithObjects:
                   @"EMPTY INPUT", // kTitle
                   @"", // kInput
                   @"nil", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoToken], // kErrorState
                   @":: ::::1", // kErrors
                   nil],
                  
                  [NSArray arrayWithObjects:
                   @"WRONG FIRST TOKEN", // kTitle
                   @",a&b", // kInput
                   @"nil", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoIdentifier|NyayaErrorNoLeftParenthesis|NyayaErrorNoNegation], // kErrorState
                   @"::,::a&b::22", // kErrors
                   nil], 
                  
                  [NSArray arrayWithObjects:
                   @"EMPTY 2-TUPLE", // kTitle
                   @"f(,)&a", // kInput
                   @"f() ∧ a", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoIdentifier|NyayaErrorNoLeftParenthesis|NyayaErrorNoNegation], // kErrorState
                   @"f(::,::)&a::22•f(,::)::&a::22•128", // kErrors
                   nil], 
                  
                  
                  [NSArray arrayWithObjects:
                   @"FIRST HALF EMPTY 2-TUPLE", // kTitle
                   @"f(,a|b)&a", // kInput
                   @"f(a ∨ b) ∧ a", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoIdentifier|NyayaErrorNoLeftParenthesis|NyayaErrorNoNegation], // kErrorState
                   @"f(::,::a|b)&a::22•128", // kErrors
                   nil],
                  
                  
                  
                  [NSArray arrayWithObjects:
                   @"SECOND HALF EMPTY 2-TUPLE", // kTitle
                   @"f(a|b,)&a", // kInput
                   @"f(a ∨ b) ∧ a", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoIdentifier|NyayaErrorNoLeftParenthesis|NyayaErrorNoNegation], // kErrorState
                   @"f(a|b,::)::&a::22•128", // kErrors
                   nil],
                   
                  
                  
                  [NSArray arrayWithObjects:
                   @"no right parenthesis", // kTitle
                   @"f(a&a", // kInput
                   @"f(a ∧ a)", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoRightParenthesis], // kErrorState
                   @"f(a&a:: ::::8•128", // kErrors
                   nil], // kC      
                   
                  
                  [NSArray arrayWithObjects:
                   @"double connect", // kTitle
                   @"a&|!b", // kInput
                   @"(a ∧ ((null))) ∨ ¬b", // kOutput [v.2]
                   [NSNumber numberWithInt:NyayaErrorNoIdentifier|NyayaErrorNoLeftParenthesis|NyayaErrorNoNegation], // kErrorState
                   @"a&::|::!b::22", // kErrors
                   nil],                    
                     

                  
                  [NSArray arrayWithObjects:
                   @"WRONG TUPLES", // kTitle
                   @"f(,a|b)&g(,x,))", // kInput
                   @"f(a ∨ b) ∧ g(x)", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoIdentifier|NyayaErrorNoLeftParenthesis|NyayaErrorNoNegation], // kErrorState
                   @"f(::,::a|b)&g(,x,))::22•128•f(,a|b)&g(::,::x,))::22•f(,a|b)&g(,x,::)::)::22•128", // kErrors
                   nil],
                  
                  [NSArray arrayWithObjects:
                   @"NO BINARY CONNECTOR", // kTitle
                   @"a|b!(x&y)", // kInput
                   @"a ∨ b", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoBinaryConnector], // kErrorState
                   @"a|b::!::(x&y)::32", // kErrors
                   nil],
                                    
                  [NSArray arrayWithObjects:
                   @"NEGATE NOTHING", // kTitle
                   @"!", // kInput
                   @"¬((null))", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoToken], // kErrorState
                   @"!:: ::::1", // kErrors
                   nil], 
                  
                  [NSArray arrayWithObjects:
                  @"DOUBLE NEGATE NOTHING", // kTitle
                  @"!!", // kInput
                  @"¬¬((null))", // kOutput
                  [NSNumber numberWithInt:NyayaErrorNoToken], // kErrorState
                  @"!!:: ::::1", // kErrors
                  nil],

                  
                  [NSArray arrayWithObjects:
                   @"NEGATE AND", // kTitle
                   @"!&", // kInput
                   @"¬((null)) ∧ ((null))", // kOutput [v.2]
                   [NSNumber numberWithInt:NyayaErrorNoIdentifier|NyayaErrorNoLeftParenthesis|NyayaErrorNoNegation], // kErrorState
                   @"!::&::::22•!&:: ::::1", // kErrors
                   nil], 
                  
                  [NSArray arrayWithObjects:
                   @"TWO NEGATIONS", // kTitle
                   @"a & !b!b", // kInput
                   @"a ∧ ¬b", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoBinaryConnector], // kErrorState
                   @"a&!b::!::b::32", // kErrors
                   nil],
                  
                  [NSArray arrayWithObjects:
                   @"TWO IDENTIFIERS", // kTitle
                   @"a & b c", // kInput
                   @"a ∧ b", // kOutput
                   [NSNumber numberWithInt:NyayaErrorNoBinaryConnector], // kErrorState
                   @"a&b::c::::32", // kErrors
                   nil],
                  
                  
                                   
                  [NSArray arrayWithObjects:
                   @"TWO IDENTIFIERS", // kTitle
                   @"a & b )", // kInput
                   @"a ∧ b", // kOutput
                   [NSNumber numberWithInt:NyayaErrorUnusedToken], // kErrorState
                   @"a&b::)::::64", // kErrors
                   nil],
                  /**/
                  // ************************************************************************
                      
                  nil]; // end of array
    
}

- (void)tearDown 
{
    
    _testCases = nil;
    [super tearDown];
}

- (void)testErrorCases {
    /*
    id myblock = ^(NSArray* testCase, NSUInteger idx, BOOL *stop) {
        NyayaParser *parser = [[NyayaParser alloc] initWithString: [testCase objectAtIndex:kInput]];
        [parser parseFormula];
    };
    
    [_testCases enumerateObjectsUsingBlock: myblock ];
    */
    
    [_testCases enumerateObjectsUsingBlock:^(NSArray* testCase, NSUInteger idx, BOOL *stop) {
        NSString *title = [testCase objectAtIndex:kTitle];
        NSString *input = [testCase objectAtIndex:kInput];
        NSString *ast_expected = [testCase objectAtIndex: kOutput];
        if ([ast_expected isEqualToString:@"nil"]) ast_expected = nil;
        // NyayaParserState state_expected = [[testCase objectAtIndex:kState] intValue];
        NyayaErrorState firstErrorState_expected = [[testCase objectAtIndex:kErrorState] intValue];
        NSString* ed_expected = [testCase objectAtIndex:kErrors];
        
        NyayaParser *parser = [[NyayaParser alloc] initWithString: input];
        NyayaNode *node = [parser parseFormula];
        NSString *ast = [node description];
        
        
        XCTAssertEqualObjects(ast, ast_expected, @"%@",title);
        XCTAssertEqual(parser.firstErrorState, firstErrorState_expected, @"%@",title);
        XCTAssertEqualObjects([parser errorDescriptions], ed_expected, @"%@",title);
    } ];
    
    
}

@end
