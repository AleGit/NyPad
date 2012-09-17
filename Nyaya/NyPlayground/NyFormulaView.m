//
//  NyFormulaView.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyFormulaView.h"

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
}


@end
