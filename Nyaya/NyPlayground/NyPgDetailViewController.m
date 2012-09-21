//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyPgDetailViewController.h"
#import "NSObject+Nyaya.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Type.h"
#import "NyayaNode+Reductions.h"
#import "NyayaNode+Transformations.h"
#import "NyayaNode+Valuation.h"
#import "NyayaNode+Attributes.h"

@interface NyPgDetailViewController () {
    NSMutableArray *_formulaViews;
    __weak NySymbolView *_tappedSymbolView;
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

#pragma mark - Ny Formula View Data Source
- (NySymbolView*)symbolView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"NyFormulaView" owner:self options:nil];
    NySymbolView *symbolView = [viewArray objectAtIndex:3];
    return symbolView;    
}

- (void)addNewFormulaAtCanvasLocation:(CGPoint)location {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"NyFormulaView" owner:self options:nil];
    NyFormulaView *formualaView = [viewArray objectAtIndex:0];
    //NySymbolView *symbolView = [viewArray objectAtIndex:3];
    
    //[formualaView addSubview:symbolView];
    // symbolView.center = CGPointMake(formualaView.frame.size.width/2.0, symbolView.frame.size.height);
    // formualaView.center = CGPointMake(location.x, location.y + formualaView.frame.size.height/2.0 - symbolView.center.y);
    formualaView.center = CGPointMake(location.x, location.y + formualaView.frame.size.height/2.0);
    
    formualaView.chosen = YES;
    formualaView.locked = NO;
    
    
    [_formulaViews addObject:formualaView];
    
    NyayaNode *node = [NyayaNode atom:@"p"];
    formualaView.node = node;
    formualaView.alpha = 0.0;
    formualaView.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
    
    [self.canvasView addSubview:formualaView];
    
    [UIView animateWithDuration:1.0 animations:^{
        formualaView.alpha = 1.0;
        formualaView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
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
    [UIView animateWithDuration:1.0 animations:^{
        formulaView.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
        formulaView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_formulaViews removeObject:formulaView];
        [formulaView removeFromSuperview];
    }];
    
    
}

#pragma mark - SYMBOLs



- (void)updateSymbolView:(NySymbolView*)symbolView withNode:(NyayaNode*)node {
    if (symbolView.node == node) return; // nothing to do
    
    NyFormulaView *formulaView =  symbolView.formulaView;
    
    NyayaNode *root = formulaView.node;
    NSMutableSet *variables = [root.setOfVariables mutableCopy];
    NyayaNode *newroot = [root nodeByReplacingNodeAtIndexPath:symbolView.indexPath withNode:node];
    newroot = [newroot substitute:variables];
    formulaView.node = newroot;
}

- (void)atomNodeP:(UIMenuController*)ctrl {
    NyayaNode *newNode = [NyayaNode atom:@"p"];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)atomNodeQ:(UIMenuController*)ctrl {
    NyayaNode *newNode = [NyayaNode atom:@"q"];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)atomNodeR:(UIMenuController*)ctrl {
    NyayaNode *newNode = [NyayaNode atom:@"r"];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)atomNodeS:(UIMenuController*)ctrl {
    NyayaNode *newNode = [NyayaNode atom:@"s"];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)atomNodeT:(UIMenuController*)ctrl {
    NyayaNode *newNode = [NyayaNode atom:@"t"];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)negateNode:(UIMenuController*)ctrl {
    NyayaNode *node = _tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode negation: node];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)implicateNode:(UIMenuController*)ctrl {
    NyayaNode *node = _tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode implication:node with:node];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)conjunctNode:(UIMenuController*)ctrl {
    NyayaNode *node = _tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode conjunction:node with:node];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)disjunctNode:(UIMenuController*)ctrl {
    NyayaNode *node = _tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode disjunction:node with:node];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)negation:(UIMenuController*)ctrl {
    NyayaNodeUnary *node = (NyayaNodeUnary*)_tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode negation: [node firstNode]];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)cutout:(UIMenuController*)ctrl {
    NyayaNodeUnary *node = (NyayaNodeUnary*)_tappedSymbolView.node;
    NyayaNode *newNode = [node firstNode];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)implication:(UIMenuController*)ctrl {
    NyayaNodeBinary *node = (NyayaNodeBinary*)_tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode implication:[node firstNode] with:[node secondNode]];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)conjunction:(UIMenuController*)ctrl {
    NyayaNodeBinary *node = (NyayaNodeBinary*)_tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode conjunction:[node firstNode] with:[node secondNode]];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)disjunction:(UIMenuController*)ctrl {
    NyayaNodeBinary *node = (NyayaNodeBinary*)_tappedSymbolView.node;
    NyayaNode *newNode = [NyayaNode disjunction:[node firstNode] with:[node secondNode]];
    [self updateSymbolView:_tappedSymbolView withNode:newNode];
}

