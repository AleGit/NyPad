//
//  NyTuTester.m
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyTuTester.h"
#import "UIColor+Nyaya.h"
#import "UITextField+Nyaya.h"
#import "NyayaNode_Cluster.h"
#import "NyayaNode+Attributes.h"
#import "NyayaNode+Creation.h"
#import "NyayaNode+Derivations.h"
#import "NyayaNode+Description.h"
#import "NyayaNode+Display.h"
#import "NyayaNode+Random.h"
#import "NyayaNode+Type.h"
#import "NyayaNode+Valuation.h"
#import "NyayaConstants.h"

@interface NyTuTester () {
    BOOL _checked;
@protected
    NSString* _testerKey;
    BOOL _success;
}
@end

@interface NyTuTesterPlist () {
    @protected
    NSString *_question;
    NSString *_answer;
    NSString *_solution;
    
}
@end

@implementation NyTuTester


/* **********************************************************************
 @protocol NyTuTester <NSObject> 
 ************************************************************************ */
// properties (override styles in subclasses)
@synthesize delegate;
#pragma mark - ny tester protocol
- (UIModalPresentationStyle)modalPresentationStyle { return UIModalPresentationFormSheet; }
- (UIModalTransitionStyle)modalTransitionStyle { return UIModalTransitionStyleCoverVertical; }
// creation
+ (BOOL)testerExistsForKey:(NSString*)key {
    return [self testerClassForKey:key] != nil;
}
+ (id)testerForKey:(NSString *)key {
    NyTuTester *tester = [[[self testerClassForKey:key] alloc] initWithKey:key];
    return tester;
}
// template methods
- (void)firstTest:(UIView *)view {
    NSLog(@"%@ firstTest", [self class] );
    
    // a) data
    [self readTestData];
    [self configureTestContext];
    
    // b) visuals
    [self loadTestView:view];
    [self layoutSubviews:view];
    [self configureSubviews:view];
    
    [self loadAccessoryView];
    [self configureAccessoryView];
    
    [self configureKeyboard];
    
    // c) labels
    [self writeQALabels];
    
    // d) question
    [self nextTest];
}
- (void)nextTest {
    NSLog(@"%@ nextTest", [self class] );
    
    _checked = NO;
    [processButton setTitle:NSLocalizedString(@"check", nil) forState:UIControlStateNormal];
    
    [self clearQuestion];
    [self hideValidation];
    [self generateQuestion];
    [self writeQuestion];
    [self showKeyboard];
    
    [delegate tester:self didNextTest:YES];
}
-  (void)checkTest {
    NSLog(@"%@ checkTest", [self class] );
    
    _checked = YES;
    [processButton setTitle:NSLocalizedString(@"next", nil) forState:UIControlStateNormal];
    
    [self readAnswer];
    
    [self validateAnswer];
    
    [self writeValidation];
    
    if (_success) _succCount++;
    else _failCount++;
    
    [self writeSolution];
    
    [self.delegate tester:self didCheckTest:YES];
}

- (void)removeTest {
    NSLog(@"%@ removeTest", [self class]);
    
    [self.testView removeFromSuperview];
    [self setTestView:nil];
    [self.delegate tester:self didRemoveTest:YES];
}


#pragma mark - ny accsessory controller
/* **********************************************************************
 @protocol NyAccessoryController <NSObject>
 ************************************************************************ */
// properties
@synthesize accessoryView, backButton, processButton, dismissButton;
// creation (loading)
- (NSString*)accessoryViewNibName { return @"NyBasicKeysView"; };
- (void)loadAccessoryView {
    if ([self accessoryViewShouldBeVisible]) {
        [[NSBundle mainBundle] loadNibNamed:[self accessoryViewNibName] owner:self options:nil];
        [self configureAccessoryView];
    }
    else {
        [self unloadAccessoryView];
    }
}
- (void)configureAccessoryView {
    self.answerField.inputView = self.accessoryView;
    [self.accessoryView viewWithTag:KEY_BACKGROUND_TAG].backgroundColor = [UIColor nyKeyboardBackgroundColor];
    
    UIButton *close = (UIButton*)[self.accessoryView viewWithTag:KEY_CLOSE_TAG];
    UIButton *button = (UIButton*)[self.accessoryView viewWithTag:KEY_PROCESS_TAG];
    CGRect c = close.frame;
    CGRect f = button.frame;
    button.frame = CGRectMake(f.origin.x, f.origin.y, c.origin.x - f.origin.x + c.size.width, f.size.height);
    
}
- (void)unloadAccessoryView {
    self.answerField.inputView = nil;
    self.answerField.inputAccessoryView = nil;
    self.accessoryView = nil;
}

#pragma mark - protocol helpers

// NyTuTester creation (helpers)
+ (NSString*)testerClassNameForKey:(NSString*)key {
    return [NSString stringWithFormat:@"NyTuTester%@", key];
}

+ (Class)testerClassForKey:(NSString*)key {
    return NSClassFromString([self testerClassNameForKey:key]);
}

- (id)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        _testerKey = key;
    }
    return self;
}

// NyAccessoryController creation (helpers, override in subclasses)
- (BOOL)accessoryViewShouldBeVisible { return YES; }

#pragma mark - visual configuration

- (void)configureSubviews:(UIView*)view {
    self.questionField.backgroundColor = [UIColor nyLightGreyColor];
    self.solutionField.backgroundColor = [UIColor nyLightGreyColor];
}

#pragma mark - ny accessory controller protocols

