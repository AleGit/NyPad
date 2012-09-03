//
//  UITextField+Nyaya.m
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "UITextField+Nyaya.h"

@implementation UITextField (Nyaya)

- (void)parenthesize {
    if ([self hasText]) {
        self.text = [NSString stringWithFormat:@"(%@)", self.text];
    }
}

- (void)negate {
    if ([self hasText]) {
        self.text = [NSString stringWithFormat:@"¬(%@)", self.text];
    }
}

@end
