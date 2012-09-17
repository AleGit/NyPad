//
//  NySymbolView.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NySymbolView.h"


#define CIRCLE_LABEL_IDX 0
#define SYMBOL_LABEL_IDX 1

@interface NySymbolView () {
    UILabel *_symbolLabel;
    UILabel *_circleLabel;
    NSMutableArray *_subsymbols;
    __weak NySymbolView *_supersymbol;
}
@end

@implementation NySymbolView

- (void)setup {
    self.backgroundColor = nil;
    _circleLabel = (UILabel*)[self.subviews objectAtIndex:CIRCLE_LABEL_IDX];
    _symbolLabel= (UILabel*)[self.subviews objectAtIndex:SYMBOL_LABEL_IDX];
    _subsymbols = [NSMutableArray arrayWithCapacity:2];
    [self reset];
}

- (void)reset {
    switch (_displayValue) {
        case NyayaFalse:
            _circleLabel.textColor = [UIColor redColor];
            break;
        case NyayaTrue:
            _circleLabel.textColor = [UIColor greenColor];
            break;
        default:
            _displayValue = NyayaUndefined;
            _circleLabel.textColor = [UIColor grayColor];
            break;
    }
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

- (void)setDisplayValue:(NyayaBool)displayValue {
    _displayValue = displayValue;
    [self reset];
}

- (NSUInteger)countSubsymbols {
    return [_subsymbols count];
}

- (NySymbolView *)subsymbolAtIndex:(NSUInteger)idx {
    return [_subsymbols objectAtIndex:idx];
}

- (void)connectSubsymbol:(NySymbolView *)symbol {
    if (!symbol->_supersymbol) {
        // symbol must not have a parent
        
        symbol->_supersymbol = self;
        [_subsymbols addObject:symbol];
    }
}

- (void)connectSubsymbol:(NySymbolView *)symbol atIndex:(NSUInteger)idx {
    if (!symbol->_supersymbol) {
        // symbol must not have a parent
        
        symbol->_supersymbol = self;
        [_subsymbols insertObject:symbol atIndex:idx];
    }
}

- (void)disconnectSubsymbol:(NySymbolView *)symbol {
    if (symbol->_supersymbol == self) {
        [_subsymbols removeObject:symbol];
        symbol->_supersymbol = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end