- (IBAction)press:(UIButton *)sender {
    [self.answerField insertText:sender.currentTitle];
}

- (IBAction)process:(UIButton *)sender {
    _checked ? [self nextTest] : [self checkTest];
}

- (IBAction)back:(UIButton *)sender {
    [self.answerField deleteBackward];
}

- (IBAction)dismiss:(UIButton*)sender {
    [self.answerField resignFirstResponder];
}

- (IBAction)parenthesize:(UIButton *)sender {
    [self.answerField parenthesize];
}

- (IBAction)negate:(UIButton *)sender {
    [self.answerField negate];
}

#pragma mark - firstTest (methods to be overridden)

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)readTestData { @throw [[NSException alloc] initWithName:@"readTestData" reason:@"must be overridden" userInfo:nil]; }

/* CAN BE overridden IN SUBCLASSES, SHOULD BE CALLED THEN */
- (void)configureTestContext {
    _succCount = 0;
    _failCount = 0;
}

/* CAN BE overridden IN SUBCLASSES */
- (NSString*)testViewNibName { return @"TextTestView"; }

/* SHOULD NOT BE overridden IN SUBCLASSES */
- (void)loadTestView:(UIView*)view {
    [[NSBundle mainBundle] loadNibNamed:[self testViewNibName] owner:self options:nil];
    [view insertSubview:self.testView atIndex:1];
    self.testView.frame = CGRectMake(0.0, 44.0, view.frame.size.width, view.frame.size.height);
}

/* CAN BE overridden IN SUBCLASSES */
- (void)layoutSubviews:(UIView*)view { }

/* CAN BE overridden IN SUBCLASSES */
- (void)configureKeyboard { }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeQALabels {  @throw [[NSException alloc] initWithName:@"writeQALabels" reason:@"must be overridden" userInfo:nil]; }

#pragma mark - nextTest (methods to be overridden)

/* CAN BE overridden IN SUBCLASSES */
- (void)clearQuestion {
    self.questionField.text = @"";
    self.answerField.text = @"";
    self.solutionField.text = @"";
    
    self.answerField.backgroundColor = [UIColor whiteColor];
}

- (void)hideValidation {
    
    self.okLabel.hidden = YES;
    self.nokLabel.hidden = YES;
    self.validationLabel.text = @"";
    self.validationLabel.hidden = YES;
}

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)generateQuestion { @throw [[NSException alloc] initWithName:@"generateQuestion" reason:@"must be overridden" userInfo:nil]; }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeQuestion { @throw [[NSException alloc] initWithName:@"writeQuestion" reason:@"must be overridden" userInfo:nil]; }

/* MAY BE OVERRIDDEN IN SUBCLASSES */
- (void)showKeyboard { [self.answerField becomeFirstResponder]; };

#pragma mark - checkTest (methods to be overridden)

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)readAnswer {  @throw [[NSException alloc] initWithName:@"readAnswer" reason:@"must be overridden" userInfo:nil]; }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)validateAnswer { @throw [[NSException alloc] initWithName:@"validateAnswer" reason:@"must be overridden" userInfo:nil]; }

- (void)writeValidation {
    self.okLabel.hidden = !self.success;
    self.nokLabel.hidden = self.success;
    self.validationLabel.hidden = self.success;
}

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeSolution { @throw [[NSException alloc] initWithName:@"writeSolution" reason:@"must be overridden" userInfo:nil]; }

- (IBAction)toggleButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (void)animateWrong:(UIView*)view withDelay:(NSTimeInterval)delay {
    [UIView animateWithDuration:0.2f animations:^{
        view.transform = CGAffineTransformMakeRotation(-0.15f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4f delay:delay options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^{
            view.transform = CGAffineTransformMakeRotation(0.15f);
        } completion:nil];
    }];
}

- (void)animateRight: (UIView*)view withDelay:(NSTimeInterval)delay {
    [UIView animateWithDuration:0.4f delay:delay options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^{
        view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:nil];
}

- (void)animateEnd: (UIView*)view {
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

@end

/***************************************************************************************************************************/
#pragma mark - basic implementations

@implementation  NyTuTesterPlist

- (void)readTestData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.testerKey ofType:@"plist"];
    
    self.testDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.questionLabelText = [self.testDictionary objectForKey:@"questionLabelText"];
    self.answerLabelText = [self.testDictionary objectForKey:@"answerLabelText"];
    self.solutionLabelText = [self.testDictionary objectForKey:@"solutionLabelText"];
    self.additionalLabelText = [self.testDictionary objectForKey:@"additionalLabelText"];
    
}

- (void)writeQALabels {
    self.questionLabel.text = self.questionLabelText;
    self.answerLabel.text = self.answerLabelText;
    self.solutionLabel.text = self.solutionLabelText;
    self.additionalLabel.text = self.additionalLabelText;
}


- (void)clearQuestion {
    [super clearQuestion];
    
    _question = nil;
    _answer = nil;
    _solution = nil;
    _success = NO;
    
    self.okLabel.hidden = YES;
    self.nokLabel.hidden = YES;
}

- (void)writeQuestion {
    self.questionField.text = self.question;
}

- (void)readAnswer {
    _answer = self.answerField.text;
    _success = NO;
}

- (void)validateAnswer {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ .,;()]*" options:0 error:nil];
    
    NSString *aca = [regex stringByReplacingMatchesInString:self.solution options:0 range:NSMakeRange(0, [self.solution length]) withTemplate:@""];
    NSString *yan = [regex stringByReplacingMatchesInString:self.answer options:0 range:NSMakeRange(0, [self.answer length]) withTemplate:@""];
    
    _success = [aca compare:yan options:NSCaseInsensitiveSearch|NSWidthInsensitiveSearch] == 0;
}