- (void)displayFalse:(UIMenuController*)ctrl {
    _tappedSymbolView.displayValue = NyayaFalse;
}
- (void)displayTrue:(UIMenuController*)ctrl {
    _tappedSymbolView.displayValue = NyayaTrue;
}
- (void)displayClear:(UIMenuController*)ctrl {
    _tappedSymbolView.displayValue = NyayaUndefined;
}



#pragma mark - equivalence transformations 

- (void)collapseSymbol:(UIMenuController*)ctrl {
    [self updateSymbolView:_tappedSymbolView withNode:[_tappedSymbolView.node collapsedNode]];
}

- (void)imfSymbol:(UIMenuController*)ctrl {
    [self updateSymbolView:_tappedSymbolView withNode:[_tappedSymbolView.node imfNode]];
}

- (void)nnfSymbol:(UIMenuController*)ctrl {
    [self updateSymbolView:_tappedSymbolView withNode:[_tappedSymbolView.node nnfNode]];
}

- (void)distributeLeft:(UIMenuController*)ctrl {
    [self updateSymbolView:_tappedSymbolView withNode:[_tappedSymbolView.node distributedNodeToIndex:0]];
}

- (void)distributeRight:(UIMenuController*)ctrl {
    [self updateSymbolView:_tappedSymbolView withNode:[_tappedSymbolView.node distributedNodeToIndex:1]];
}

- (void)switchChildren:(UIMenuController*)ctrl {
    [self updateSymbolView:_tappedSymbolView withNode:[_tappedSymbolView.node switchedNode:YES]];
}



