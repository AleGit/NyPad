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

#pragma mark - VIEW

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
    [self addNewFormulaAtCanvasLocation:CGPointMake(self.canvasView.center.x, 50.0)];
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


// enable menu controller
- (BOOL)canBecomeFirstResponder {
    return YES;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
        // lock button = lock formula
        // delete button = delete formula
    }
    

    else if ([touch.view isKindOfClass:[NyFormulaView class]]) {
        return [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] // tap formula view = select formula
        || [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]           // pan formula view = drag formula
        ;
    }
    else if ([touch.view isKindOfClass:[NySymbolView class]]) {
        return [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]     // tap symbol view = tap symbol
        || ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]
            && [(UISwipeGestureRecognizer*)gestureRecognizer direction] & (UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp)) // swipe symbol view down = swipe down symbol
        ;
        
    }
    else {
        NSLog(@"touch.view.class = %@", touch.view.class);
        return YES;
    }
}

#pragma mark - CANVAS
- (IBAction)canvasTap:(UITapGestureRecognizer *)sender {
    for (NyFormulaView *formulaView in _formulaViews) {
        formulaView.chosen = NO;
        [formulaView setNeedsDisplay];
    }
}

- (void)addNewFormulaAtCanvasLocation:(CGPoint)location {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"NyFormulaView" owner:self options:nil];
    NyFormulaView *formualaView = [viewArray objectAtIndex:0];
    NySymbolView *symbolView = [viewArray objectAtIndex:3];
    
    [formualaView addSubview:symbolView];
    symbolView.center = CGPointMake(formualaView.frame.size.width/2.0, symbolView.frame.size.height);
    formualaView.center = CGPointMake(location.x, location.y + formualaView.frame.size.height/2.0 - symbolView.center.y);
    
    formualaView.chosen = YES;
    formualaView.locked = NO;
    
    [_formulaViews addObject:formualaView];
    [self.canvasView addSubview:formualaView];
}

- (IBAction)canvasLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self deselectOtherFormulas:nil];
        CGPoint location = [sender locationInView:self.canvasView];
        [self addNewFormulaAtCanvasLocation:location];
    }
}

#pragma mark - FORMULAs

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

#pragma mark - SYMBOLs

- (void)actionA:(UIMenuController*)ctrl {
    NSLog(@"A %@", ctrl);
    
}

- (void)actionB:(UIMenuController*)ctrl {
    NSLog(@"B %@", ctrl);
    
}

- (void)showSymbolMenu:(UIView*)view {
    //CGPoint location = view.center;
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    NSMutableArray *menuItems = [NSMutableArray array];
    [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"(¬Φ)" action:@selector(actionA:)]];
//    [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"(Φ➞Φ)" action:nil]];
//    [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"(Φ∧Φ)" action:nil]];
//    [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"(Φ∨Φ)" action:nil]];
    [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"p" action:@selector(actionB:)]];
//    [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"⊤" action:nil]];
//    [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"⊥" action:nil]];
    // [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"f(Φ,Φ,Φ)" action:@selector(formulaToF:)]];
    
    [self becomeFirstResponder];
    
    [menuController setMenuItems:menuItems];
    [menuController setTargetRect:view.frame inView:view.superview];
    [menuController setMenuVisible:YES];
    
    
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(UIView *)context {
    if ([animationID isEqualToString:@"growSymbol"]) {
        [UIView beginAnimations:@"shrinkSymbol" context:(void*)context];
#define ANIMADURATION 0.4
        [UIView setAnimationDuration:ANIMADURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
        context.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [self showSymbolMenu:context];
    }
    else {
        // [self showFormulaMenu:context.center inView:context];
        NSLog(@"animationDidStop: %@ finished: %@ context: %f %f", animationID, finished, context.center.x, context.center.y);
    }
}

- (void)growSymbol:(UIView *)view {
    
	[UIView beginAnimations:@"growSymbol" context:(void*)view];
	[UIView setAnimationDuration:ANIMADURATION];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    
	view.transform = transform;
	[UIView commitAnimations];
}

- (void)moveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(UIView *)context {
    if (![animationID isEqualToString:@"undoMoveSymbol"]) {
        [UIView beginAnimations:@"undoMoveSymbol" context:(void*)context];
        [UIView setAnimationDuration:ANIMADURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(moveAnimationDidStop:finished:context:)];
        context.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
    }
    else {
        // [self showFormulaMenu:context.center inView:context];
        NSLog(@"animationDidStop: %@ finished: %@ context: %f %f", animationID, finished, context.center.x, context.center.y);
    }
}

- (void)moveSymbol:(UIView *)view direction: (CGPoint)direction {
    [UIView beginAnimations:@"moveDownSymbol" context:(void*)view];
	[UIView setAnimationDuration:ANIMADURATION * sqrtf(0.5+sqrtf(direction.x*direction.x+direction.y+direction.y)/40.0) ];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(direction.x, direction.y);
    
	view.transform = transform;
	[UIView commitAnimations];
    
}


- (IBAction)tapSymbol:(UITapGestureRecognizer *)sender {
    NSLog(@"tabSymbol: %@", [sender.view class]);
    NySymbolView *symbolView = (NySymbolView*)sender.view;
    NyFormulaView *formulaView = (NyFormulaView *)symbolView.superview;
    formulaView.chosen = YES;
    [self deselectOtherFormulas:formulaView];
    [self growSymbol:symbolView];
    symbolView.displayValue = symbolView.displayValue + 1;
    
}

- (IBAction)swipeSymbol:(UISwipeGestureRecognizer *)sender {
    NSLog(@"swipeDownSymbol: %@", [sender.view class]);
    NySymbolView *symbolView = (NySymbolView*)sender.view;
    // NyFormulaView *formulaView = (NyFormulaView *)symbolView.superview;
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            [self moveSymbol:symbolView direction:CGPointMake(0.0,-10.0)];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self moveSymbol:symbolView direction:CGPointMake(0.0,40.0)];
            break;
        default:
            NSLog(@"%@",sender);
            break;
    } 
}
@end
