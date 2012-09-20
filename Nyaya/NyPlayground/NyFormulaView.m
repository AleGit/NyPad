//
//  NyFormulaView.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyFormulaView.h"
#import "NySymbolView.h"

#define LOCK_BUTTON_IDX 0
#define DELE_BUTTON_IDX 1

@interface NyFormulaView () {
    UIButton* _lockButton;
    UIButton* _deleButton;
}
@end

@implementation NyFormulaView
@synthesize formulaTapGestureRecognizer;
@synthesize formulaPanGestureRecognizer;

- (void)setup {
    self.backgroundColor = nil;
    _lockButton = (UIButton*)[self.subviews objectAtIndex:LOCK_BUTTON_IDX];
    _deleButton = (UIButton*)[self.subviews objectAtIndex:DELE_BUTTON_IDX];
    _chosen = YES;
}

- (void)reset {
    _lockButton.hidden = !self.chosen;
    _deleButton.hidden = !self.chosen;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
    
}

- (void)setChosen:(BOOL)selected {
    _chosen = selected;
    [self reset];
}

- (void)setLocked:(BOOL)locked {
    _lockButton.selected = locked;
}

- (BOOL)isLocked {
    return _lockButton.isSelected;
}

- (void)removeAllSymbols {
    NSArray *subviews = [self.subviews copy];
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[NySymbolView class]]) [subview removeFromSuperview];
    }
}



#define FDX 47.0
#define FDY 61.0

- (void)setNode:(NyayaNode *)node {
    _node = node;
    [self removeAllSymbols];
    
    
    CGPoint origin = self.frame.origin;
    CGSize oldsize = self.frame.size;
    CGSize newsize = [self sizeOfNode:node];
    self.frame = CGRectMake(MAX(0.0,
                                       origin.x + (oldsize.width-newsize.width)/2.0),
                                   origin.y,
                                   MAX(2.0*FDX, newsize.width),
                                   MAX(1.5*FDY, newsize.height));
    
    [self addNode:node inRect:self.bounds];
}

- (CGSize)sizeOfNode:(NyayaNode*)node {
    return CGSizeMake(FDX * (CGFloat)node.width, FDY * (CGFloat)node.height);
}


- (NySymbolView*)addNode:(NyayaNode*)node inRect:(CGRect)rect {
    NySymbolView *symbolView = [self.dataSource symbolView];
    
    [self addSubview:symbolView];
    symbolView.center = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + FDY / 2.0);
    symbolView.node = node;
    
    CGFloat xoffset = rect.origin.x;
    CGFloat yoffset = rect.origin.y + FDY;
    
    
    for (NyayaNode *subnode in node.nodes) {
        CGSize size = [self sizeOfNode:subnode];
        rect = CGRectMake(xoffset, yoffset, size.width, size.height);
        
        NySymbolView *subsymbol = [self addNode:subnode inRect:rect];
        [symbolView connectSubsymbol:subsymbol];
        xoffset += size.width;
    }
    return symbolView;
    
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    static const CGFloat arr [] = { 1.0, 1.0, 2.0, 2.0 };

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0.0, arr, 2);
    CGContextSetRGBStrokeColor(context, 0.5, 0.0, 0, 0.9);
    if (self.isChosen) {
        CGContextAddRect(context, CGRectInset(self.bounds, 3.0, 3.0));
    }
    CGContextAddRect(context, self.bounds);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineDash(context, 0.0, NULL, 0);
    CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.2, 0.8);
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[NySymbolView class]]) {
            NySymbolView *symbolView = (NySymbolView*)subview;
            
            for (NySymbolView *subsymbolView in symbolView.subsymbols) {
                CGContextMoveToPoint(context, symbolView.center.x, symbolView.center.y+20.0);
                // CGContextAddLineToPoint(context, subsymbolView.center.x, subsymbolView.center.y-20.0);
                
                CGContextAddCurveToPoint(context,
                                         symbolView.center.x, symbolView.center.y+40.0,
                                         subsymbolView.center.x, subsymbolView.center.y-40.0,
                                         subsymbolView.center.x, subsymbolView.center.y-20.0);
            }
        }
    }
    CGContextStrokePath(context);
}


@end
