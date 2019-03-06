//
//  NyayaBinaryDecisionView.m
//  Nyaya
//
//  Created by Alexander Maringele on 12.01.13.
//  Copyright (c) 2013 private. All rights reserved.
//

#import "BinaryTreeView.h"

@implementation BinaryTreeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

const NSInteger b=5;
const NSInteger r = 20;
const NSInteger dy = 55;

- (void)drawBddNode:(BddNode*)bddNode rect:(CGRect)rect context:(CGContextRef) context{
    static const CGFloat arr [] = { 3.0, 6.0, 9.0, 2.0 };
    
    if (bddNode.isLeaf) return; // do not draw decisions
    
    
    CGRect leftRect = CGRectMake(rect.origin.x, rect.origin.y + dy, rect.size.width/2, rect.size.height-dy);
    CGRect rightRect = CGRectMake(CGRectGetMidX(rect), rect.origin.y + dy, rect.size.width/2, rect.size.height-dy);
    
    // draw left branch
    CGContextSetLineDash(context, 30.0, arr, 2);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
    CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect) + b + r);
    CGContextAddLineToPoint(context, CGRectGetMidX(leftRect), CGRectGetMinY(leftRect) + b + r);
    CGContextStrokePath(context);
    
    
    // draw right branch
    CGContextSetLineDash(context, 0.0, nil, 0);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
    CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect) + b + r);
    CGContextAddLineToPoint(context, CGRectGetMidX(rightRect), CGRectGetMinY(rightRect) + b + r);
    CGContextStrokePath(context);
    
    [self drawBddNode:bddNode.leftBranch rect: leftRect context:context];
    [self drawBddNode:bddNode.rightBranch rect: rightRect context:context];
    
    // draw node
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextAddEllipseInRect(context, CGRectMake(rect.origin.x + rect.size.width/2 -r, b + rect.origin.y ,2*r,2*r));
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.9);
    UIGraphicsPushContext(context);
    UIFont *font = [UIFont systemFontOfSize:23];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = [bddNode.name sizeWithAttributes:attributes];
    CGPoint point = CGPointMake(CGRectGetMidX(rect)-size.width/2.0, CGRectGetMinY(rect)+b+r-size.height/2.0);
    [bddNode.name drawAtPoint: point withAttributes:attributes];
    UIGraphicsPopContext();    
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!self.bddNode) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBddNode:_bddNode rect:rect context:context];
    
    
}


@end
