//
//  NyPgCanvasView.m
//  Nyaya
//
//  Created by Alexander Maringele on 07.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyPgCanvasView.h"

@implementation NyPgCanvasView

- (void)initWithDefaults {
    self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"kariert"]];
    self.opaque = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initWithDefaults];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/* 
 // gradient does not fit the iOS 7/8 style anymore
- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 1.0, 1.0, 0.35,  // Start color
        1.0, 1.0, 0.0, 0.06 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topleft = CGPointMake(CGRectGetMinX(currentBounds), CGRectGetMinY(currentBounds));
    CGPoint bottomright = CGPointMake(CGRectGetMaxX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, bottomright, topleft, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    
    // CGContextDrawPath(currentContext, kCGPathStroke);
}
 */

@end
