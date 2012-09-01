//
//  UIColor+Nyaya.m
//  Nyaya
//
//  Created by Alexander Maringele on 31.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "UIColor+Nyaya.h"

@implementation UIColor (Nyaya)

+ (UIColor*)nyRightColor {
    static UIColor *_color;
    if (!_color) _color = [UIColor colorWithRed:223.0/255.0 green:245.0/255.0 blue:200.0/255.0 alpha:1.0];
    return _color;
    
}
+ (UIColor*)nyWrongColor {
    static UIColor *_color;
    if (!_color) _color = [UIColor colorWithRed:253.0/255.0 green:179.0/255.0 blue:181.0/255.0 alpha:1.0];
    return _color;
    
}

+ (UIColor*)nyLightGreyColor {
    static UIColor *_color;
    if (!_color) _color = [UIColor colorWithWhite:0.92 alpha:1.0];
    return _color;
}

+ (UIColor*)nyKeyboardBackgroundColor {
    return [self nyLightGreyColor];
    
}

@end