- (void)writeValidation {
    [super writeValidation];
    
    self.answerField.backgroundColor = self.success ? [UIColor nyRightColor] : [UIColor nyWrongColor];
    
    self.okLabel.hidden = !self.success;
    self.nokLabel.hidden = self.success;
    
}

- (void)writeSolution {
    
    self.solutionField.text = self.solution;
}
@end

/***************************************************************************************************************************/
@implementation NyTuTesterDictionaryQuestions

- (void)importQuestionsDictionary {
    self.questionsDictionary = [self.testDictionary objectForKey:@"questions"];
    
    if (!self.questionsDictionary) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[self.testDictionary objectForKey:@"questionsFile"] ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSUInteger answerIndex = [[self.testDictionary objectForKey:@"solutionIndex"] integerValue];
        NSMutableDictionary *qd = [NSMutableDictionary dictionaryWithCapacity:[array count]];
        for (NSArray* qa in array) {
            if (answerIndex < [qa count]) [qd setObject:[qa objectAtIndex:answerIndex] forKey:[qa objectAtIndex:0]];
        }
        self.questionsDictionary = [qd copy]; // create unmutable copy
    }
}

- (void)readTestData {
    [super readTestData];
    [self importQuestionsDictionary];
}

- (void)generateQuestion {
    NSUInteger idx = arc4random() % [self.questionsDictionary count];
    _question = [[self.questionsDictionary allKeys] objectAtIndex:idx];
    _solution = self.questionsDictionary[_question];
}
@end

/***************************************************************************************************************************/
@interface NyTuTesterRandomQuestions ()

@property BOOL hasWrongSyntax;

- (void)setRootTypes: (NSIndexSet*)rootTypes;
- (void)setNodeTypes: (NSIndexSet*)nodeTypes;
- (void)setLengths: (NSRange)lengths;
- (void)setVariables: (NSArray*)variables;
- (void)setQuestionTree: (NyayaNode*)questionTree;

- (NSRange)testContextLengths;
- (NSUInteger)wrongSyntaxRate; // 0 (NO) ... 100 (ALWAYS)
- (BOOL)changeQuestion;
- (NyayaNode*)randomTree;

@end

@implementation NyTuTesterRandomQuestions

- (NyayaNode*)randomTree {
    return [NyayaNode randomTreeWithRootTypes:self.rootTypes
                             nodeTypes:self.nodeTypes
                               lengths:self.lengths
                             variables:self.variables];
    
}

- (void)setRootTypes:(NSIndexSet *)rootTypes {
    _rootTypes = rootTypes;
}

- (void)setNodeTypes:(NSIndexSet *)nodeTypes {
    _nodeTypes = nodeTypes;
}

- (void)setLengths: (NSRange)lengths {
    _lengths = lengths;
}

- (void)setVariables:(NSArray *)variables {
    _variables = variables;
}

- (void)setQuestionTree:(NyayaNode *)questionTree {
    _questionTree = questionTree;
}

- (void)configureTestContext {
    [super configureTestContext];
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:NyayaNegation];
    [indexSet addIndex:NyayaConjunction];
    [indexSet addIndex:NyayaDisjunction];
    [indexSet addIndex:NyayaImplication];
    
    self.rootTypes = [indexSet copy];
    self.nodeTypes = [indexSet copy];
    self.lengths = [self testContextLengths];
    self.variables = @[@"p", @"q", @"r"];
    
}

- (NSRange)testContextLengths { return NSMakeRange(3,5); }
- (NSUInteger)wrongSyntaxRate { return 15; } // 15 of 100

- (void)generateQuestion {
    self.hasWrongSyntax = NO;
    
    if (self.lengths.length > 3 && self.succCount < self.failCount) {
        self.lengths = NSMakeRange(self.lengths.location, self.lengths.length-1);
        
    }
    
    if (self.succCount > (1+self.failCount)*2 && self.lengths.length < 10) {
        self.lengths = NSMakeRange(self.lengths.location, self.lengths.length+1);
    }
    
    self.questionTree = [self randomTree];
    
    _question = [self.questionTree description];
    _solution = _question;
}

