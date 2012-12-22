//
//  NyayaDurationTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 12.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaDurationTests.h"
#import "NyayaFormula.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Reductions.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode+Creation.h"

@interface NyayaDurationTests () {
    NSTimeInterval defaultMaxDuration;
    NSArray *inputs;
    
}
@end

@implementation NyayaDurationTests


- (void)setUp {
    inputs = @[
    // @"(a+b+c+d)&(b+c+d+a)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)";
    // @"a+b+c+d+e+f+g+h",@"a+b+c+d+e+f+g+h+a+b+c+d+e+f+g+h",@"a+b+c+d+e+f+g+h+a+b+c+d+e+f+g+h+a+b+c+d+e+f+g+h+a+b+c+d+e+f+g+h",
      @"a"                                              // calloc: 4 = (1+1)*2^1                            c=2
    , @"a+b+c+d+e+f+g+h"                                // calloc: 2304 = (8+1)*2^8                 <  1s   c=256       < 1s
    // , @"a+b+c+d+e+f+g+h+i+j+k+l+m+n+p+q+r+s+t"          // calloc: 10485760 = (19+1)*2^19           < 60s   c=524288    <12s (6s)
    //, @"a+b+c+d+e+f+g+h+i+j+k+l+m+n+p+q+r+s+t+u"        // calloc: 22020096 = (20+1)*2^20           <120s   c=1048576   <25s
    //, @"a+b+c+d+e+f+g+h+i+j+k+l+m+n+p+q+r+s+t+u+v"      // calloc: 46137344 = (21+1)*2^20           crash   c=2097152   <70s (54s)
    

    //, @"a+b+c+d+e+f+g+h+i+j+k+l+m+n+p+q+r+s+t+u+v+w+x+y+z"
    //, @"a.b.c.d.e.f.g.h.i.j.k.l.m.n.p.q.r.s.t.u.v.w.x.y.z"
    //, @"a>b>c>d>e>f>g>h>i>j>k>l>m>n>p>q>r>s>t>u>v>w>x>y>z"
    //, @"!a.b+c>d.!e.f.g+h.i.j.k.l.m.n>p.q.r.s.t.u+v.w.x>y.z"*
    ];
    defaultMaxDuration = 0.001;
}
- (void)tearDown {
    inputs = nil;
}

- (id (^)(NSString*))blockFormulaWithString {
    return ^(NSString*input) {
        NyayaFormula *formula = [NyayaFormula formulaWithString:input];
        return formula;
    };
}

- (id (^)(NSString*))blockMakeDescriptions {
    return ^(NSString*input) {
        NyayaFormula *formula = [NyayaFormula formulaWithString:input];
        [formula makeDescriptions];
        return formula;
    };
}

- (id (^)(NSString*))blockOptimizeDescriptions {
    return ^(NSString*input) {
        NyayaFormula *formula = [NyayaFormula formulaWithString:input];
        [formula optimizeDescriptions];
        return formula;
    };
}

- (id (^)(NSString*))blockTruthTable {
    return ^(NSString*input) {
        NyayaFormula *formula = [NyayaFormula formulaWithString:input];
        return [formula truthTable:YES];
    };
}

- (void)testDuration {
    //[self gaugeBlock:[self blockFormulaWithString] duration:defaultMaxDuration label:@"A"];
    //[self gaugeBlock:[self blockMakeDescriptions] duration:4*defaultMaxDuration label:@"B"];
    //[self gaugeBlock:[self blockOptimizeDescriptions] duration:6*defaultMaxDuration label:@"C"];
    [self gaugeBlock:[self blockTruthTable] duration:3*defaultMaxDuration label:@"D"];
}

- (void)gaugeBlock:(id (^)(NSString *input))block
          duration:(NSTimeInterval)maxDuration
             label:(NSString*)label
{
    NSDate *begin = nil;
    NSDate *end = nil;
    NSTimeInterval duration;
    for (NSString *input in inputs) {
        begin = [NSDate date];
        id result = block(input);
        end = [NSDate date];
        duration = [end timeIntervalSinceDate:begin];
        STAssertNotNil(result, input);
        STAssertTrue(duration < maxDuration, @"%3f %@", duration, label);
    }
}

