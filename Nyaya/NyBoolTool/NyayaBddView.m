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
    CGSize nextSize = CGSizeMake(offset.width/2, offset.height);
    
    CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 0.7);
    CGContextMoveToPoint(context, pos.x, pos.y);
    if (node.leftBranch.isLeaf) {
        
        if (node.leftBranch.id == 0) CGContextAddLineToPoint(context, bottom.center.x, bottom.center.y);
        else CGContextAddLineToPoint(context, top.center.x, top.center.y);
        CGContextStrokePath(context);
    }
    else {
        CGPoint lPos = CGPointMake(pos.x - offset.width, pos.y + offset.height-offset.width/4.0);
        CGContextAddLineToPoint(context, lPos.x, lPos.y);
        CGContextStrokePath(context);
        [self drawNode:node.leftBranch at:lPos inContext:context offset:nextSize];
    }
    
    CGContextMoveToPoint(context, pos.x, pos.y);
    
    
    
    CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.2, 0.7);
    CGContextMoveToPoint(context, pos.x, pos.y);
    if (node.rightBranch.isLeaf) {
        if (node.rightBranch.id == 0) CGContextAddLineToPoint(context, bottom.center.x, bottom.center.y);
        else CGContextAddLineToPoint(context, top.center.x, top.center.y);
        CGContextStrokePath(context);

    }
    else {
        
        CGPoint rPos = CGPointMake(pos.x + offset.width, pos.y + offset.height-offset.width/4.0);
        CGContextAddLineToPoint(context, rPos.x, rPos.y);
        CGContextStrokePath(context);
        [self drawNode:node.rightBranch at:rPos inContext:context offset:nextSize];
        
    }
    

    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextMoveToPoint(context, pos.x, pos.y);
    CGContextAddArc(context, pos.x, pos.y, 25.0, 0, 2.0*M_PI, 0);
    CGContextFillPath(context);
    
    CGSize size = [node.name sizeWithFont:[UIFont systemFontOfSize:23]];
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
    // CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.2, 1.0);
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
    self.backgroundColor = [UIColor nyLightGreyColor];
    CGPoint pos = CGPointMake(self.frame.size.width/2.0, 45.0);
    
    CGSize offset = CGSizeMake(pos.x / 2.0, (top.center.y - pos.y) / ((CGFloat)self.bddNode.levelCount-1.0));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4);
    
    
    
    if (self.bddNode) [self drawNode:self.bddNode at:pos inContext:context offset:offset];
    
    
}


@end
