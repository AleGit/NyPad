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
    /*
    UIButton *close = (UIButton*)[self.accessoryView viewWithTag:KEY_CLOSE_TAG];
    UIButton *button = (UIButton*)[self.accessoryView viewWithTag:KEY_PROCESS_TAG];
    CGRect c = close.frame;
    CGRect f = button.frame;
    button.frame = CGRectMake(f.origin.x, f.origin.y, c.origin.x - f.origin.x + c.size.width, f.size.height);
     */
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

#pragma mark - firstTest (methods to be overriden)

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)readTestData { @throw [[NSException alloc] initWithName:@"readTestData" reason:@"must be overriden" userInfo:nil]; }

/* CAN BE OVERRIDEN IN SUBCLASSES, SHOULD BE CALLED THEN */
- (void)configureTestContext {
    _succCount = 0;
    _failCount = 0;
}

/* CAN BE OVERRIDEN IN SUBCLASSES */
- (NSString*)testViewNibName { return @"TextTestView"; }

/* SHOULD NOT BE OVERRIDEN IN SUBCLASSES */
- (void)loadTestView:(UIView*)view {
    [[NSBundle mainBundle] loadNibNamed:[self testViewNibName] owner:self options:nil];
    [view insertSubview:self.testView atIndex:1];
    self.testView.frame = CGRectMake(0.0, 44.0, view.frame.size.width, view.frame.size.height);
}

/* CAN BE OVERRIDEN IN SUBCLASSES */
- (void)layoutSubviews:(UIView*)view { }

/* CAN BE OVERRIDEN IN SUBCLASSES */
- (void)configureKeyboard { }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeQALabels {  @throw [[NSException alloc] initWithName:@"writeQALabels" reason:@"must be overriden" userInfo:nil]; }

#pragma mark - nextTest (methods to be overriden)

/* CAN BE OVERRIDEN IN SUBCLASSES */
- (void)clearQuestion {
    self.questionField.text = @"";
    self.answerField.text = @"";
    self.solutionField.text = @"";
    
    self.answerField.backgroundColor = [UIColor whiteColor];
}

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)generateQuestion { @throw [[NSException alloc] initWithName:@"generateQuestion" reason:@"must be overriden" userInfo:nil]; }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeQuestion { @throw [[NSException alloc] initWithName:@"writeQuestion" reason:@"must be overriden" userInfo:nil]; }

/* MAY BE OVERRIDDEN IN SUBCLASSES */
- (void)showKeyboard { [self.answerField becomeFirstResponder]; };

#pragma mark - checkTest (methods to be overriden)

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)readAnswer {  @throw [[NSException alloc] initWithName:@"readAnswer" reason:@"must be overriden" userInfo:nil]; }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)validateAnswer { @throw [[NSException alloc] initWithName:@"validateAnswer" reason:@"must be overriden" userInfo:nil]; }

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeSolution { @throw [[NSException alloc] initWithName:@"writeSolution" reason:@"must be overriden" userInfo:nil]; }

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

- (void)writeSolution {
    self.answerField.backgroundColor = self.success ? [UIColor nyRightColor] : [UIColor nyWrongColor];
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

@end

@implementation NyTuTesterRandomQuestions

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
    
    self.questionTree = [NyayaNode randomTreeWithRootTypes:self.rootTypes
                                               nodeTypes:self.nodeTypes
                                                   lengths:self.lengths
                                               variables:self.variables];
    
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

- (void)configureAccessoryView {
    [super configureAccessoryView];
    [((UIButton*)[self.accessoryView viewWithTag:KEY_SPACE_TAG]) setTitle:@"," forState:UIControlStateNormal];
    
}

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