- (void)testBddCreation {
    NSUInteger index = 0;
    for (NSString *input in @[@"a"
         ,@"a+b.c+!d+e.f+g+!h+i+j.k+m+n+(a+(b+c).e+!d+e+f.g+h+i+j)+k+m+n" // tautology
         ,@"!(a+b.c+!d+e.f+g+!h+i+j.k+m+n+(a+(b+c).e+!d+e+f.g+h+i+j)+k+m+n)" // contradiction
         // ,@"!a+b.c+d+e.f.g+h+i.!j.k +l.m.n.o"
         // ,@"!a^b.c+d^e.f.g+h^i.!j.k +l^m^n^o"
        
         //, @"a+b.c.d+e.f+g.h+i.j+k.l+m.n+o.p+q.r+s.t+u.v+w" // crash
         //, @"a+b.c.d+e.f+g.h+i.j+k.l+m.n+o.p+q.r+s.t+u.v+w.x" // crash
         //, @"a+b.c.d+e.f+g.h+i.j+k.l+m.n+o.p+q.r+s.t+u.v+w.x+y" //  Request for large capacity 33554432 = 2^25
         // , @"a+b.c.d+e.f+g.h+i.j+k.l+m.n+o.p+q.r+s.t+u.v+w.x+y.z" // Request for large capacity 67108864 = 2^26
         // , @"a+b&c&d+e&f+g&h+i&j+k&l+m&n+o&p+q&r+s&t+u&v+w&x+y&z"

        //, @"a^b^c^d^e^f^g^h^i^j^k^l^m^n^o^p^q^r^a^b^c^d^e^f^g^h^i^j^k^l^m^n^o^p^q^r^s"
         ]) {
        NyayaFormula *formula = [NyayaFormula formulaWithString:input];
        
        NSDate *begin = [NSDate date];
        NSMutableSet *set = [[[formula syntaxTree:NO] setOfVariables] mutableCopy];
        NSArray *varibles = [set allObjects];
        // BddNode *bdd0 = [formula OBDD:YES];
        NyayaNode *node = [formula syntaxTree:NO];
        node = [node reduce:NSIntegerMax];
        node = [node substitute:set];
        
        NSDate *t0 = [NSDate date];
        BddNode *bdd0 = [BddNode obddWithNode:node order:varibles reduce:YES];
        NSTimeInterval duration0 = [[NSDate date] timeIntervalSinceDate:begin];
        NSLog(@"d0:%f (%f) %@", duration0, [t0 timeIntervalSinceDate:begin], [node description]);
        
        if (index !=1 && index != 2) STAssertEquals(bdd0.height, [varibles count]+1, nil);
        else STAssertEquals(bdd0.height, (NSUInteger)1, nil);
        /*
        begin = [NSDate date];
        TruthTable *tTable = [formula truthTable:YES];
        BddNode *bdd1 = [BddNode bddWithTruthTable:tTable reduce:YES];
        NSTimeInterval duration1 = [[NSDate date] timeIntervalSinceDate:begin];
        
        STAssertFalse(bdd0 == bdd1, nil);
        STAssertTrue(duration0 != duration1, @"d0:%f d1:%f %@", duration0, duration1,input);
        NSLog(@"d1:%f %@ co=%u ta=%u sa=%u", duration1,input, tTable.isContradiction, tTable.isTautology, tTable.isContradiction);
         */
        index++;
    }
    
}

