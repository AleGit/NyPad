//
//  UIColor+Nyaya.m
//  Nyaya
//
//  Created by Alexander Maringele on 31.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "UIColor+Nyaya.h"

@implementation UIColor (Nyaya)

static CGFloat offset = 20.0;
static CGFloat saturation = 0.15;



+ (UIColor*)nyRed {
    return [UIColor colorWithHue:0.0+offset saturation:saturation brightness:1.0 alpha:1.0];
}

+ (UIColor*)nyGreen {
    return [UIColor colorWithHue:(120.0+offset) / 360.0 saturation:saturation brightness:1.0 alpha:1.0];
}

+ (UIColor*)nyBlue {
    return [UIColor colorWithHue:(240.0+offset) / 360.0 saturation:saturation brightness:1.0 alpha:1.0];
}

+ (UIColor*)nyRightColor {
    return [self nyGreen];
//    static UIColor *_color;
//    if (!_color) _color = [UIColor colorWithRed:223.0/255.0 green:245.0/255.0 blue:200.0/255.0 alpha:1.0];
//    return _color;
    
}
+ (UIColor*)nyWrongColor {
    return [self nyRed];
//    static UIColor *_color;
//    if (!_color) _color = [UIColor colorWithRed:253.0/255.0 green:179.0/255.0 blue:181.0/255.0 alpha:1.0];
//    return _color;
    
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
