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

- (id)formulaWithString:(NSString*)input {
    NyayaFormula *formula = [NyayaFormula formulaWithString:input];
    return formula;
}

- (id)makeDescriptions:(NSString*)input {
    NyayaFormula *formula = [NyayaFormula formulaWithString:input];
    [formula makeDescriptions];
    return formula;
}

- (id)optimizeDescriptions:(NSString*)input {
    NyayaFormula *formula = [NyayaFormula formulaWithString:input];
    [formula optimizeDescriptions];
    return formula;
}

- (void)testDuration {
    [self runDurationTest:@selector(formulaWithString:) maxDuration: defaultMaxDuration];
    [self runDurationTest:@selector(makeDescriptions:) maxDuration: 4*defaultMaxDuration];
    [self runDurationTest:@selector(optimizeDescriptions:) maxDuration: 8*defaultMaxDuration];
}


- (void)runDurationTest:(SEL)sel maxDuration:(NSTimeInterval)maxDuration {
    NSDate *begin = nil;
    NSDate *end = nil;
    NSTimeInterval duration;
    for (NSString *input in inputs) {
        begin = [NSDate date];
        id result = [self performSelector:sel withObject:input];
        end = [NSDate date];
        duration = [end timeIntervalSinceDate:begin];
        STAssertNotNil(result, input);
        STAssertTrue(duration < maxDuration, input); // less than a millisecond
    }
    
}
@end
