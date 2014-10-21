//
//  NyayaParserTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaParserTests.h"
#import "NyayaParser.h"
#import "NyayaNode.h"

@interface NyayaParserTests () {
    NSDictionary *_testCases;
}
@end

@implementation NyayaParserTests

- (void)setUp
{
    [super setUp];
    
    _testCases = [NSDictionary dictionaryWithObjectsAndKeys: 
                  @"a → b → c"      , @"a>(b>c)",
                  @"a → b → c"      , @"(a>b>c)",
                  @"(a → b) → c"    , @"((a>b)>c)",
                  
                  
                  @"a ↔ b ↔ c"      , @"a<>(b<>c)",
                  @"a ↔ b ↔ c"      , @"(a<>b<>c)",
                  @"(a ↔ b) ↔ c"    , @"((a<>b)<>c)",
                  
                  @"a ∨ b ∨ c"      , @"(((a∨b∨c)))",
                  @"a ∨ b ∨ c"      , @"(a∨b)∨c",
                  @"a ∨ (b ∨ c)"    , @"a∨(b∨(c))",
                  
                  @"a ∧ b ∧ c"      , @"(((a∧b∧c)))",
                  @"a ∧ b ∧ c"      , @"(a∧b)∧c",
                  @"a ∧ (b ∧ c)"    , @"a∧(b∧(c))",
                  
                  @"(a ∧ ¬b) ∨ c"      , @"a∧!b∨c",
                  @"a ∨ (¬b ∧ c)"      , @"a∨!b∧c",      // '∧' > '∨' [v.2]
                  
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b)&(!a|c|a)&(!a|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"((a)|b)&(!a|c|a)&(!a|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b) &(! a|c|a)&(!a|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b)&(!a| c|a)&(!a|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b)&(!a|c|a)&(!a|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b)&(!a|c| a)&(!a|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b)&(!a|c|a) &(!a|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b)&(!a|c|a)&(!(a)|!b|c)",
                  @"(a ∨ b) ∧ (¬a ∨ c ∨ a) ∧ (¬a ∨ ¬b ∨ c)", @"(a|b)&(!a|c|a)&(!a|!b| c)",
                  
                  @"f(a,a ∨ b,a ∨ ¬c,a ∨ b) → x → a ∧ b", @"f(a,a|b,a|¬c,a∨b)→x>a&b", 
                  
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a&b)|(!a&c&a)|(!a&!b&c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"((a)&b)|(!a&c&a)|(!a&!b&c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a&b) |(! a&c&a)|(!a&!b & c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a & b)|(!a& c&a)|(!a&!b&c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a&b)|(!a&c&a)|(!a&!b&c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a&b)|(!a&c& a)|(!a&!b&c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a&b)|(!a&c&a) |(!a&!b&c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a&b)|(!a&c&a)|(!(a)&!b&c)",
                  @"(a ∧ b) ∨ (¬a ∧ c ∧ a) ∨ (¬a ∧ ¬b ∧ c)", @"(a&b)|(!a&c&a)|(!a&!b& c)",

            
                  nil];
    
}

- (void)tearDown
{
    _testCases = nil;
    
    [super tearDown];
}


- (void)testParseFormula {
    
    
    [_testCases enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key=%@ obj=%@", key, obj);
        NyayaParser *parser = [NyayaParser parserWithString:key];
        NyayaNode *node = [parser parseFormula];
        
        NSString *d = [node description];
        
        XCTAssertEqualObjects(obj, d, @"%@",[d commonPrefixWithString:(NSString*)obj options:NSLiteralSearch]);
        
    }];
    
}

@end
