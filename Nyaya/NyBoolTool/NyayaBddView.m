//
//  NyayaBddView.m
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaBddView.h"
#import "UIColor+Nyaya.h"
#import <QuartzCore/QuartzCore.h>

@implementation NyayaBddView

+(Class)layerClass
{
    return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect {
    // UIView uses the existence of -drawRect: to determine if should allow its CALayer
    // to be invalidated, which would then lead to the layer creating a backing store and
    // -drawLayer:inContext: being called.
    // By implementing an empty -drawRect: method, we allow UIKit to continue to implement
    // this logic, while doing our real drawing work inside of -drawLayer:inContext:
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    [self drawDiagram:context];
}

- (void)fillDictionary:(NSMutableDictionary*)nodePoints with:(BddNode*)bdd inRect:(CGRect) rect {
    if (bdd) {
        CGFloat y = rect.origin.y + 35.0;
        CGFloat x = rect.origin.x + rect.size.width / 2.0;
        nodePoints[bdd] = NSStringFromCGPoint(CGPointMake(x,y));
        
        CGRect left = CGRectMake(rect.origin.x, rect.origin.y + 70.0, rect.size.width/2.0, rect.size.height - 70.0);
        [self fillDictionary:nodePoints with:bdd.leftBranch inRect:left];
        CGRect right = CGRectMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + 70.0, rect.size.width/2.0, rect.size.height - 70.0);
        [self fillDictionary:nodePoints with:bdd.rightBranch inRect:right];
        
        
    }
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    static const CGFloat arr [] = { 3.0, 6.0, 9.0, 2.0 };
    CGContextSetLineWidth(context, 3.0);
    
    NSMutableDictionary *nps = [NSMutableDictionary dictionary];
    
    
    
    
    [self fillDictionary:nps with:self.bddNode inRect:self.bounds];
    
    // draw lines
    
    [nps enumerateKeysAndObjectsUsingBlock:^(BddNode *key, NSString *obj, BOOL *stop) {
        CGPoint pos = CGPointFromString(obj);
        
        if (!key.isLeaf) {
            
            
            CGPoint posL = CGPointFromString([nps objectForKey:key.leftBranch]);
            CGPoint posR = CGPointFromString([nps objectForKey:key.rightBranch]);
            
            // draw left branch
            CGContextSetLineDash(context, 30.0, arr, 2);
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
            CGContextMoveToPoint(context, pos.x, pos.y);
            CGContextAddLineToPoint(context, posL.x, posL.y);
            CGContextStrokePath(context);
            
            
            // draw right branch
            CGContextSetLineDash(context, 0.0, nil, 0);
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
            CGContextMoveToPoint(context, pos.x, pos.y);
            CGContextAddLineToPoint(context, posR.x, posR.y);
            CGContextStrokePath(context);
            
            
        }
        
    }];
    
    // draw nodes
    
    
    [nps enumerateKeysAndObjectsUsingBlock:^(BddNode *key, NSString *obj, BOOL *stop) {
        CGPoint pos = CGPointFromString(obj);
        
        if (!key.isLeaf) {
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
            CGContextSetRGBFillColor(context, 1, 1, 1, 0.9);
            CGContextAddEllipseInRect(context, CGRectMake(pos.x-21.0, pos.y-21.0,43.0,43.0));
            CGContextDrawPath(context, kCGPathEOFillStroke);
            
            
        }
        else {
            
            if ([key.name isEqual:@"0"])
                CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
            else
                CGContextSetRGBFillColor(context, 0, 0.75, 0, 1.0);
            
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
            CGContextAddRect(context, CGRectMake(pos.x-21.0, pos.y-21.0,43.0,43.0));
            CGContextDrawPath(context, kCGPathEOFillStroke);
        }
        
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.9);
        UIGraphicsPushContext(context);
        CGSize size = [key.name sizeWithFont:[UIFont systemFontOfSize:23]];
        [key.name drawAtPoint:CGPointMake(pos.x - size.width/2.0, pos.y-size.height/2.0) withFont:[UIFont systemFontOfSize:23]];
        UIGraphicsPopContext();
        
    }];
    
    
}




@end