#pragma mark - user interaction
- (void)showSymbolMenu:(NySymbolView*)symbolView {
    NyFormulaView *formulaView = symbolView.formulaView;
    _tappedSymbolView = symbolView;
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    NSMutableArray *menuItems = [NSMutableArray array];
    
    if (formulaView.isLocked) {
        NyayaNode *node = symbolView.node;      // level 0
        NSString *key = nil;
        SEL selector = nil;
        
        // collapse
        key = [node collapseKey];
        selector = @selector(collapseSymbol:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
        key = [node switchKey];
        selector = @selector(switchSymbol:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
        // implication free
        key = [node imfKey];
        selector = @selector(imfSymbol:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
        // negation normal form
        
        key = [node nnfKey];
        selector = @selector(nnfSymbol:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
        // conjunctive normal form
        key = [node cnfLeftKey];
        selector = @selector(distributeLeft:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
        key = [node cnfRightKey];
        selector = @selector(distributeRight:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
        
        // disjunctive normal form
        key = [node dnfLeftKey];
        selector = @selector(distributeLeft:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
        key = [node dnfRightKey];
        selector = @selector(distributeRight:);
        if (key) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(key, nil) action:selector]];
        
    }
    else {
        NSString *s = symbolView.node.symbol;
        
        if (symbolView.node.type == NyayaConstant) {
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"p" action:@selector(atomNodeP:)]];
        }

        else if (symbolView.node.type == NyayaVariable) {
            if (![s isEqual:@"p"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"p" action:@selector(atomNodeP:)]];
            if (![s isEqual:@"q"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"q" action:@selector(atomNodeQ:)]];
            if (![s isEqual:@"r"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"r" action:@selector(atomNodeR:)]];
            if (![s isEqual:@"s"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"s" action:@selector(atomNodeS:)]];
            if (![s isEqual:@"t"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"t" action:@selector(atomNodeT:)]];
            
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"¬%@",s] action:@selector(negateNode:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@➞%@",s,s] action:@selector(implicateNode:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@∧%@",s,s] action:@selector(conjunctNode:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@∨%@",s,s] action:@selector(disjunctNode:)]];
            
            
            if (!symbolView.formulaView.hideValuation) {
                [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"📕" action:@selector(displayFalse:)]];
                [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"📗" action:@selector(displayTrue:)]];
                [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"📘" action:@selector(displayClear:)]];
            }
        }
        
        else if (symbolView.node.arity > 0) {  // not a leaf
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"p" action:@selector(atomNodeP:)]]; // reduce to leave
            
            if (![s isEqual:@"¬"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"¬" action:@selector(negation:)]];
            
            if (symbolView.node.arity > 1) {
                if (![s isEqual:@"→"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"→" action:@selector(implication:)]];
                if (![s isEqual:@"∧"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"∧" action:@selector(conjunction:)]];
                if (![s isEqual:@"∨"]) [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"∨" action:@selector(disjunction:)]];
                
                if (![symbolView.node.nodes[0] isEqual:symbolView.node.nodes[1]])
                      [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"🔀" action:@selector(switchChildren:)]];
            }
            
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"¬Φ" action:@selector(negateNode:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Φ➞Φ" action:@selector(implicateNode:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Φ∧Φ" action:@selector(conjunctNode:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Φ∨Φ" action:@selector(disjunctNode:)]];
            
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"✂" action:@selector(cutout:)]];
            
            
        }
        
    }
    
    
    [self becomeFirstResponder];
    
    [menuController setMenuItems:menuItems];
    [menuController setTargetRect:symbolView.frame inView:formulaView];
    [menuController setMenuVisible:YES];
    
    
}



- (IBAction)tapSymbol:(UITapGestureRecognizer *)sender {
    
    NySymbolView *symbolView = (NySymbolView*)sender.view;
    NyFormulaView *formulaView = symbolView.formulaView;
    formulaView.chosen = YES;
    [self deselectOtherFormulas:formulaView];
        
    [UIView animateWithDuration:0.4 animations:^{
        symbolView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                
    } completion:^(BOOL finished) {
        [self showSymbolMenu:symbolView];
        
        [UIView animateWithDuration:0.4 animations:^{
            symbolView.transform = CGAffineTransformIdentity; // CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }];
}

- (IBAction)swipeSymbol:(UISwipeGestureRecognizer *)sender {
    NSLog(@"swipeDownSymbol: %@", [sender.view class]);
    /* NySymbolView *symbolView = (NySymbolView*)sender.view;
    // NyFormulaView *formulaView = (NyFormulaView *)symbolView.superview;
    
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionUp: {
            [UIView animateWithDuration:0.2 animations:^{
                symbolView.transform = CGAffineTransformMakeTranslation(0.0, -10.0);
                
            } completion:^(BOOL finished) {
                [self showSymbolMenu:symbolView];
                
                [UIView animateWithDuration:1.4 animations:^{
                    symbolView.transform = CGAffineTransformIdentity;
                }];
            }];
        }
            
                      break;
        case UISwipeGestureRecognizerDirectionDown:{
            [UIView animateWithDuration:0.4 animations:^{
                symbolView.transform = CGAffineTransformMakeTranslation(0.0, 40.0);
                
            } completion:^(BOOL finished) {
                [self showSymbolMenu:symbolView];
                
                [UIView animateWithDuration:2.8 animations:^{
                    symbolView.transform = CGAffineTransformIdentity; 
                }];
            }];
        }

            break;
        default:
            NSLog(@"%@",sender);
            break;
    } */
}
@end