- (BOOL)changeQuestion {
    self.hasWrongSyntax = (arc4random() % 100) < [self wrongSyntaxRate];
    if (self.hasWrongSyntax) {
        NSUInteger length = [_question length];
        NSUInteger loc = length;
        while (loc == length || [@[@" ", @"¬"] containsObject:[_question substringWithRange:NSMakeRange(loc,1)]]) {
            loc = arc4random() % length;
        }
        _question = [[_question stringByReplacingCharactersInRange:NSMakeRange(loc,1) withString:@" "]
                     stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        
    }
    
    return self.hasWrongSyntax;
    
}




- (void)validateAnswer {
    NyayaFormula *answerFormula = [NyayaFormula formulaWithString:_answer];
    
    _success = [_solution isEqualToString:_answer] ||
    [self.questionTree isEqual:[answerFormula syntaxTree:NO]];
}

@end

/**************************************************************************************************************************
 **************************************************************************************************************************/
#pragma mark - Chapter 1

@implementation  NyTuTester11

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation NyTuTester12

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation  NyTuTester13

- (void)validateAnswer {
    NyayaFormula *solutionFormula = [NyayaFormula formulaWithString:self.solution];
    NyayaFormula *answerFormula = [NyayaFormula formulaWithString:self.answer];
    
    _success = [[solutionFormula truthTable:YES] isEqual:[answerFormula truthTable:YES]];
}

@end

#pragma mark - Chapter 2

// syntax conventions

@implementation NyTuTester21

- (NSRange)testContextLengths { return NSMakeRange(1,4);}

- (void)generateQuestion {
    [super generateQuestion];
    _question = [self.questionTree testDescription];
    if ([self changeQuestion]) {
        _solution = @"";
    }
    else {
        _solution = self.questionTree.symbol;
    }
}
/*
- (void)validateAnswer {
    _success = [_solution isEqualToString:[self.answer stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
}*/
@end

// syntax conventions
@implementation NyTuTester22


- (void)generateQuestion {
    [super generateQuestion];
    _question = [self.questionTree description];
    
    if ([self changeQuestion]) {
        _solution = @"";
    }
    else {
        _solution = [self.questionTree testDescription];
    }
}


- (void)validateAnswer {
    _success = [_solution isEqualToString:_answer]
    || [[self.questionTree strictDescription] isEqualToString:
        [self.answer stringByReplacingOccurrencesOfString:@" " withString:@""]];
}


@end

// sub-formulas
@implementation NyTuTester23

- (NSRange)testContextLengths {
    return NSMakeRange(3,2);
}

- (void)generateQuestion {
    [super generateQuestion];
    _solution = [[[self.questionTree setOfSubformulas] allObjects] componentsJoinedByString:@", "] ;
}

- (void)validateAnswer {
    NSMutableSet *solutionSubformulas = [NSMutableSet set];
    NSMutableSet *answerSubformulas = [NSMutableSet set];
    
    for (NSString *sf in [self.questionTree setOfSubformulas]) {
        NyayaFormula *formula = [NyayaFormula formulaWithString:sf];
        [solutionSubformulas addObject:[formula syntaxTree:NO]];
    }
    
    NSUInteger count = 0;
    for (NSString *sf in  [self.answer componentsSeparatedByString:@","]) {
        NyayaFormula *formula = [NyayaFormula formulaWithString:sf];
        [answerSubformulas addObject:[formula syntaxTree:NO]];
        count++;
    }
    _success = [solutionSubformulas count] == count && [solutionSubformulas isEqual:answerSubformulas];
    
}


@end

// syntax tree
@implementation NyTuTester24

- (NyNodeView*)symbolView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"NyTreeView" owner:self options:nil];
    NyNodeView *symbolView = [viewArray objectAtIndex:3];
    return symbolView;
}

// - (UIModalPresentationStyle)modalPresentationStyle { return UIModalPresentationPageSheet; }
- (NSString*)testViewNibName { return @"SyntaxTreeTestView"; }

- (void)layoutSubviews:(UIView*)view {
    CGPoint location = CGPointMake(self.canvasView.center.x, 20.0);
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"NyTreeView" owner:self options:nil];
    _syntaxTreeView = [viewArray objectAtIndex:0];
        // formualaView.center = CGPointMake(location.x, location.y + formualaView.frame.size.height/2.0 - symbolView.center.y);
    _syntaxTreeView.center = CGPointMake(location.x, location.y + _syntaxTreeView.frame.size.height/2.0);
    
    _syntaxTreeView.hideCloser = YES;
    _syntaxTreeView.hideHeader = YES;
    _syntaxTreeView.hideLock = YES;
    _syntaxTreeView.hideValuation = YES;
    
    [self.canvasView addSubview:_syntaxTreeView];
    
    _syntaxTreeView.delegate = nil;
    // syntaxTreeView.dataSource = nil;
}

- (NSUInteger)wrongSyntaxRate { return 0; }

- (void)writeQuestion {
    self.syntaxTreeView.node = self.questionTree;
}

- (void)dragFormula:(UIPanGestureRecognizer *)sender {
    
}

- (void)selectFormula:(UITapGestureRecognizer *)sender {
    
}

- (void)swipeSymbol:(UISwipeGestureRecognizer *)sender {
    
}

- (void)deleteFormula:(UIButton *)sender {
    
}

- (void)lockFormula:(UIButton *)sender {
    
}

- (void)tapSymbol:(UITapGestureRecognizer *)sender {
    
}

@end

@implementation NyTuTester25


- (void)configureAccessoryView {
    [super configureAccessoryView];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_TRUE_TAG] setTitle:@"⊤" forState:UIControlStateNormal];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_FALSE_TAG] setTitle:@"⊥" forState:UIControlStateNormal];
}

- (NSString*)accessoryViewNibName { return @"NyTrueFalseKeysView"; }

- (NyayaNode *)switchNodes:(NyayaNode*)P {
    NyayaNode *P0 = nil;
    switch (P.type) {
        case NyayaNegation:                 // P
            P0 = P.nodes[0];                // ¬Q
            if (P0.type == NyayaNegation)   // ¬¬R
                return P0.nodes[0];         // return R
            else
                return [NyayaNode negation: [self switchNodes:P0]];
            break;
        
        case NyayaConjunction:
            return [NyayaNode conjunction:P.nodes[1] with:P.nodes[0]];
            break;
        
        case NyayaDisjunction:
            return [NyayaNode disjunction:P.nodes[1] with:P.nodes[0]];
            break;
            
        default:
            return P;
    }
    
}

