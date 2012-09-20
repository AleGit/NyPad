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

- (void)refreshFormulaView:(NyFormulaView*)formulaView {
    [formulaView setNeedsDisplay];

    for (UIView *view in formulaView.subviews) {
        [view setNeedsDisplay];
    }
}

- (void)updateSymbolView:(NySymbolView*)symbolView withNode:(NyayaNode*)node {
    if (symbolView.node == node) return; // nothing to do
    
    NyFormulaView *formulaView =  symbolView.formulaView;
    
    NyayaNode *root = formulaView.node;
    NSMutableSet *variables = [root.setOfVariables mutableCopy];
    NyayaNode *newroot = [root nodeByReplacingNodeAtIndexPath:symbolView.indexPath withNode:node];
    newroot = [newroot substitute:variables];
    formulaView.node = newroot;
    
    [self refreshFormulaView:formulaView];
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
    [self refreshFormulaView:_tappedSymbolView.formulaView];
}
- (void)displayTrue:(UIMenuController*)ctrl {
    _tappedSymbolView.displayValue = NyayaTrue;
    [self refreshFormulaView:_tappedSymbolView.formulaView];
}
- (void)displayClear:(UIMenuController*)ctrl {
    _tappedSymbolView.displayValue = NyayaUndefined;
    [self refreshFormulaView:_tappedSymbolView.formulaView];
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

- (void)switchSymbol:(UIMenuController*)ctrl {
    [self updateSymbolView:_tappedSymbolView withNode:[_tappedSymbolView.node switchedNode]];
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
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"p" action:@selector(atomNodeP:)]];
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"q" action:@selector(atomNodeQ:)]];
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"r" action:@selector(atomNodeR:)]];
        
        if (symbolView.node.arity > 0) { // not a leaf
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"cut out" action:@selector(cutout:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"¬" action:@selector(negation:)]];
        }
        if (symbolView.node.arity > 1) {
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"➞" action:@selector(implication:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"∧" action:@selector(conjunction:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"∨" action:@selector(disjunction:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"switch" action:@selector(switchSymbol:)]];
        }
        
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"¬Φ" action:@selector(negateNode:)]];
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Φ➞Φ" action:@selector(implicateNode:)]];
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Φ∧Φ" action:@selector(conjunctNode:)]];
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Φ∨Φ" action:@selector(disjunctNode:)]];
        
        if (symbolView.node.type == NyayaVariable) {
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"false" action:@selector(displayFalse:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"true" action:@selector(displayTrue:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"clear" action:@selector(displayClear:)]];
        }
        
    }
    
    
    [self becomeFirstResponder];
    
    [menuController setMenuItems:menuItems];
    [menuController setTargetRect:symbolView.frame inView:formulaView];
    [menuController setMenuVisible:YES];
    
    
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(NySymbolView *)context {
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
        /* [self growSymbol:context.supersymbol];
        
        if (!context.supersymbol) {
            
            for (UIView *view in context.superview.subviews) {
                [view setNeedsDisplay];
            }
        }*/
        
        NSLog(@"animationDidStop: %@ finished: %@ context: %f %f", animationID, finished, context.center.x, context.center.y);
    }
}

- (void)growSymbol:(NySymbolView *)symbolView {
    if (!symbolView) return ;
    
    [symbolView setNeedsDisplay];
	
    [UIView beginAnimations:@"growSymbol" context:(void*)symbolView];
	[UIView setAnimationDuration:ANIMADURATION];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    
	symbolView.transform = transform;
	[UIView commitAnimations];
    
}

- (void)moveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(UIView *)context {
    if (![animationID isEqualToString:@"undoMoveSymbol"]) {
        [UIView beginAnimations:@"undoMoveSymbol" context:(void*)context];
        [UIView setAnimationDuration:ANIMADURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(moveAnimationDidStop:finished:context:)];
        context.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        context.alpha = 1.0;
    }
    else {
        [UIView setAnimationDuration:0.0];
        // [self showFormulaMenu:context.center inView:context];
        NSLog(@"animationDidStop: %@ finished: %@ context: %f %f", animationID, finished, context.center.x, context.center.y);
        
    }
}

- (void)moveSymbol:(NySymbolView *)view direction: (CGPoint)direction {
    [UIView beginAnimations:@"moveDownSymbol" context:(void*)view];
	[UIView setAnimationDuration:ANIMADURATION * sqrtf(0.5+sqrtf(direction.x*direction.x+direction.y+direction.y)/40.0) ];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(direction.x, direction.y);
    
	view.transform = transform;
    view.displayValue = (view.displayValue +1) %3;
    view.alpha = 0.0;
    
	[UIView commitAnimations];
    
}


- (IBAction)tapSymbol:(UITapGestureRecognizer *)sender {
    
    NySymbolView *symbolView = (NySymbolView*)sender.view;
    NyFormulaView *formulaView = symbolView.formulaView;
    formulaView.chosen = YES;
    [self deselectOtherFormulas:formulaView];
    
    [self showSymbolMenu:symbolView];
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
