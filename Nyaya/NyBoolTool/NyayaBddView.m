//
//  NyayaBddView.m
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaBddView.h"
#import "UIColor+Nyaya.h"
// #import <QuartzCore/QuartzCore.h>

@interface NyayaBddView () {
    UILabel *bottom;
    UILabel *top;
}

@end

@implementation NyayaBddView

//+(Class)layerClass
//{
//    return [CATiledLayer class];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // UIView uses the existence of -drawRect: to determine if should allow its CALayer
    // to be invalidated, which would then lead to the layer creating a backing store and
    // -drawLayer:inContext: being called.
    // By implementing an empty -drawRect: method, we allow UIKit to continue to implement
    // this logic, while doing our real drawing work inside of -drawLayer:inContext:
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawDiagram:context];
}

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
//{
//    [self drawDiagram:context];
//}

- (void)drawDiagram:(CGContextRef)context {
    // Do all your drawing here. Do not use UIGraphics to do any drawing, use Core Graphics instead.
    bottom = (UILabel*)[self viewWithTag:1];
    top = (UILabel*)[self viewWithTag:2];
    
    bottom.backgroundColor = [UIColor nyWrongColor];
    top.backgroundColor = [UIColor nyRightColor];
    // self.backgroundColor = [UIColor nyLightGreyColor];
    
    if (!self.bddNode.isLeaf) {
        top.hidden = NO;
        bottom.hidden = NO;
        
        CGPoint pos = CGPointMake(self.frame.size.width/2.0, 45.0);
        
        CGSize offset = CGSizeMake(pos.x, (top.center.y - pos.y) / ((CGFloat)self.bddNode.levelCount-1.0));
        
        if (self.bddNode) [self drawNode:self.bddNode at:pos inContext:context offset:offset];
    }
    else if (self.bddNode.id == 0) {
        top.hidden = YES;
        bottom.hidden = NO;
    }
    else if (self.bddNode.id == 1) {
        bottom.hidden = YES;
        top.hidden = NO;
        
    }
    
}

- (void)drawNode:(BddNode*)node at:(CGPoint)pos inContext:(CGContextRef)context offset:(CGSize)offset {
    static const CGFloat arr [] = { 3.0, 6.0, 9.0, 2.0 };
    NSString *text = nil;
    
    if (offset.width>20.0) {
        
        CGFloat leftNodeCount = (CGFloat)[node.leftBranch nodeCount];
        CGFloat rightNodeCount = (CGFloat)[node.rightBranch nodeCount];
        CGFloat nodeCount = leftNodeCount + rightNodeCount;
        
        CGFloat leftFraction = leftNodeCount / nodeCount;
        CGFloat rightFraction = rightNodeCount / nodeCount;
        
        // draw left branch
        CGContextSetLineWidth(context, 3.0);
        CGContextSetLineDash(context, 30.0, arr, 2);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
        CGContextMoveToPoint(context, pos.x, pos.y);
        
        if (node.leftBranch.isLeaf) {
            
            if (node.leftBranch.id == 0) CGContextAddLineToPoint(context, bottom.center.x, bottom.center.y);
            else CGContextAddLineToPoint(context, top.center.x, top.center.y);
            CGContextStrokePath(context);
        }
        else {
            
            CGFloat xoffset = -offset.width * rightFraction;    // draw left branch to the left
            CGSize nextSize = CGSizeMake(offset.width * leftFraction, offset.height);
            if (node.rightBranch.isLeaf && node.rightBranch.id == 0) xoffset *=-1.0;
            CGPoint lPos =  CGPointMake(pos.x + xoffset, pos.y + offset.height);
            
            CGContextAddLineToPoint(context, lPos.x, lPos.y);
            CGContextStrokePath(context);
            [self drawNode:node.leftBranch at:lPos inContext:context offset:nextSize];
        }
        
        // draw right branch
        CGContextSetLineWidth(context, 3.0);
        CGContextSetLineDash(context, 0.0, nil, 0);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
        CGContextMoveToPoint(context, pos.x, pos.y);
        
        if (node.rightBranch.isLeaf) {
            if (node.rightBranch.id == 0) CGContextAddLineToPoint(context, bottom.center.x, bottom.center.y);
            else CGContextAddLineToPoint(context, top.center.x, top.center.y);
            CGContextStrokePath(context);
            
        }
        else{
            
            // CGFloat xoffset = node.leftBranch.isLeaf && node.leftBranch.id == 1 ? -offset.width : offset.width;    // draw  right branch to the right
            CGFloat xoffset = offset.width * leftFraction;    // draw left branch to the left
            CGSize nextSize = CGSizeMake(offset.width * rightFraction, offset.height);
            if (node.leftBranch.isLeaf && node.leftBranch.id == 1) xoffset *=-1.0;
            CGPoint rPos =  CGPointMake(pos.x + xoffset, pos.y + offset.height);
            
            CGContextAddLineToPoint(context, rPos.x, rPos.y);
            CGContextStrokePath(context);
            [self drawNode:node.rightBranch at:rPos inContext:context offset:nextSize];
            
        }
        
        
        // draw node
        CGContextSetRGBFillColor(context, 1, 1, 1, 0.9);
        
        CGContextSetLineWidth(context, 3.0);
        CGContextAddEllipseInRect(context, CGRectMake(pos.x-21.0, pos.y-21.0,43.0,43.0));
        CGContextDrawPath(context, kCGPathEOFillStroke);
        
        text = node.name;
    }
    else text = @"...";
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:23]];
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    
    
    [text drawAtPoint:CGPointMake(pos.x - size.width/2.0, pos.y-size.height/2.0) withFont:[UIFont systemFontOfSize:23]];
}


@end