- (void)generateQuestion {
    [super generateQuestion];
    // tautology or contradiction?
    
    NyayaNode *P = self.questionTree;
    NyayaNode *NP = [NyayaNode negation:P];
    
    switch (arc4random() % 3) {
        case 0:
            P = [self switchNodes:P];
            break;
        case 1:
            NP = [self switchNodes:NP];
            break;
        case 2:
        default:
            break;
    }
    
    switch (arc4random() % 10) {
        case 0: // P ∨ ¬P
            self.questionTree = [NyayaNode disjunction:P with:NP];
            _solution = @"⊤";
            break;
        case 1: // ¬P ∨ P
            self.questionTree = [NyayaNode disjunction:NP with:P];
            _solution = @"⊤";
            break;
        case 2: // P → P
            self.questionTree = [NyayaNode implication:P with:P];
            _solution = @"⊤";
            break;
        case 3: // P ∧ ¬P
            self.questionTree = [NyayaNode conjunction:P with:NP];
            _solution = @"⊥";
            break;
        case 4: // ¬P ∧ P
            self.questionTree = [NyayaNode conjunction:NP with:P];
            _solution = @"⊥";
            break;
            
        case 5: // P ∨ P
            self.questionTree = [NyayaNode disjunction:P with:P];
            _solution = @"";
            break;
        case 6: // ¬P ∨ ¬P
            self.questionTree = [NyayaNode disjunction:NP with:NP];
            _solution = @"";
            break;
        case 7: // P → ¬P
            self.questionTree = [NyayaNode implication:P with:NP];
            _solution = @"";
            break;
        case 8: // P ∧ P
            self.questionTree = [NyayaNode conjunction:P with:P];
            _solution = @"";
            break;
        case 9: // ¬P ∧ ¬P
            self.questionTree = [NyayaNode conjunction:NP with:NP];
            _solution = @"";
            break;
        
    }
        
    _question = [self.questionTree description];
}

- (void)validateAnswer {
    _success = [_solution isEqualToString:_answer];
}
@end

#pragma mark - Chapter 3 semantics

@implementation NyTuTester31

- (NSString*)accessoryViewNibName { return @"NyTrueFalseKeysView"; }

- (void)generateQuestion {
    [super generateQuestion];
    NSMutableString *question = [[self.questionTree description] mutableCopy];
    [question appendString:@" 🔹"];
    NSSet *set = [self.questionTree setOfVariables];
    __block BOOL first = YES;
    
    [set enumerateObjectsUsingBlock:^(NyayaNodeVariable *variable, BOOL *stop) {
        variable.evaluationValue = (BOOL)(arc4random() % 2);
        
        if (!first) [question appendString:@","];
        
        if (variable.evaluationValue) {
            [question appendFormat:@" v(%@)=T ", variable.symbol ];
        }
        else {
            [question appendFormat:@" v(%@)=F ", variable.symbol];
        }
        
        first = NO;
        
    }];
    _question = [question copy];
    
    if (self.questionTree.evaluationValue)
        _solution = @"T";
    else
        _solution = @"F";
}

@end

@interface NyTuTester32 ()
@property (strong, nonatomic) NSArray *valueNodes;
@end

@implementation NyTuTester32

- (NSString*)accessoryViewNibName { return @"NyTrueFalseKeysView"; }
- (NSString*)testViewNibName { return @"TruthTableTestView"; }

- (void)configureTestContext {
    [super configureTestContext];

    NSMutableIndexSet *indexSet = [self.rootTypes mutableCopy];
    [indexSet addIndex:NyayaConstant];
    self.rootTypes = [indexSet copy];
    self.nodeTypes = [indexSet copy];
}

// first test

- (void)configureSubviews:(UIView*)view {
    self.questionField.backgroundColor = [UIColor nyLightGreyColor];
    
    __block BOOL active = YES;
    void (^block)(id obj, NSUInteger idx, BOOL *stop) = ^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (active) [button addTarget:(self) action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tintColor = [UIColor nyLightGreyColor];
        [button setTitle:@"F" forState:UIControlStateNormal];
        [button setTitle:@"T" forState:UIControlStateSelected];
    };
    
    [self.ftButtons enumerateObjectsUsingBlock: block];
    active = NO;
    [self.solutionButtons enumerateObjectsUsingBlock:block];
    
    [self.fields3 enumerateObjectsUsingBlock:^(UITextView *textView, NSUInteger idx, BOOL *stop) {
        textView.backgroundColor = [UIColor nyLightGreyColor];
    }];
    
    [self.fields2 enumerateObjectsUsingBlock:^(UITextView *textView, NSUInteger idx, BOOL *stop) {
        textView.backgroundColor = [UIColor nyLightGreyColor];
    }];
    
    [self.fields1 enumerateObjectsUsingBlock:^(UITextView *textView, NSUInteger idx, BOOL *stop) {
        textView.backgroundColor = [UIColor nyLightGreyColor];
    }];

}

// next test

- (void)clearQuestion {
    self.questionField.text = @"";
    [self.ftButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = NO;
        button.highlighted = NO;
        [self animateEnd:button];
        
        
        
    }];
}

