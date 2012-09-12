//
//  SenTestCase+NyayaTests.m
//  Nyaya
//
//  Created by Alexander Maringele on 12.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "SenTestCase+NyayaTests.h"

@implementation SenTestCase (NyayaTests)

- (NyayaNode*)nodeWithFormula:(NSString*)input {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:input];
    NyayaNode *node = [parser parseFormula];
    return node;
}


@end
