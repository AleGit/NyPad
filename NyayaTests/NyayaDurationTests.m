//
//  NyayaDurationTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 12.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaDurationTests.h"
#import "NyayaFormula.h"

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
    , @"a+b+c+d+e+f+g+h+i+j+k+l+m+n+p+q+r+s+t"          // calloc: 10485760 = (19+1)*2^19           < 60s   c=524288    <12s (6s)
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
    [self gaugeBlock:[self blockTruthTable] duration:defaultMaxDuration label:@"D"];
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
@end
