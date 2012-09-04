//
//  NyayaBddView.m
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaBddView.h"
#import "UIColor+Nyaya.h"

@interface NyayaBddView () {
    UILabel *bottom;
    UILabel *top;
}

@end

@implementation NyayaBddView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)drawNode:(BddNode*)node at:(CGPoint)pos inContext:(CGContextRef)context offset:(CGSize)offset {
    static const CGFloat arr [] = { 3.0, 6.0, 9.0, 2.0 };
    CGSize nextSize = CGSizeMake(offset.width/2, offset.height);
    
    // draw left branch
    CGContextSetLineWidth(context, 3.0);
    
    CGContextSetLineDash(context, 30.0, arr, 2);
    // CGContextSetStrokeColorWithColor(context, [[UIColor nyWrongColor] CGColor]);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
    
    CGContextMoveToPoint(context, pos.x, pos.y);
    
    if (node.leftBranch.isLeaf) {
        
        if (node.leftBranch.id == 0) CGContextAddLineToPoint(context, bottom.center.x, bottom.center.y);
        else CGContextAddLineToPoint(context, top.center.x, top.center.y);
        CGContextStrokePath(context);
    }
    else {
        CGFloat xoffset = -offset.width;    // draw left branch to the left
        
        if (node.rightBranch.isLeaf && node.rightBranch.id==0)  // but the right branch is drawn to the left
            xoffset *= -1.0;
        
        CGPoint lPos =  CGPointMake(pos.x + xoffset, pos.y + offset.height-offset.width/4.0);
        
        
        CGContextAddLineToPoint(context, lPos.x, lPos.y);
        CGContextStrokePath(context);
        [self drawNode:node.leftBranch at:lPos inContext:context offset:nextSize];
    }
    
    // draw right branch
    CGContextSetLineWidth(context, 3.0);
    CGContextSetLineDash(context, 0.0, nil, 0);

    // CGContextSetStrokeColorWithColor(context, [[UIColor nyRightColor] CGColor]);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
    CGContextMoveToPoint(context, pos.x, pos.y);
    
    if (node.rightBranch.isLeaf) {
        if (node.rightBranch.id == 0) CGContextAddLineToPoint(context, bottom.center.x, bottom.center.y);
        else CGContextAddLineToPoint(context, top.center.x, top.center.y);
        CGContextStrokePath(context);

    }
    else {
        CGFloat xoffset = offset.width; // draw the right branch to the right
        
        if (node.leftBranch.isLeaf && node.rightBranch.id==1)   // but the left branch is drawn to th right
            xoffset *= -1.0;
        
        CGPoint rPos = CGPointMake(pos.x + xoffset, pos.y + offset.height-offset.width/4.0);
        CGContextAddLineToPoint(context, rPos.x, rPos.y);
        CGContextStrokePath(context);
        [self drawNode:node.rightBranch at:rPos inContext:context offset:nextSize];
        
    }
    

    // draw node
    CGContextSetRGBFillColor(context, 1, 1, 1, 0.9);
    
    CGContextSetLineWidth(context, 3.0);
    CGContextAddEllipseInRect(context, CGRectMake(pos.x-21.0, pos.y-21.0,43.0,43.0));
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGSize size = [node.name sizeWithFont:[UIFont systemFontOfSize:23]];
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    
    [node.name drawAtPoint:CGPointMake(pos.x - size.width/2.0, pos.y-size.height/2.0) withFont:[UIFont systemFontOfSize:23]];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    bottom = (UILabel*)[self viewWithTag:1];
    top = (UILabel*)[self viewWithTag:2];
    
    bottom.backgroundColor = [UIColor nyWrongColor];
    top.backgroundColor = [UIColor nyRightColor];
    // self.backgroundColor = [UIColor nyLightGreyColor];
    
    if (!self.bddNode.isLeaf) {
        top.hidden = NO;
        bottom.hidden = NO;
        
        CGPoint pos = CGPointMake(self.frame.size.width/2.0, 45.0);
        
        CGSize offset = CGSizeMake(pos.x / 2.0 - 5.0, (top.center.y - pos.y) / ((CGFloat)self.bddNode.levelCount-1.0));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        
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


@end
