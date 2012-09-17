//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyPgDetailViewController.h"
#import "NSObject+Nyaya.h"

@interface NyPgDetailViewController () {
    NSMutableArray *_formulaViews;
}
@end

@implementation NyPgDetailViewController

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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[NyFormulaView class]]) {
        return YES; // drag, select formula
    }
    else  if ([touch.view isKindOfClass:[UIButton class]])
        return NO;
    else {
        NSLog(@"touch.view.class = %@", touch.view.class);
        return YES;
    }
}


- (IBAction)canvasTap:(UITapGestureRecognizer *)sender {
    for (NyFormulaView *formulaView in _formulaViews) {
        formulaView.chosen = NO;
        [formulaView setNeedsDisplay];
    }
}

- (IBAction)canvasLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self deselectOtherFormulas:nil];
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"NyFormulaView" owner:self options:nil];
        NyFormulaView *formualaView = [viewArray objectAtIndex:0];
        NySymbolView *symbolView = [viewArray objectAtIndex:3];
        // NSLog(@"\n%x %x %x", (NSInteger)viewArray, (NSInteger)formualaView, (NSInteger)symbolView);
        viewArray = nil;
        CGPoint location = [sender locationInView:self.canvasView];
        
        formualaView.center = location;
        formualaView.chosen = YES;
        [_formulaViews addObject:formualaView];
        
        
        [self.canvasView addSubview:formualaView];
        symbolView.center = CGPointMake(formualaView.frame.size.width/2.0, symbolView.frame.size.height);
        [formualaView addSubview:symbolView];
        
        NSLog(@"canvasView.subview count %u", [self.canvasView.subviews count]);
        [self.canvasView setNeedsDisplay];
        
    }
}

- (void)deselectOtherFormulas:(NyFormulaView*)formulaView {
    [_formulaViews enumerateObjectsUsingBlock:^(NyFormulaView *obj, NSUInteger idx, BOOL *stop) {
        if (obj.chosen && obj != formulaView) {
            obj.chosen = NO;
            
        }
        [obj setNeedsDisplay];
    }];
    
    if (formulaView.isChosen) {
        [formulaView.superview bringSubviewToFront:formulaView];
    }
}

- (IBAction)dragFormula:(UIPanGestureRecognizer *)sender {
    NyFormulaView *formulaView = (NyFormulaView*)sender.view;
    [self deselectOtherFormulas:formulaView];
    
    if (!formulaView.isChosen) {
        formulaView.chosen = YES;
        [formulaView setNeedsDisplay];
        [formulaView.superview bringSubviewToFront:formulaView];
    }
    
    CGPoint canvasTranslation = [sender translationInView:self.canvasView];
    CGRect f = formulaView.frame;
    formulaView.frame = CGRectMake(f.origin.x + canvasTranslation.x, f.origin.y + canvasTranslation.y, f.size.width, f.size.height);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (IBAction)tapSymbol:(UITapGestureRecognizer *)sender {
    NSLog(@"tabSymbol: %@", [sender.view class]);
    NySymbolView *symbolView = (NySymbolView*)sender.view;
    NyFormulaView *formulaView = (NyFormulaView *)symbolView.superview;
    formulaView.chosen = YES;
    [self deselectOtherFormulas:formulaView];
    
}

- (IBAction)selectFormula:(UITapGestureRecognizer *)sender {
    NSLog(@"selectFormula: %@", [sender.view class]);
    NyFormulaView *formulaView = (NyFormulaView*)sender.view;
    [self deselectOtherFormulas:formulaView];
    formulaView.chosen = !formulaView.isChosen;
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
