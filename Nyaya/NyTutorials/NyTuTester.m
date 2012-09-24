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

// NyTuTester protocol properties
@synthesize delegate;

// NyAccessoryDelegate protocol properties
@synthesize accessoryView, backButton, processButton, dismissButton;

+ (NSString*)testerClassNameForKey:(NSString*)key {
    return [NSString stringWithFormat:@"NyTuTester%@", key];
}

+ (Class)testerClassForKey:(NSString*)key {
    return NSClassFromString([self testerClassNameForKey:key]);
}

+ (BOOL)testerExistsForKey:(NSString*)key {
    return [self testerClassForKey:key] != nil;
}

+ (id)testerForKey:(NSString *)key {
    NyTuTester *tester = [[[self testerClassForKey:key] alloc] initWithKey:key];
    return tester;
}

- (id)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        _testerKey = key;
    }
    return self;
}

// default
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFormSheet;
}

// default
- (UIModalTransitionStyle)modalTransitionStyle {
    return UIModalTransitionStyleCoverVertical;
}

- (NSString*)testViewNibName {
    return @"StandardTestView";
}

// default
- (void)loadTestView:(UIView*)view {
    [[NSBundle mainBundle] loadNibNamed:[self testViewNibName] owner:self options:nil];
    [view insertSubview:self.testView atIndex:1];
    self.testView.frame = CGRectMake(0.0, 44.0, view.frame.size.width, view.frame.size.height);
}

- (void)layoutSubviews:(UIView*)view {
    
}

- (void)configureSubviews:(UIView*)view {
    self.questionField.backgroundColor = [UIColor nyLightGreyColor];
    self.solutionField.backgroundColor = [UIColor nyLightGreyColor];
}

#pragma mark - ny accessory controller protocols

- (BOOL)accessoryViewShouldBeVisible {
    return YES;
}

- (void)loadAccessoryView {
    if ([self accessoryViewShouldBeVisible]) {
        [[NSBundle mainBundle] loadNibNamed:@"NyBasicKeysView" owner:self options:nil];
        [self configureAccessoryView];
    }
    else {
        [self unloadAccessoryView];
    }
}



- (void)configureAccessoryView {
    self.answerField.inputView = self.accessoryView;
    [self.accessoryView viewWithTag:100].backgroundColor = [UIColor nyKeyboardBackgroundColor];
}

- (void)unloadAccessoryView {
    
    self.answerField.inputView = nil;
    self.answerField.inputAccessoryView = nil;
    self.accessoryView = nil;
    
}

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

#pragma mark -

- (void)configureKeyboard {
    // [self.inputField addTarget:self action:@selector(action:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

#pragma mark - template methods …Test
// a.) load and configure views for presenting test questions, validations and solutions
// b.) call next test
- (void)firstTest:(UIView *)view {
    NSLog(@"%@ firstTest", [self class] );
    
    // a.)
    
    [self loadTestView:view];
    [self layoutSubviews:view];
    [self configureSubviews:view];
    
    [self loadAccessoryView];
    [self configureAccessoryView];
    
    [self configureKeyboard];
    
    [self writeQALabels];
    
    // b.)
    [self nextTest];
}

- (void)clearQuestion {
    self.questionField.text = @"";
    self.answerField.text = @"";
    self.solutionField.text = @"";
    
    self.answerField.backgroundColor = [UIColor whiteColor];
}

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeQALabels {
    @throw [[NSException alloc] initWithName:@"writeQALabels" reason:@"must be overriden" userInfo:nil];
}

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)generateQuestion {
    @throw [[NSException alloc] initWithName:@"generateQuestion" reason:@"must be overriden" userInfo:nil];
}

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeQuestion {
    @throw [[NSException alloc] initWithName:@"writeQuestion" reason:@"must be overriden" userInfo:nil];
}

- (void)nextTest {
    NSLog(@"%@ nextTest", [self class] );
    _checked = NO;
    [processButton setTitle:NSLocalizedString(@"check", nil) forState:UIControlStateNormal];
    
    [self clearQuestion];
    [self generateQuestion];
    [self writeQuestion];
   
    [delegate tester:self didNextTest:YES];
}

/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)readAnswer {
    @throw [[NSException alloc] initWithName:@"readAnswer" reason:@"must be overriden" userInfo:nil];
}
/* MUST BE OVERRIDDEN IN SUBCLASSES */

- (void)validateAnswer {
    @throw [[NSException alloc] initWithName:@"validateAnswer" reason:@"must be overriden" userInfo:nil];
}
/* MUST BE OVERRIDDEN IN SUBCLASSES */
- (void)writeSolution {
    @throw [[NSException alloc] initWithName:@"writeSolution" reason:@"must be overriden" userInfo:nil];
}

-  (void)checkTest {
    NSLog(@"%@ checkTest", [self class] );
    
    _checked = YES;
    [processButton setTitle:NSLocalizedString(@"next", nil) forState:UIControlStateNormal];    
    
    [self readAnswer];
    [self validateAnswer];
    [self writeSolution];
    
    [self.delegate tester:self didCheckTest:YES];
}

- (void)removeTest {
    NSLog(@"%@ removeTest", [self class]);
    
    [self.testView removeFromSuperview];
    [self setTestView:nil];
    [self.delegate tester:self didRemoveTest:YES];
}

#pragma mark -


@end

@implementation  NyTuTesterPlist

- (id) initWithKey:(NSString*)key {
    self = [super initWithKey:key];
    if (self) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.testerKey ofType:@"plist"];
        
        self.testDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        self.questionsDictionary = [self.testDictionary objectForKey:@"questions"];
        
        if (!self.questionsDictionary) {
            filePath = [[NSBundle mainBundle] pathForResource:[self.testDictionary objectForKey:@"questionsFile"] ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
            NSUInteger answerIndex = [[self.testDictionary objectForKey:@"solutionIndex"] integerValue];
            NSMutableDictionary *qd = [NSMutableDictionary dictionaryWithCapacity:[array count]];
            for (NSArray* qa in array) {
                if (answerIndex < [qa count]) [qd setObject:[qa objectAtIndex:answerIndex] forKey:[qa objectAtIndex:0]];
            }
            self.questionsDictionary = [qd copy]; // create unmutable copy
        }
        
        self.questionLabelText = [self.testDictionary objectForKey:@"questionLabelText"];
        self.answerLabelText = [self.testDictionary objectForKey:@"answerLabelText"];
        self.solutionLabelText = [self.testDictionary objectForKey:@"solutionLabelText"];
    }
    return self;
}

- (void)writeQALabels {
    self.questionLabel.text = self.questionLabelText;
    self.answerLabel.text = self.answerLabelText;
    self.solutionLabel.text = self.solutionLabelText;
}


- (void)clearQuestion {
    [super clearQuestion];
    
    _question = nil;
    _answer = nil;
    _solution = nil;
    _success = NO;
}

- (void)generateQuestion {
    NSUInteger idx = arc4random() % [self.questionsDictionary count];
    _question = [[self.questionsDictionary allKeys] objectAtIndex:idx];
    _solution = self.questionsDictionary[_question];
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

#pragma mark - Section 1xy

@implementation  NyTuTester101

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation NyTuTester102

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation  NyTuTester103

@end

#pragma mark - Section 2xy

@implementation NyTuTester201

- (void)generateQuestion {
    _question = [NSString stringWithFormat:@"Hello World at %@", [NSDate date]];
}

@end
