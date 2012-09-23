//
//  NySymbolView.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayNode.h"

@class NyFormulaView;

@interface NySymbolView : UIView

@property (nonatomic, assign) NSUInteger displayValue;
@property (nonatomic, weak) id<DisplayNode> node;
@property (nonatomic, readonly) NSArray *subsymbols;
@property (nonatomic, readonly) NySymbolView *supersymbol;
@property (nonatomic, readonly) NyFormulaView *formulaView;

- (void)connectSubsymbol:(NySymbolView*)symbol;
- (NSIndexPath*)indexPath;

//- (NSUInteger)countSubsymbols;
//- (NySymbolView*)subsymbolAtIndex:(NSUInteger)idx;

//- (void)connectSubsymbol:(NySymbolView*)symbol atIndex:(NSUInteger)idx;
//- (void)disconnectSubsymbol:(NySymbolView*)symbol;

@end
