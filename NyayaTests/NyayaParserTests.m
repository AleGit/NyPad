//
//  NyayaParserTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaParserTests.h"
#import "NyayaParser.h"

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
                  
                  @"a ∨ b ∨ c"      , @"(((a∨b∨c)))",
                  @"a ∨ b ∨ c"      , @"(a∨b)∨c",
                  @"a ∨ b ∨ c"    , @"a∨(b∨(c))",
                  
                  @"a ∧ b ∧ c"      , @"(((a∧b∧c)))",
                  @"a ∧ b ∧ c"      , @"(a∧b)∧c",
                  @"a ∧ b ∧ c"    , @"a∧(b∧(c))",
                  
                  @"(a ∧ ¬b) ∨ c"      , @"a∧!b∨c",
                  @"(a ∨ ¬b) ∧ c"      , @"a∨!b∧c",
                  
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
    NyayaParser *parser = [[NyayaParser alloc] initWithString:@"a"];
    
    
    [_testCases enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key=%@ obj=%@", key, obj);
        [parser resetWithString:key];
        NyayaNode *node = [parser parseFormula];
        
        NSString *d = [node description];
        
        STAssertEqualObjects(obj, d, [d commonPrefixWithString:(NSString*)obj options:NSLiteralSearch]);
        
    }];
    
}

@end