- (void)writeQuestion {
    self.questionField.text = [[[self.questionTree description] stringByReplacingOccurrencesOfString:@"T" withString:@"⊤"]
                               stringByReplacingOccurrencesOfString:@"F" withString:@"⊥"];
    
    self.valueNodes = [[self.questionTree setOfVariables] allObjects];
    NSUInteger valuesCount = [self.valueNodes count];
    
    switch (valuesCount) {
        case 3:
            self.variable3.text = [[self.valueNodes objectAtIndex:2] symbol];
        case 2:
            self.variable2.text = [[self.valueNodes objectAtIndex:1] symbol];
        case 1:
            self.variable1.text = [[self.valueNodes objectAtIndex:0] symbol];
    };
    
    __block BOOL hide;
    
    void (^block)(id obj, NSUInteger idx, BOOL *stop) = ^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.hidden = hide;
    };
    
    hide = NO;    
    switch (valuesCount) {
        case 3:
            [self.fields3 enumerateObjectsUsingBlock: block];
            [self.buttons3 enumerateObjectsUsingBlock: block];
        case 2:
            [self.fields2 enumerateObjectsUsingBlock: block];
            [self.buttons2 enumerateObjectsUsingBlock: block];
        case 1:
            [self.fields1 enumerateObjectsUsingBlock: block];
            [self.buttons1 enumerateObjectsUsingBlock: block];
    }

    hide = YES;
    [self.solutionButtons enumerateObjectsUsingBlock:block];

    switch (valuesCount) {
        case 0:
            [self.fields1 enumerateObjectsUsingBlock: block];
            [self.buttons1 enumerateObjectsUsingBlock: block];
        case 1:
            [self.fields2 enumerateObjectsUsingBlock: block];
            [self.buttons2 enumerateObjectsUsingBlock: block];
        case 2:
            [self.fields3 enumerateObjectsUsingBlock: block];
            [self.buttons3 enumerateObjectsUsingBlock: block];
    }
}

// check test

- (void)readAnswer {
    
}



- (void)validateAnswer {
    _success = YES;
    
    NSUInteger count = [self.valueNodes count];
    NSUInteger rows = 1 << count;
    
    [self.ftButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button.tag < rows) {          
            NSUInteger value = rows - button.tag-1;
            
            switch (count) {
                case 3:
                    ((NyayaNodeVariable*)self.valueNodes[2]).evaluationValue = value & 4 ? YES : NO;
                case 2:
                    ((NyayaNodeVariable*)self.valueNodes[1]).evaluationValue = value & 2 ? YES : NO;
                case 1:
                    ((NyayaNodeVariable*)self.valueNodes[0]).evaluationValue = value & 1 ? YES : NO;
            }
            
            if (button.isSelected != self.questionTree.evaluationValue) {
                
                [self animateWrong:button withDelay:0.1*(float)button.tag];
                _success = NO;
            }
            
            else {
                [self animateRight:button withDelay:0.1*(float)button.tag];
            }
        }
    }];
    
}

- (void)writeSolution {
    NSUInteger count = [self.valueNodes count];
    NSUInteger rows = 1 << count;
    
    NSLog(@"count=%u rows=%u", count, rows);
    
    [self.solutionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button.tag < rows) {
            button.hidden = NO;
            
            NSUInteger value = rows - button.tag-1;

            switch (count) {
                case 3:
                    ((NyayaNodeVariable*)self.valueNodes[2]).evaluationValue = value & 4 ? YES : NO;
                case 2:
                    ((NyayaNodeVariable*)self.valueNodes[1]).evaluationValue = value & 2 ? YES : NO;
                case 1:
                    ((NyayaNodeVariable*)self.valueNodes[0]).evaluationValue = value & 1 ? YES : NO;
            }
            
            button.selected = (self.questionTree.evaluationValue);
        }
    }];
    
    
    
    
}
@end

@implementation NyTuTester33

- (void)readTestData {
    [super readTestData];
    
    NSString *filename = [self.testDictionary objectForKey:@"questionsFile"];
    
    if (filename) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        self.questionsArray = [NSArray arrayWithContentsOfFile:filePath];
    }
}

- (void)generateTableQuestion {
    NSUInteger idx = arc4random() % [self.questionsArray count];
    _question = [self.questionsArray objectAtIndex:idx];
}

- (void)generateRandomEquivalentQuestion {
    _question = [NSString stringWithFormat:@"%@ ≡ %@", [[self randomTree] description], [[self randomTree] description]];
}

- (void)generateRandomeEntailmentQuestion {
    NSMutableString *s = [NSMutableString string];
    while ([s length] < arc4random() % 25) {
        if ([s length] > 0) [s appendString:@"; "];
        [s appendString:[[self randomTree] description]];
    }
    
    [s appendString:[s length] == 0 ? @"⊨ " : @" ⊨ "];
    [s appendString:[[self randomTree] description]];
    
    _question = s;
}

- (void)generateQuestion {
    
    BOOL holds = NO;
    
    
    switch (arc4random() % 3) {
            
        default:
        case 0:
            [self generateTableQuestion];
            break;
        case 1:
            [self generateRandomEquivalentQuestion];
            break;
        case 2:
            [self generateRandomeEntailmentQuestion];
            break;
    }
    
    if ([_question hasPrefix:@"⊨ "]) holds = YES;
    else {
        
        NyayaParser *parser = [NyayaParser parserWithString:_question];
        NyayaNode *tree = [parser parseFormula];
        self.answerField.text = [tree description];
        TruthTable *tt = [[TruthTable alloc] initWithNode:tree];
        [tt evaluateTable];
        if ([tt isTautology]) holds = YES;
        else holds = NO;
    }
    
    
    if (holds) _solution = NSLocalizedString(@"HOLDS", nil);
    else _solution = NSLocalizedString(@"DOES_NOT_HOLD", nil);
    
    
}



@end

@interface NyTuTester34 () {
    BOOL _valid;
    BOOL _satis;
    
}
@end

@implementation NyTuTester34

- (NSString*)testViewNibName { return @"Test34View"; }

