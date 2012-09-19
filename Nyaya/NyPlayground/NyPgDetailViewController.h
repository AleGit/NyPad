//
//  NyTuDetailViewController.h
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyDetailViewController.h"
#import "NyFormulaView.h"
#import "NySymbolView.h"

@interface NyPgDetailViewController : NyDetailInputViewController <NyFormulaViewDataSource, NyFormulaViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *canvasView;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)canvasTap:(UITapGestureRecognizer *)sender;
- (IBAction)canvasLongPress:(UILongPressGestureRecognizer*)sender;

@end
