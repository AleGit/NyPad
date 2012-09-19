//
//  NySymbolView.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NyayaNode+Display.h"

@interface NySymbolView : UIView

@property (nonatomic, assign) NyayaBool displayValue;
@property (nonatomic, strong) NyayaNode* node;
@property (nonatomic, readonly) NSArray *subsymbols;
@property (nonatomic, readonly) NySymbolView *supersymbol;

//- (NSUInteger)countSubsymbols;
//- (NySymbolView*)subsymbolAtIndex:(NSUInteger)idx;
- (void)connectSubsymbol:(NySymbolView*)symbol;
//- (void)connectSubsymbol:(NySymbolView*)symbol atIndex:(NSUInteger)idx;
//- (void)disconnectSubsymbol:(NySymbolView*)symbol;

@end
