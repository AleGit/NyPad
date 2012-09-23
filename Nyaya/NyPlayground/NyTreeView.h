//
//  NyFormulaView.h
//  Nyaya
//
//  Created by Alexander Maringele on 16.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayNode.h"
#import "NyNodeView.h"

@protocol NyTreeViewDataSource

- (NyNodeView*)symbolView;

@end

@protocol NyTreeViewDelegate

- (IBAction)lockFormula:(UIButton *)sender;
- (IBAction)deleteFormula:(UIButton *)sender;

- (IBAction)selectFormula:(UITapGestureRecognizer *)sender;
- (IBAction)dragFormula:(UIPanGestureRecognizer *)sender;
- (IBAction)tapSymbol:(UITapGestureRecognizer *)sender;
- (IBAction)swipeSymbol:(UISwipeGestureRecognizer *)sender;

@end

@interface NyTreeView : UIView

@property (weak, nonatomic) IBOutlet id<NyTreeViewDataSource> dataSource;
@property (weak, nonatomic) IBOutlet id<NyTreeViewDelegate> delegate;

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
