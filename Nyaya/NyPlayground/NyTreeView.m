//
//  NyFormulaView.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyTreeView.h"
#import "NyNodeView.h"

#define LOCK_BUTTON_IDX 0
#define DELE_BUTTON_IDX 1
#define HEAD_LABEL_IDX 2

@interface NyTreeView () {
    UIButton* _lockButton;
    UIButton* _deleButton;
    UILabel* _headLabel;
}
@end

@implementation NyTreeView
@synthesize formulaTapGestureRecognizer;
@synthesize formulaPanGestureRecognizer;

- (void)setup {
    self.backgroundColor = nil;
    _lockButton = (UIButton*)[self.subviews objectAtIndex:LOCK_BUTTON_IDX];
    _deleButton = (UIButton*)[self.subviews objectAtIndex:DELE_BUTTON_IDX];
    _headLabel = (UILabel*)[self.subviews objectAtIndex:HEAD_LABEL_IDX];
    _chosen = YES;
    _headLabel.text = @"";
}

- (void)reset {
    _lockButton.hidden = _hideLock || !_chosen;
    _deleButton.hidden = _hideCloser || !_chosen;
    _headLabel.hidden = _hideHeader || !_chosen;
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
    _lockButton.selected = !locked;
}

- (BOOL)isLocked {
    return !_lockButton.isSelected;
}

- (NSArray*)symbolViews {
    NSMutableArray *symbolViews = [NSMutableArray arrayWithCapacity:[self.subviews count]];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[NyNodeView class]]) [symbolViews addObject:subview];
    }
    return symbolViews;
}



#define FDX 47.0
#define FDY 61.0

- (void)setNode:(id<DisplayNode>)node {
    NSArray *outdatedSymbolViews = [self symbolViews];
    
    _node = node;
    CGPoint origin = self.frame.origin;
    CGSize oldsize = self.frame.size;
    CGSize newsize = [self sizeOfNode:node];
    CGRect frame = CGRectMake(MAX(0.0,
                                       origin.x + (oldsize.width-newsize.width)/2.0),
                                   origin.y,
                                   MAX(2.0*FDX, newsize.width),
                                   MAX(1.5*FDY, newsize.height));
    
    
    self.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
   
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
        _headLabel.text = [node headLabelText];
        
        
    } completion:^(BOOL finished) {
        for (UIView *view in outdatedSymbolViews) {
            [view removeFromSuperview];
        }
        [self addNode:node inRect:self.bounds];
        [self refreshSymbols];
        
        
        

    }];
    
    [self reset];
    
    
    
    
}

- (void)refreshSymbols {
    [self setNeedsDisplay];
    
    for (UIView *view in self.subviews) {
        [view setNeedsDisplay];
    }
}


- (CGSize)sizeOfNode:(id<DisplayNode>)node {
    return CGSizeMake(FDX * (CGFloat)node.width, FDY * (CGFloat)node.height);
}


- (NyNodeView*)addNode:(id<DisplayNode>)node inRect:(CGRect)rect {
    NyNodeView *symbolView = [self.dataSource symbolView];
    
    [self addSubview:symbolView];
    symbolView.center = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + 0.6 * FDY);
    symbolView.node = node;
    
    CGFloat xoffset = rect.origin.x;
    CGFloat yoffset = rect.origin.y + FDY;
    
    
    for (id<DisplayNode> subnode in node.nodes) {
        CGSize size = [self sizeOfNode:subnode];
        rect = CGRectMake(xoffset, yoffset, size.width, size.height);
        
        NyNodeView *subsymbol = [self addNode:subnode inRect:rect];
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
        if ([subview isMemberOfClass:[NyNodeView class]]) {
            NyNodeView *symbolView = (NyNodeView*)subview;
            
            for (NyNodeView *subsymbolView in symbolView.subsymbols) {
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
