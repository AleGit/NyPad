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

@interface NyayaBddView () {
    NSMutableDictionary *_structure;
    NSMutableDictionary *_nodepoints;
    
    NSMutableArray *_layers;

}
@end

@implementation NyayaBddView

+(Class)layerClass
{
    return [CATiledLayer class];
}

- (void)setBddNode:(BddNode *)bddNode {
    @synchronized(self) {
        _layers = nil;
        _bddNode = nil;
        _structure = nil;
        _nodepoints = nil;
        
        _bddNode = bddNode;
        if (_bddNode) {
            _layers = [NSMutableArray arrayWithCapacity:[bddNode height]];
            [_layers addObject:[NSArray arrayWithObject:_bddNode]];
            [self buildNextLayer: 0];
            
            
        }
        
    }
    NSLog(@"%@",_layers);
}

- (void)buildNextLayer: (NSInteger)layer {
    NSArray *actualLayer = [_layers objectAtIndex:layer];
    NSMutableArray *nextLayer = [NSMutableArray array];
    
    
    layer++;
    [actualLayer enumerateObjectsUsingBlock:^(BddNode* node, NSUInteger idx, BOOL *stop) {
        // NSLog(@"%@.%i layer=%i", node.name, node.layer, layer);
        
        if (node.isLeaf) *stop = YES;
        else {
            if (node.leftBranch.layer == layer) {
                if ([nextLayer indexOfObject:node.leftBranch] == NSNotFound)
                    [nextLayer addObject:node.leftBranch];
            }
            else if (node.leftBranch.layer > layer) [nextLayer addObject:node]; // dummy node
            
            if (node.rightBranch.layer == layer) {
                if ([nextLayer indexOfObject:node.rightBranch] == NSNotFound)
                    [nextLayer addObject:node.rightBranch];
            }
            else if (node.rightBranch.layer > layer) [nextLayer addObject:node]; // dummy node
        }
    }];
    
    if (nextLayer.count > 0) {
        [_layers addObject:nextLayer];
        [self buildNextLayer:layer];
        // NSLog(@"%i %i", layer, nextLayer.count);
    }
}

- (void)drawRect:(CGRect)rect {
    // UIView uses the existence of -drawRect: to determine if should allow its CALayer
    // to be invalidated, which would then lead to the layer creating a backing store and
    // -drawLayer:inContext: being called.
    // By implementing an empty -drawRect: method, we allow UIKit to continue to implement
    // this logic, while doing our real drawing work inside of -drawLayer:inContext:
    
    
    static const CGFloat arr [] = { 3.0, 6.0, 9.0, 2.0 };
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat dy = height / (CGFloat)_layers.count;
   
    [_layers enumerateObjectsUsingBlock:^(NSArray *actualLayer, NSUInteger yidx, BOOL *stop) {
        
        CGFloat y = dy/2.0 + yidx * dy;
        CGFloat dx = width / (CGFloat)actualLayer.count;
        
        
        [actualLayer enumerateObjectsUsingBlock:^(BddNode *node, NSUInteger xidx, BOOL *stop) {
            CGFloat x = dx/2.0 + xidx * dx;
            
            if (node.layer == yidx) {
                
                if (!node.isLeaf) {
                    // draw lines to children (start)
                    NSUInteger txidx, tyidx;
                    NSArray *tlayer;
                    BddNode *target;
                    CGFloat tx, ty, dtx;
                    
                    // draw line to left child
                    target = node.leftBranch;
                    tyidx = target.layer;
                    tlayer = [_layers objectAtIndex:tyidx];
                    txidx = [tlayer indexOfObject:target];
                    dtx = width / (CGFloat)tlayer.count;
                    
                    ty = dy/2.0 + tyidx * dy;
                    tx = dtx/2.0 + txidx * dtx;
                    
                    CGContextSetLineDash(context, 30.0, arr, 2);
                    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
                    CGContextMoveToPoint(context, x, y);
                    CGContextAddLineToPoint(context, tx, ty);
                    CGContextStrokePath(context);
                    
                    // draw line to right child
                    target = node.rightBranch;
                    tyidx = target.layer;
                    tlayer = [_layers objectAtIndex:tyidx];
                    txidx = [tlayer indexOfObject:target];
                    dtx = width / (CGFloat)tlayer.count;
                    
                    ty = dy/2.0 + tyidx * dy;
                    tx = dtx/2.0 + txidx * dtx;
                    
                    
                    CGContextSetLineDash(context, 0.0, nil, 0);
                    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
                    CGContextMoveToPoint(context, x, y);
                    CGContextAddLineToPoint(context, tx, ty);
                    CGContextStrokePath(context);
                    
                    // draw lines to children (end)
                    
                    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
                    CGContextSetRGBFillColor(context, 1, 1, 1, 0.9);
                    CGContextAddEllipseInRect(context, CGRectMake(x-21.0, y-21.0,43.0,43.0));
                    CGContextDrawPath(context, kCGPathEOFillStroke);                    
                }
                else {
                    
                    if ([node.name isEqual:@"0"])
                        CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
                    else
                        CGContextSetRGBFillColor(context, 0, 0.75, 0, 1.0);
                    
                    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
                    CGContextAddRect(context, CGRectMake(x-21.0, y-21.0,43.0,43.0));
                    CGContextDrawPath(context, kCGPathEOFillStroke);
                }
                
                
                UIGraphicsPushContext(context);
                CGContextSetRGBFillColor(context, 0, 0, 0, 0.9);
                NSString *name = [NSString stringWithFormat:@"%@", node.name];
                CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:23]];
                [name drawAtPoint:CGPointMake(x - size.width/2.0, y-size.height/2.0) withFont:[UIFont systemFontOfSize:23]];
                UIGraphicsPopContext();
            }
            
            
            
        }];
    }];
    
    // draw lines
    
    
}



