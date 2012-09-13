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
    @"(a+b+c+d)&(b+c+d+a)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)&(d+a+b+c)"
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

- (void)testDuration {
    [self gaugeBlock:[self blockFormulaWithString] duration:defaultMaxDuration label:@"A"];
    [self gaugeBlock:[self blockMakeDescriptions] duration:4*defaultMaxDuration label:@"B"];
    [self gaugeBlock:[self blockOptimizeDescriptions] duration:6*defaultMaxDuration label:@"C"];
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