- (void)testXorDervivations {
    NyayaNode *formula = nil;
    for (NSString *atom in @[@"a", @"b",@"c",@"e",@"f",@"g",@"h"//,@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u"
         ]) {
        if (!formula) formula = [NyayaNode atom:atom];
        else formula = [NyayaNode xdisjunction:formula with:[NyayaNode atom: atom]];
        NyayaNode *imf = [formula deriveImf:NSIntegerMax];
        NyayaNode *nnf = [imf deriveNnf:NSIntegerMax];
        NyayaNode *cnf = [nnf deriveCnf:NSIntegerMax];
        NSLog(@"%@ %7u %7u %7u %7u %7u", atom, [[formula setOfVariables] count], [formula length], [imf length], [nnf length], [cnf length]);
        
        

    }
    
    NSString *cnf7 = @"((((((a + (! b + (! c + (! d + (! e + (! f + ! g)))))) & (! a + (b + (! c + (! d + (! e + (! f + ! g))))))) & ((a + (! b + (c + (! d + (! e + (! f + ! g)))))) & (! a + (b + (c + (! d + (! e + (! f + ! g)))))))) & (((a + (! b + (! c + (d + (! e + (! f + ! g)))))) & (! a + (b + (! c + (d + (! e + (! f + ! g))))))) & ((a + (! b + (c + (d + (! e + (! f + ! g)))))) & (! a + (b + (c + (d + (! e + (! f + ! g))))))))) & ((((a + (! b + (! c + (! d + (e + (! f + ! g)))))) & (! a + (b + (! c + (! d + (e + (! f + ! g))))))) & ((a + (! b + (c + (! d + (e + (! f + ! g)))))) & (! a + (b + (c + (! d + (e + (! f + ! g)))))))) & (((a + (! b + (! c + (d + (e + (! f + ! g)))))) & (! a + (b + (! c + (d + (e + (! f + ! g))))))) & ((a + (! b + (c + (d + (e + (! f + ! g)))))) & (! a + (b + (c + (d + (e + (! f + ! g)))))))))) & (((((a + (! b + (! c + (! d + (! e + (f + ! g)))))) & (! a + (b + (! c + (! d + (! e + (f + ! g))))))) & ((a + (! b + (c + (! d + (! e + (f + ! g)))))) & (! a + (b + (c + (! d + (! e + (f + ! g)))))))) & (((a + (! b + (! c + (d + (! e + (f + ! g)))))) & (! a + (b + (! c + (d + (! e + (f + ! g))))))) & ((a + (! b + (c + (d + (! e + (f + ! g)))))) & (! a + (b + (c + (d + (! e + (f + ! g))))))))) & ((((a + (! b + (! c + (! d + (e + (f + ! g)))))) & (! a + (b + (! c + (! d + (e + (f + ! g))))))) & ((a + (! b + (c + (! d + (e + (f + ! g)))))) & (! a + (b + (c + (! d + (e + (f + ! g)))))))) & (((a + (! b + (! c + (d + (e + (f + ! g)))))) & (! a + (b + (! c + (d + (e + (f + ! g))))))) & ((a + (! b + (c + (d + (e + (f + ! g)))))) & (! a + (b + (c + (d + (e + (f + ! g))))))))))) & ((((((a + (! b + (! c + (! d + (! e + (! f + g)))))) & (! a + (b + (! c + (! d + (! e + (! f + g))))))) & ((a + (! b + (c + (! d + (! e + (! f + g)))))) & (! a + (b + (c + (! d + (! e + (! f + g)))))))) & (((a + (! b + (! c + (d + (! e + (! f + g)))))) & (! a + (b + (! c + (d + (! e + (! f + g))))))) & ((a + (! b + (c + (d + (! e + (! f + g)))))) & (! a + (b + (c + (d + (! e + (! f + g))))))))) & ((((a + (! b + (! c + (! d + (e + (! f + g)))))) & (! a + (b + (! c + (! d + (e + (! f + g))))))) & ((a + (! b + (c + (! d + (e + (! f + g)))))) & (! a + (b + (c + (! d + (e + (! f + g)))))))) & (((a + (! b + (! c + (d + (e + (! f + g)))))) & (! a + (b + (! c + (d + (e + (! f + g))))))) & ((a + (! b + (c + (d + (e + (! f + g)))))) & (! a + (b + (c + (d + (e + (! f + g)))))))))) & (((((a + (! b + (! c + (! d + (! e + (f + g)))))) & (! a + (b + (! c + (! d + (! e + (f + g))))))) & ((a + (! b + (c + (! d + (! e + (f + g)))))) & (! a + (b + (c + (! d + (! e + (f + g)))))))) & (((a + (! b + (! c + (d + (! e + (f + g)))))) & (! a + (b + (! c + (d + (! e + (f + g))))))) & ((a + (! b + (c + (d + (! e + (f + g)))))) & (! a + (b + (c + (d + (! e + (f + g))))))))) & ((((a + (! b + (! c + (! d + (e + (f + g)))))) & (! a + (b + (! c + (! d + (e + (f + g))))))) & ((a + (! b + (c + (! d + (e + (f + g)))))) & (! a + (b + (c + (! d + (e + (f + g)))))))) & (((a + (! b + (! c + (d + (e + (f + g)))))) & (! a + (b + (! c + (d + (e + (f + g))))))) & ((a + (! b + (c + (d + (e + (f + g)))))) & (! a + (b + (c + (d + (e + (f + g)))))))))))";
    
    NyayaParser *parser7 = [NyayaParser parserWithString:cnf7];
    formula = [parser7 parseFormula];
    NSLog(@"%7u", [formula length]);
}
@end