- (void)clearQuestion {
    [super clearQuestion];
    [self animateEnd:self.validSwitch];
    [self animateEnd:self.satisSwitch];
    
    self.validSwitch.on = NO;
    self.satisSwitch.on = NO;
}

- (void)validateAnswer {
    
    NyayaParser *parser = [NyayaParser parserWithString:_question];
    NyayaNode *tree = [parser parseFormula];
    TruthTable *tt = [[TruthTable alloc] initWithNode:tree];
    [tt evaluateTable];
    _valid = [tt isTautology];
    _satis = [tt isSatisfiable];
    
    if (_valid) _solution = NSLocalizedString(@"VALID_AND_SATISFIABLE", nil);
    else if (_satis) _solution = NSLocalizedString(@"NOT VALID, BUT SATISFIABLE", nil);
    else _solution = NSLocalizedString(@"NOT_VALID, NOT_SATISFIABLE", nil);
    
    self.validationLabel.text = _solution;
    
    if (self.validSwitch.isOn != _valid) {
        [self animateWrong:self.validSwitch withDelay:0.0];
    }
    
    if (self.satisSwitch.isOn != _satis) {
        [self animateWrong:self.satisSwitch withDelay:0.0];
        
    }
    
    _success = self.validSwitch.isOn == _valid && self.satisSwitch.isOn == _satis;
    
}

@end

#pragma mark - Chapter 4 normal forms

@implementation NyTuTester40
- (NyayaNode*)answerTree {
    NyayaParser *parser = [NyayaParser parserWithString:self.answerField.text];
    NyayaNode* node = [parser parseFormula];
    if (parser.hasErrors) return nil;
    else return node;
}
- (NyayaNode*)solutionTree {
    return self.questionTree;
}

- (BOOL)questionAndAnswerAreEquivalent {
    if (!self.questionTree && !self.answerTree) return YES;
    else if (!self.questionTree) return NO;
    else if (!self.answerTree) return NO;
    else {
        TruthTable *tq = [[TruthTable alloc] initWithNode:self.questionTree];
        TruthTable *ta = [[TruthTable alloc] initWithNode:self.answerTree];
        
        return [ta isEqual:tq];
    }
}

- (BOOL)questionIsInNormalForm { @throw [[NSException alloc] initWithName:@"answerIsInNormalForm" reason:@"must be overidden" userInfo:nil]; }
- (BOOL)answerIsInNormalForm { @throw [[NSException alloc] initWithName:@"answerIsInNormalForm" reason:@"must be overidden" userInfo:nil]; }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (NSString*)localizedNotInNormalForm { @throw [[NSException alloc] initWithName:@"localizedNotInNormalForm" reason:@"must be overidden" userInfo:nil]; }

- (NSString*)localizedAnswerIsMissing { return NSLocalizedString(@"ANSWER_IS_MISSING", nil); }

- (NSString*)localizedQuestionAndAnswerAreNotEquivalent { return NSLocalizedString(@"QUESTION_AND_ANSWER_ARE_NOT_EQUIVALENT", nil); };

- (void)validateAnswer {
    
    NSMutableString *s = [NSMutableString string];
    
    if ([self questionIsInNormalForm] && [self.answerField.text length] == 0) {
        _success = YES;
    }
    else if ([self.answerField.text length] == 0) {
        _success = NO;
        [s appendString: [self localizedAnswerIsMissing]];
    }
    else if (![self answerIsInNormalForm]) {
        _success = NO;
        [s appendString: [self localizedNotInNormalForm]];
    }
    else if (![self questionAndAnswerAreEquivalent]) {
        _success = NO;
        [s appendString: [self localizedQuestionAndAnswerAreNotEquivalent]];
    }
    else {
        _success = YES;
    }
    self.validationLabel.text = s;
}

- (void)writeSolution {
    self.solutionField.text = [self.solutionTree description];
}
@end

@implementation NyTuTester41

- (NSString*)localizedNotInNormalForm {
    return NSLocalizedString(@"NOT_IMPLICATION_FREE", nil);
}

- (BOOL)questionIsInNormalForm {
    return [self.questionTree isImplicationFree];
}

- (BOOL)answerIsInNormalForm {
    return [self.answerTree isImplicationFree];
}

- (NyayaNode*)solutionTree {
    return [super.solutionTree deriveImf:NSIntegerMax];
}
@end

@implementation NyTuTester42

- (NSString*)localizedNotInNormalForm {
    return NSLocalizedString(@"NOT_IN_NEGATION_NORMAL_FORM", nil);
}

- (BOOL)questionIsInNormalForm {
    return [self.questionTree isNegationNormalForm];
}

- (BOOL)answerIsInNormalForm {
    return [self.answerTree isNegationNormalForm];
}

- (NyayaNode*)solutionTree {
    return [super.solutionTree deriveImf:NSIntegerMax];
}
@end

@implementation NyTuTester43

- (NSString*)localizedNotInNormalForm {
    return NSLocalizedString(@"NOT_IN_CUNJUNCTIVE_NORMAL_FORM", nil);
}

- (BOOL)questionIsInNormalForm {
    return [self.questionTree isConjunctiveNormalForm];
}

- (BOOL)answerIsInNormalForm {
    return [self.answerTree isConjunctiveNormalForm];
}

- (NyayaNode*)solutionTree {
    return [super.solutionTree deriveCnf:NSIntegerMax];
}
@end

@implementation NyTuTester44

- (NSString*)localizedNotInNormalForm {
    return NSLocalizedString(@"NOT_IN_DISJUNCTOON_NORMAL_FORM", nil);
}

