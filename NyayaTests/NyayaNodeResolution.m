//
//  NyayaNodeResolution.m
//  Nyaya
//
//  Created by Alexander Maringele on 18.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNodeResolution.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "NyayaNode+Derivations.h"

@interface NSArray (NNRT) 
- (NSString*)myDescription;
@end

@interface NSSet (NNRT) 
- (NSString*)myDescription;
@end

@interface NyayaNodeResolution () {
    
    NSDictionary *_testBasics;
}


@end

enum { INPUT, AST, IMF, NNF, CNF, DNF, CDS, DCS };



@implementation NSArray (NNRT) 
- (NSString*)myDescription {
    NSMutableArray *array = [NSMutableArray array];
    for (NSSet *set in self) {
        [array addObject:[set myDescription]];
    }
    
    return [NSString stringWithFormat:@"[%@]", [array componentsJoinedByString:@", "]];

    
}
@end

@implementation NSSet (NNRT) 
- (NSString*)myDescription {
    NSString *result = [NSString stringWithFormat:@"{%@}", [[self allObjects] componentsJoinedByString:@","]];
    NSLog(@"RESULT: %@",result);
    return result;
}
@end

@implementation NyayaNodeResolution

- (void)setUp
{
    [super setUp];
    
    _testBasics = [NSDictionary dictionaryWithObjectsAndKeys:
                  // disjunctions
                  
                  [NSArray arrayWithObjects:
                   @"(a∨b)∧(¬b∨c)", // parse
                   @"(a ∨ b) ∧ (¬b ∨ c)", // ast
                   @"(a ∨ b) ∧ (¬b ∨ c)", // imf
                   @"(a ∨ b) ∧ (¬b ∨ c)", // nnf
                   @"(a ∨ b) ∧ (¬b ∨ c)", // cnf
                   @"(a ∧ ¬b) ∨ (a ∧ c) ∨ ((b ∧ ¬b) ∨ (b ∧ c))", // dnf
                   @"[{a,b}, {¬b,c}]", // cds
                   @"[{a,¬b}, {a,c}, {b,¬b}, {b,c}]", // dcs
                   nil], @"B 1", 
                  
                  
                  
                  
                  nil]; // end of dictionary
    
}

- (void)tearDown 
{

    _testBasics = nil;
    [super tearDown];
}



- (void)testBasics {

    [_testBasics enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSArray* obj, BOOL *stop) {
        NyayaParser *parser = [[NyayaParser alloc ] initWithString:[obj objectAtIndex:INPUT]];
        NyayaNode *astp = [parser parseFormula];
        NyayaNode *imfp = [astp imf];
        NyayaNode *nnfp = [imfp imf];
        NyayaNode *cnfp = [imfp nnf];
        NyayaNode *dnfp = [imfp dnf];
        NSArray *cdsp = [cnfp conjunctionOfDisjunctions];
        NSArray *dcsp = [dnfp disjunctionOfConjunctions];
        
        STAssertEqualObjects([astp description], [obj objectAtIndex:AST], nil);
        STAssertEqualObjects([imfp description], [obj objectAtIndex:IMF], nil);
        STAssertEqualObjects([nnfp description], [obj objectAtIndex:NNF], nil);
        STAssertEqualObjects([cnfp description], [obj objectAtIndex:CNF], nil);
        STAssertEqualObjects([dnfp description], [obj objectAtIndex:DNF], nil);
        
        NSLog(@"%@\n%@", [cdsp myDescription], [dcsp myDescription]);
        
        
        STAssertEqualObjects([cdsp myDescription], [obj objectAtIndex:CDS], nil);
        STAssertEqualObjects([dcsp myDescription], [obj objectAtIndex:DCS], nil);
        
        
        
    }];
}

@end
