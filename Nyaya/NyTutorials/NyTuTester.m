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
    BOOL checked;
@protected
    NSString* _testerKey;
}

- (id)initWithKey:(NSString*)key;

- (void)loadTestView:(UIView*)view;
- (void)layoutSubviews:(UIView*)view;
- (void)configureSubviews:(UIView*)view;
- (void)configureKeyboard;

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
#if DEBUG
    static UIModalPresentationStyle style = 0;
    style = (++style)%4;
    return style;
#endif
    return UIModalPresentationFormSheet;
}

// default
- (UIModalTransitionStyle)modalTransitionStyle {
    return UIModalTransitionStyleCoverVertical;
}

- (void)loadTestView:(UIView*)view {
    [[NSBundle mainBundle] loadNibNamed:@"StandardTestView" owner:self options:nil];
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
    checked ? [self nextTest] : [self checkTest];
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

- (void)firstTest:(UIView *)view {
     NSLog(@"%@ firstTest", [self class] );
    
    [self loadTestView:view];
    [self layoutSubviews:view];
    [self configureSubviews:view];
    
    [self loadAccessoryView];
    [self configureAccessoryView];
    
    [self configureKeyboard];
    
    [self nextTest];
}

- (void)nextTest {
    checked = NO;
    [processButton setTitle:NSLocalizedString(@"check", nil) forState:UIControlStateNormal];
    NSLog(@"%@ nextTest", [self class] );
    BOOL success = [self clearTestView] && [self fillTestView];
    [delegate tester:self didNextTest:success];
}

-  (void)checkTest {
    checked = YES;
    [processButton setTitle:NSLocalizedString(@"next", nil) forState:UIControlStateNormal];
    NSLog(@"%@ checkTest", [self class] );
    BOOL success = [self validateTestView];
    [self.delegate tester:self didCheckTest:success];
}

- (void)removeTest {
    NSLog(@"%@ removeTest", [self class] );
    [self.testView removeFromSuperview];
    [self setTestView:nil];
    [self.delegate tester:self didRemoveTest:YES];
}

#pragma mark -

- (BOOL)fillTestView {
    BOOL success = YES;
    
    self.answerField.editable = YES;
    
    // [self.inputField becomeFirstResponder];
    return success;
}

- (BOOL)validateTestView {
    return YES;
}

- (BOOL)clearTestView {
    
    self.questionField.text = @"";
    self.answerField.text = @"";
    self.solutionField.text = @"";
    
    self.answerField.backgroundColor = [UIColor whiteColor];
    
    return YES;
}





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

- (BOOL)fillTestView {
    BOOL success = [super fillTestView];
    
    self.questionLabel.text = self.questionLabelText;
    self.answerLabel.text = self.answerLabelText;
    self.solutionLabel.text = self.solutionLabelText;
    
    NSUInteger idx = arc4random() % [self.questionsDictionary count];
    
    self.question = [[self.questionsDictionary allKeys] objectAtIndex:idx];
    self.questionField.text = self.question;
    
    return success ;
}

- (BOOL)validateTestView {
    BOOL success = NO;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ .,;()]*" options:0 error:nil];
    
    NSString *aCorrectAnswer = [self.questionsDictionary valueForKey:self.question];
    NSString *yourAnswer = self.answerField.text;
    
    NSString *aca = [regex stringByReplacingMatchesInString:aCorrectAnswer options:0 range:NSMakeRange(0, [aCorrectAnswer length]) withTemplate:@""];
    NSString *yan = [regex stringByReplacingMatchesInString:yourAnswer options:0 range:NSMakeRange(0, [yourAnswer length]) withTemplate:@""];
    
    success = [aca compare:yan options:NSCaseInsensitiveSearch|NSWidthInsensitiveSearch] == 0;
    
    self.answerField.backgroundColor = success ? [UIColor nyRightColor] : [UIColor nyWrongColor];
    self.solutionField.text = aCorrectAnswer;
    
    return success;
}

@end

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