- (void)drawLayerX:(CALayer *)layer inContext:(CGContextRef)context {
    if (!self.bddNode) return;
    
    if (!_structure) {
        @synchronized(self) {
            if (!_structure) {
                _structure = [NSMutableDictionary dictionary];
                [self.bddNode fillStructure:_structure];
                
                _nodepoints = [NSMutableDictionary dictionary];
                
                if ([_structure count] == 1) {
                    _nodepoints[self.bddNode] = NSStringFromCGPoint(CGPointMake(200.0,35.0));
                }
                else {
                    
                    [self.bddNode.names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger yidx, BOOL *stop) {
                        CGFloat y = 30.0 + yidx * 60.0;
                        
                        NSSet *bddLevel = _structure[name];
                        CGFloat levelCount = [bddLevel count] + 1.0;
                        
                        [[bddLevel allObjects] enumerateObjectsUsingBlock:^(BddNode *lbdd, NSUInteger xidx, BOOL *stop) {
                            CGFloat x = (1.0+(CGFloat)xidx) * self.bounds.size.width / levelCount;
                            _nodepoints[lbdd] = NSStringFromCGPoint(CGPointMake(x,y));
                        }];
                        
                    }];
                    CGFloat y = [self.bddNode.names count] * 70.0;                    
                    BddNode *bottom = (BddNode*)[_structure[@"0"] anyObject];
                    BddNode *top = (BddNode*)[_structure[@"1"] anyObject];
                    
                    _nodepoints[bottom] = NSStringFromCGPoint(CGPointMake(self.bounds.size.width / 3.0,y));
                    _nodepoints[top] = NSStringFromCGPoint(CGPointMake(2.0*self.bounds.size.width / 3.0,y));
                    
                    
                    
                }
            }
        }
    }
    
        
    static const CGFloat arr [] = { 3.0, 6.0, 9.0, 2.0 };
    CGContextSetLineWidth(context, 3.0);

    
    
    
    
    // [self fillDictionary:nps with:self.bddNode inRect:self.bounds];
    
    // draw lines
    
    [_nodepoints enumerateKeysAndObjectsUsingBlock:^(BddNode *key, NSString *obj, BOOL *stop) {
        CGPoint pos = CGPointFromString(obj);
        
        if (!key.isLeaf) {
            
            
            CGPoint posL = CGPointFromString([_nodepoints objectForKey:key.leftBranch]);
            CGPoint posR = CGPointFromString([_nodepoints objectForKey:key.rightBranch]);
            
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
    
    
    [_nodepoints enumerateKeysAndObjectsUsingBlock:^(BddNode *key, NSString *obj, BOOL *stop) {
        CGPoint pos = CGPointFromString(obj);
        // NSLog(@"%@ %@", key.name, obj);
        
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
        NSString *keyName = [NSString stringWithFormat:@"%@:%i", key.name, key.layer];
        CGSize size = [keyName sizeWithFont:[UIFont systemFontOfSize:23]];
        [keyName drawAtPoint:CGPointMake(pos.x - size.width/2.0, pos.y-size.height/2.0) withFont:[UIFont systemFontOfSize:23]];
        UIGraphicsPopContext();
        
    }];
    
    
}




@end
