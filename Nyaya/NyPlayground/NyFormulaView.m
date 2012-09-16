//
//  NyFormulaView.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyFormulaView.h"

#define LOCK_BUTTON_TAG 1
#define DELE_BUTTON_TAG 2

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
    _lockButton = (UIButton*)[self viewWithTag:LOCK_BUTTON_TAG];
    _deleButton = (UIButton*)[self viewWithTag:DELE_BUTTON_TAG];
    _lockButton.hidden = !self.isSelected;
    _deleButton.hidden = !self.isSelected;
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

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    _lockButton.hidden = !self.isSelected;
    _deleButton.hidden = !self.isSelected;
}

- (void)setLocked:(BOOL)locked {
    _lockButton.selected = locked;
}

- (BOOL)isLocked {
    return _lockButton.isSelected;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL shouldReceive = touch.view != _lockButton && touch.view != _deleButton;
    return shouldReceive;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    static const CGFloat arr [] = { 1.0, 1.0, 2.0, 2.0 };
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0.0, arr, 2);
    CGContextSetRGBStrokeColor(context, 0.5, 0.0, 0, 0.9);
    if (self.isSelected) {
        CGContextAddRect(context, CGRectInset(self.bounds, 3.0, 3.0));
    }
    CGContextAddRect(context, self.bounds);
    CGContextStrokePath(context);
}


@end
