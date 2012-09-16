//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyPgDetailViewController.h"
#import "NyFormulaView.h"

@interface NyPgDetailViewController () {
    NSMutableArray *_formulaViews;
}
@end

@implementation NyPgDetailViewController
@synthesize canvasView;

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Playground", @"Playground");
}

- (void)configureView
{
    [super configureView];
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    _formulaViews = [NSMutableArray arrayWithCapacity:10];
}

- (void)viewDidUnload {
    [self setCanvasView:nil];
    [super viewDidUnload];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"didRotate %@",self.canvasView);
    // CGRect f = self.canvasView.frame;
    // self.canvasView.frame = CGRectInset(f, 10, 10);
    [self.canvasView setNeedsDisplay];
    // [self.canvasView setNeedsDisplayInRect:self.canvasView.frame];
}

- (IBAction)canvasTap:(UITapGestureRecognizer *)sender {
    for (NyFormulaView *formulaView in _formulaViews) {
        formulaView.selected = NO;
        [formulaView setNeedsDisplay];
    }
}

- (IBAction)canvasLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self deselectOtherFormulas:nil];
        NyFormulaView *formualaView = [[[NSBundle mainBundle] loadNibNamed:@"NyFormulaView" owner:self options:nil] objectAtIndex:0];
        CGPoint location = [sender locationInView:self.canvasView];
        
        formualaView.frame = CGRectMake(location.x-200, location.y-20, 400.0, 400);
        formualaView.selected = YES;
        [_formulaViews addObject:formualaView];
        [self.canvasView addSubview:formualaView];
    }
}

- (void)deselectOtherFormulas:(NyFormulaView*)formulaView {
    [_formulaViews enumerateObjectsUsingBlock:^(NyFormulaView *obj, NSUInteger idx, BOOL *stop) {
        if (obj.isSelected && obj != formulaView) {
            obj.selected = NO;
            [obj setNeedsDisplay];
        }
    }];
}

- (IBAction)dragFormula:(UIPanGestureRecognizer *)sender {
    NyFormulaView *formulaView = (NyFormulaView*)sender.view;
    [self deselectOtherFormulas:formulaView];
    
    if (!formulaView.isSelected) {
        formulaView.selected = YES;
        [formulaView setNeedsDisplay];
    }
    
    CGPoint canvasTranslation = [sender translationInView:self.canvasView];
    CGRect f = formulaView.frame;
    formulaView.frame = CGRectMake(f.origin.x + canvasTranslation.x, f.origin.y + canvasTranslation.y, f.size.width, f.size.height);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (IBAction)selectFormula:(UITapGestureRecognizer *)sender {
    NyFormulaView *formulaView = (NyFormulaView*)sender.view;
    [self deselectOtherFormulas:formulaView];
    formulaView.selected = !formulaView.isSelected;
    [formulaView setNeedsDisplay];
}

- (IBAction)lockFormula:(UIButton *)sender {
    NyFormulaView *formulaView = (NyFormulaView*)sender.superview;
    formulaView.locked = !formulaView.isLocked;
}

- (IBAction)deleteFormula:(UIButton *)sender {
    NyFormulaView *formulaView = (NyFormulaView*)sender.superview;
    [_formulaViews removeObject:formulaView];
    [formulaView removeFromSuperview];
}
@end
