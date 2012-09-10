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
}

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
    return [[[self testerClassForKey:key] alloc] init];
}

- (void)loadTestView:(UIView*)view {
    [[NSBundle mainBundle] loadNibNamed:@"StandardTestView" owner:self options:nil];
    [view insertSubview:self.testView atIndex:1];
    self.testView.frame = CGRectMake(0.0, 44.0, view.frame.size.width, view.frame.size.height);
}

- (void)layoutSubviews:(UIView*)view {
    
}

- (void)configureSubviews:(UIView*)view {
    self.keyField.backgroundColor = [UIColor nyLightGreyColor];
    self.valueField.backgroundColor = [UIColor nyLightGreyColor];
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
    self.inputField.inputView = self.accessoryView;
    [self.accessoryView viewWithTag:100].backgroundColor = [UIColor nyKeyboardBackgroundColor];
}

- (void)unloadAccessoryView {
    
    self.inputField.inputView = nil;
    self.inputField.inputAccessoryView = nil;
    self.accessoryView = nil;
    
}

- (IBAction)press:(UIButton *)sender {
    [self.inputField insertText:sender.currentTitle];
}

- (IBAction)process:(UIButton *)sender {
    checked ? [self nextTest] : [self checkTest];
}

- (IBAction)back:(UIButton *)sender {
    [self.inputField deleteBackward];
}

- (IBAction)dismiss:(UIButton*)sender {
    [self.inputField resignFirstResponder];
}

- (IBAction)parenthesize:(UIButton *)sender {
    [self.inputField parenthesize];
}

- (IBAction)negate:(UIButton *)sender {
    [self.inputField negate];
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
    
    self.inputField.editable = YES;
    
    // [self.inputField becomeFirstResponder];
    return success;
}

- (BOOL)validateTestView {
    return YES;
}

- (BOOL)clearTestView {
    
    self.keyField.text = @"";
    self.inputField.text = @"";
    self.valueField.text = @"";
    
    self.inputField.backgroundColor = [UIColor whiteColor];
    
    return YES;
}





@end

@implementation  NyTuTesterPlist

- (id) init {
    self = [super init];
    if (self) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"plist"];
        
        self.testDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        self.questionsDictionary = [self.testDictionary objectForKey:@"questions"];
        
        if (!self.questionsDictionary) {
            filePath = [[NSBundle mainBundle] pathForResource:[self.testDictionary objectForKey:@"questionsFile"] ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
            NSUInteger answerIndex = [[self.testDictionary objectForKey:@"answerIndex"] integerValue];
            NSMutableDictionary *qd = [NSMutableDictionary dictionaryWithCapacity:[array count]];
            for (NSArray* qa in array) {
                if (answerIndex < [qa count]) [qd setObject:[qa objectAtIndex:answerIndex] forKey:[qa objectAtIndex:0]];
            }
            self.questionsDictionary = [qd copy]; // create unmutable copy
        }
        
        self.keyLabelText = [self.testDictionary objectForKey:@"keyLabelText"];
        self.inputLabelText = [self.testDictionary objectForKey:@"inputLabelText"];
        self.valueLabelText = [self.testDictionary objectForKey:@"valueLabelText"];
    }
    return self;
}

- (BOOL)fillTestView {
    BOOL success = [super fillTestView];
    
    self.keyLabel.text = self.keyLabelText;
    self.inputLabel.text = self.inputLabelText;
    self.valueLabel.text = self.valueLabelText;
    
    NSUInteger idx = arc4random() % [self.questionsDictionary count];
    
    self.key = [[self.questionsDictionary allKeys] objectAtIndex:idx];
    self.keyField.text = self.key;
    
    return success ;
}

- (BOOL)validateTestView {
    BOOL success = NO;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ .,;()]*" options:0 error:nil];
    
    NSString *aCorrectAnswer = [self.questionsDictionary valueForKey:self.key];
    NSString *yourAnswer = self.inputField.text;
    
    NSString *aca = [regex stringByReplacingMatchesInString:aCorrectAnswer options:0 range:NSMakeRange(0, [aCorrectAnswer length]) withTemplate:@""];
    NSString *yan = [regex stringByReplacingMatchesInString:yourAnswer options:0 range:NSMakeRange(0, [yourAnswer length]) withTemplate:@""];
    
    success = [aca compare:yan options:NSCaseInsensitiveSearch|NSWidthInsensitiveSearch] == 0;
    
    self.inputField.backgroundColor = success ? [UIColor nyRightColor] : [UIColor nyWrongColor];
    self.valueField.text = aCorrectAnswer;
    
    return success;
}

@end

@implementation  NyTuTester101

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation NyTuTester111

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation  NyTuTester121

@end
