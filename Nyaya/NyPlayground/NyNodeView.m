//
//  NySymbolView.m
//  Nyaya
//
//  Created by Alexander Maringele on 17.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyNodeView.h"
#import "NyTreeView.h"

@interface NyTreeView (Symbols)
- (void)refreshSymbols;
@end

#define CIRCLE_LABEL_IDX 0
#define SYMBOL_LABEL_IDX 1

@interface NyNodeView () {
    UILabel *_symbolLabel;
    UILabel *_circleLabel;
    NSMutableArray *_subsymbols;
    __weak NyNodeView *_supersymbol;
}
@end

@implementation NyNodeView

- (NyTreeView*)formulaView {
    return (NyTreeView*)self.superview;
}

- (void)setup {
    self.backgroundColor = nil;
    _circleLabel = (UILabel*)[self.subviews objectAtIndex:CIRCLE_LABEL_IDX];
    _symbolLabel= (UILabel*)[self.subviews objectAtIndex:SYMBOL_LABEL_IDX];
    _subsymbols = [NSMutableArray arrayWithCapacity:2];
    [self reset];
}

- (void)reset {
    if (self.formulaView.hideValuation) _circleLabel.textColor = [UIColor blueColor];
    else {
        switch (self.displayValue) {
            case NyayaFalse:
                _circleLabel.textColor = [UIColor redColor];
                break;
            case NyayaTrue:
                _circleLabel.textColor = [UIColor greenColor];
                break;
            default:
                _circleLabel.textColor = [UIColor blueColor];
                break;
        }
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

- (NyayaBool)displayValue {
    return _node.displayValue;
}

- (void)setDisplayValue:(NyayaBool)displayValue {
    if ([_node conformsToProtocol:@protocol(MutableDisplayNode) ]) {
        [((id<MutableDisplayNode>)_node) setDisplayValue:displayValue];
        
    }
    [self.formulaView refreshSymbols];
}

- (NSUInteger)countSubsymbols {
    return [_subsymbols count];
}

- (NyNodeView *)subsymbolAtIndex:(NSUInteger)idx {
    return [_subsymbols objectAtIndex:idx];
}

- (void)connectSubsymbol:(NyNodeView *)symbol {
    if (!symbol->_supersymbol) {
        // symbol must not have a parent
        
        symbol->_supersymbol = self;
        [_subsymbols addObject:symbol];
    }
}

- (void)connectSubsymbol:(NyNodeView *)symbol atIndex:(NSUInteger)idx {
    if (!symbol->_supersymbol) {
        // symbol must not have a parent
        
        symbol->_supersymbol = self;
        [_subsymbols insertObject:symbol atIndex:idx];
    }
}

- (void)disconnectSubsymbol:(NyNodeView *)symbol {
    if (symbol->_supersymbol == self) {
        [_subsymbols removeObject:symbol];
        symbol->_supersymbol = nil;
    }
}

- (void)setNode:(id<DisplayNode>)node {
    _node = node;
    _symbolLabel.text = node.symbol;
}

- (void)setNeedsDisplay {
    [self reset];
    // [super setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSIndexPath*)indexPath {
    if (!self.supersymbol) return [[NSIndexPath alloc] init]; // root node has empty indexpath
    
    
    
    else {
        NSUInteger idx = [self.supersymbol.subsymbols indexOfObject:self];
        return [[self.supersymbol indexPath] indexPathByAddingIndex:idx];
    }
}

@end
