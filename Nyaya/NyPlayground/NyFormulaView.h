//
//  NyFormulaView.h
//  Nyaya
//
//  Created by Alexander Maringele on 16.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayNode.h"
#import "NySymbolView.h"

@protocol NyFormulaViewDataSource

- (NySymbolView*)symbolView;

@end

@protocol NyFormulaViewDelegate

- (IBAction)lockFormula:(UIButton *)sender;
- (IBAction)deleteFormula:(UIButton *)sender;

- (IBAction)selectFormula:(UITapGestureRecognizer *)sender;
- (IBAction)dragFormula:(UIPanGestureRecognizer *)sender;
- (IBAction)tapSymbol:(UITapGestureRecognizer *)sender;
- (IBAction)swipeSymbol:(UISwipeGestureRecognizer *)sender;

@end

@interface NyFormulaView : UIView

@property (weak, nonatomic) IBOutlet id<NyFormulaViewDataSource> dataSource;
@property (weak, nonatomic) IBOutlet id<NyFormulaViewDelegate> delegate;

@property (strong, nonatomic) id<DisplayNode> node;

@property (assign, nonatomic, getter = isChosen) BOOL chosen;
@property (assign, nonatomic, getter = isLocked) BOOL locked;

@property (assign, nonatomic) BOOL hideLock;
@property (assign, nonatomic) BOOL hideCloser;
@property (assign, nonatomic) BOOL hideHeader;
@property (assign, nonatomic) BOOL hideValuation;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *formulaTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *formulaPanGestureRecognizer;

@end
