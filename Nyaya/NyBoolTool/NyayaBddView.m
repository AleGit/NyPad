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

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
    [self drawDiagram:context];
}


- (NSDictionary*)nodePoints {
    NSSet *set0 = [NSSet setWithArray:[self.bddNode.levels objectAtIndex:0]];
    BOOL optimized = [set0 count] < 3;
    
    CGFloat vSegments = (CGFloat)[self.bddNode.levels count] - 1.0;
    CGFloat xmargin = optimized ? 5.0 + self.frame.size.width / (vSegments+1.0) : 25.0;
    
    CGPoint p0 = CGPointMake(self.frame.size.width/2.0, 25.0);
    CGPoint pL = CGPointMake(xmargin, self.frame.size.height- 25.0);
    CGPoint pR = CGPointMake(self.frame.size.width-xmargin, self.frame.size.height - 25.0);
    
    NSMutableDictionary *nps = [NSMutableDictionary dictionary];

    
    CGSize size = CGSizeMake(pR.x - pL.x, pR.y - p0.y);
    
    if (!self.bddNode.levels && self.bddNode) {
        self.bddNode.levels = @[@[self.bddNode]];
    }
    
    [self.bddNode.levels enumerateObjectsUsingBlock:^(NSArray* harr, NSUInteger vidx, BOOL *stop) {
        CGFloat factor = optimized ?    (vSegments-2*vidx) / vSegments     : (CGFloat)vidx / vSegments;
        CGFloat xoffset = optimized ?   factor * factor * size.width/4.0   : factor * size.width/2.0;
        
        CGFloat vPos;
        if (vSegments < 1)
            vPos = p0.y;
        else
            vPos =  pL.y - (CGFloat)vidx/vSegments * size.height;
        
        NSMutableArray *rarr = [NSMutableArray array];
        for (BddNode *node in harr) {
            if (![rarr containsObject:node]) [rarr addObject:node];
        }
        CGFloat hSegments = (CGFloat)[rarr count] - 1.0;
        
        for (NSUInteger hidx = 0; hidx < [rarr count]; hidx++) {
            BddNode *node = [rarr objectAtIndex:hidx];
            
            if (![nps objectForKey:node]) {
                CGFloat hPos;
                
                if (hSegments < 1.0) {
                    hPos = p0.x;
                }
                else {
                    hPos = pL.x + xoffset + ((CGFloat)hidx)/hSegments * (pR.x-pL.x-2*xoffset);
                }
                CGPoint npos = CGPointMake(hPos, vPos);
                NSString *obj = NSStringFromCGPoint(npos);
                
                [nps setObject:obj forKey:node];
            }
        }
        
        
    }];
    return nps;
}

- (void)drawDiagram:(CGContextRef)context {
    
    static const CGFloat arr [] = { 3.0, 6.0, 9.0, 2.0 };
    CGContextSetLineWidth(context, 3.0);
    
    NSDictionary *nps = [self nodePoints];
    
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
        NSLog(@"%@ %u %@", key.name, key.id, obj);
        CGPoint pos = CGPointFromString(obj);
        
        if (!key.isLeaf) {
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
            CGContextSetRGBFillColor(context, 1, 1, 1, 0.9);
            CGContextAddEllipseInRect(context, CGRectMake(pos.x-21.0, pos.y-21.0,43.0,43.0));
            CGContextDrawPath(context, kCGPathEOFillStroke);
            
            
        }
        else {
            
            if (key.id==0 || [key.name isEqual:@"0"])
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