- (BOOL)questionIsInNormalForm {
    return [self.questionTree isDisjunctiveNormalForm];
}

- (BOOL)answerIsInNormalForm {
    return [self.answerTree isDisjunctiveNormalForm];
}

- (NyayaNode*)solutionTree {
    return [super.solutionTree deriveDnf:NSIntegerMax];
}
@end

#pragma mark - Chapter 5 binary decisions
@implementation NyTuTester50

- (NSString*)boolarizeString:(NSString*)text {
    NSMutableString *qm = [text mutableCopy];
    
    [qm replaceOccurrencesOfString:@"T" withString:@"1" options:0 range: NSMakeRange(0, [qm length])];
    [qm replaceOccurrencesOfString:@"F" withString:@"0" options:0 range: NSMakeRange(0, [qm length])];
    [qm replaceOccurrencesOfString:@"¬" withString:@"!" options:0 range: NSMakeRange(0, [qm length])];
    [qm replaceOccurrencesOfString:@"∧" withString:@"•" options:0 range: NSMakeRange(0, [qm length])];
    [qm replaceOccurrencesOfString:@"∨" withString:@"+" options:0 range: NSMakeRange(0, [qm length])];
    [qm replaceOccurrencesOfString:@"⊻" withString:@"⊕" options:0 range: NSMakeRange(0, [qm length])];
    
    return qm;
    
}
@end

@implementation NyTuTester51

- (NSRange)testContextLengths {
    return NSMakeRange(5,3);
}

- (NSString*)accessoryViewNibName { return @"NyTrueFalseKeysView"; }

- (void)configureAccessoryView {
    [super configureAccessoryView];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_TRUE_TAG] setTitle:@"1" forState:UIControlStateNormal];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_FALSE_TAG] setTitle:@"0" forState:UIControlStateNormal];
}

- (void)configureTestContext {
    [super configureTestContext];

    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:NyayaConjunction];
    [indexSet addIndex:NyayaDisjunction];
    [indexSet addIndex:NyayaXdisjunction];
    // [indexSet addIndex:NyayaNegation];
    
    self.rootTypes = [indexSet copy];
    self.nodeTypes = [indexSet copy];
    self.lengths = [self testContextLengths];
    self.variables = @[]; // no variables
    
}

- (void)generateQuestion {
    [super generateQuestion];
    _question = [self boolarizeString:[self.questionTree strictDescription]];    
    _solution = self.questionTree.evaluationValue ? @"1" : @"0";
}
@end

@implementation NyTuTester52

- (void)configureAccessoryView {
    [super configureAccessoryView];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_NOT_TAG] setTitle:@"!" forState:UIControlStateNormal];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_AND_TAG] setTitle:@"•" forState:UIControlStateNormal];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_OR_TAG] setTitle:@"+" forState:UIControlStateNormal];
    [(UIButton*)[self.accessoryView viewWithTag:KEY_IMP_TAG] setTitle:@"⊕" forState:UIControlStateNormal];
}



- (void)generateQuestion {
    [super generateQuestion];
    _solution = [self boolarizeString:[[self.questionTree deriveImf:NSIntegerMax] description]];
}

- (void)validateAnswer {
    NyayaFormula *solutionFormula = [NyayaFormula formulaWithString:self.solution];
    NyayaFormula *answerFormula = [NyayaFormula formulaWithString:self.answer];
    
    _success = [[solutionFormula truthTable:YES] isEqual:[answerFormula truthTable:YES]];
}
@end



@implementation NyTuTester53
- (NSString*)testViewNibName { return @"BinaryTreeTestView"; }

- (void)clearQuestion{
    [self.binaryButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        [self animateEnd:obj];
        obj.selected = NO;
    }];
}


- (void)configureSubviews:(UIView*)view {
    [super configureSubviews:view];
    
    void (^block)(id obj, NSUInteger idx, BOOL *stop) = ^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button addTarget:(self) action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tintColor = [UIColor nyLightGreyColor];
        [button setTitle:@"0" forState:UIControlStateNormal];
        [button setTitle:@"1" forState:UIControlStateSelected];
    };
    
    [self.binaryButtons enumerateObjectsUsingBlock:block];
    
        
    NyayaFormula *formula = [NyayaFormula formulaWithString:@"p+q+r"];
    BddNode *bdd = [formula OBDD:NO];
    self.BddView.bddNode = bdd;
    
    self.BddView.backgroundColor = nil;
    [self.BddView setNeedsDisplay];

    
    
}

- (void)validateAnswer {
    NSSet *vars = [self.questionTree setOfVariables];
    _success = YES;
    
    [self.binaryButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        BOOL p,q,r;
        NSInteger value = button.tag;
        
        p = value & 4 ? YES : NO;
        q = value & 2 ? YES : NO;
        r = value & 1 ? YES : NO;
        
        
        [vars enumerateObjectsUsingBlock:^(NyayaNodeVariable *node, BOOL *stop) {
            if ([node.symbol isEqualToString:@"p"]) node.evaluationValue = p;
            else if ([node.symbol isEqualToString:@"q"]) node.evaluationValue = q;
            else if ([node.symbol isEqualToString:@"r"]) node.evaluationValue = r;
        }];
        
        
        if (button.isSelected != self.questionTree.evaluationValue) {
            [self animateWrong:button withDelay:0.0];
            _success = NO;

        }
        else {
            [self animateRight:button withDelay:0.0];
        }
        
    }];
}


@end

// @implementation NyTuTester54
//- (NSString*)testViewNibName { return @"BinaryTreeTestView"; }
//@end

