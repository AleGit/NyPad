//
//  NyTuTester.m
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyTuTester.h"

@interface NyTuTester ()

- (void)connectSubviews:(UIView*)view;
- (void)layoutSubviews:(UIView*)view;
- (void)configureSubviews:(UIView*)view;

- (BOOL)accessoryViewShouldBeVisible;
- (void)loadAccessoryView;
- (void)configureAccessoryView;

- (void)configureKeyboard;

@end

@implementation NyTuTester

// NyTuTester protocol properties
@synthesize delegate;
// NyAccessoryDelegate protocol properties
@synthesize accessoryView;
@synthesize notButton;
@synthesize andButton;
@synthesize orButton;
@synthesize xorButton;
@synthesize bicButton;
@synthesize lparButton;
@synthesize impButton;
@synthesize rparButton;
@synthesize parButton;
@synthesize nparButton;

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

- (void)connectSubviews:(UIView*)view {
    self.keyLabel = (UILabel*)[view viewWithTag:1];
    self.keyField = (UITextField*)[view viewWithTag:2];
    self.inputLabel = (UILabel*)[view viewWithTag:3];
    self.inputField = (UITextField*)[view viewWithTag:4];
    self.valueLabel = (UILabel*)[view viewWithTag:5];
    self.valueField = (UITextField*)[view viewWithTag:6];
    
    self.greyColor = self.keyField.backgroundColor;
    self.rightColor = self.inputField.backgroundColor;
    self.wrongColor = self.valueField.backgroundColor;
}

- (void)layoutSubviews:(UIView*)view {
    
}

- (void)configureSubviews:(UIView*)view {
    self.keyField.backgroundColor = self.greyColor;
    self.valueField.backgroundColor = self.greyColor;
}



- (BOOL)accessoryViewShouldBeVisible {
    return YES;
}

- (void)loadAccessoryView {
    if ([self accessoryViewShouldBeVisible]) {
        [[NSBundle mainBundle] loadNibNamed:@"NyAccessoryView" owner:self options:nil];
        self.inputField.inputAccessoryView = self.accessoryView;
    }
    else {
        self.inputField.inputAccessoryView = nil;
        self.accessoryView = nil;
    }
}

- (void)disableControls: (NSArray*)controls {
    for (UIControl *control in controls) {
        control.enabled = NO;
    }
}

- (void)enableControls: (NSArray*)controls {
    for (UIControl *control in controls) {
        control.enabled = YES;
    }
}

- (void)hideViews: (NSArray*)views {
    for (UIView *view in views) {
        view.hidden = YES;
    }
}

- (void)showViews: (NSArray*)views {
    for (UIView *view in views) {
        view.hidden = NO;
    }
}

- (void)configureAccessoryView {
    
}

- (void)configureKeyboard {
    [self.inputField addTarget:self.delegate action:@selector(check:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)firstTest:(UIView *)view {
     NSLog(@"%@ firstTest", [self class] );
    
    [self connectSubviews:view];
    [self layoutSubviews:view];
    [self configureSubviews:view];
    
    [self loadAccessoryView];
    [self configureAccessoryView];
    
    [self configureKeyboard];
    
    [self nextTest];
}

-  (void)checkTest {
    NSLog(@"%@ checkTest", [self class] );
}

- (void)nextTest {
    NSLog(@"%@ nextTest", [self class] );
    self.keyField.backgroundColor = self.greyColor;
    self.inputField.backgroundColor = nil;
    self.valueField.backgroundColor = self.greyColor;
    
    self.inputField.text = @"";
    self.valueField.text = @"";
    
    self.inputField.enabled = YES;
}

- (void)removeTest {
    NSLog(@"%@ removeTest", [self class] );
    self.keyLabel.text = @"";
    self.keyField.text = @"";
    self.inputLabel.text = @"";
    self.inputField.text = @"";
    self.valueLabel.text = @"";
    self.valueField.text = @"";
    
    self.keyLabel = nil;
    self.keyField = nil;
    self.inputLabel = nil;
    self.inputField = nil;
    self.valueLabel = nil;
    self.valueField = nil;
}

#pragma mark NyAccessoryViewDelegate

- (IBAction)press:(UIButton *)sender {
    [self.inputField insertText:sender.currentTitle];
}

- (IBAction)parenthesize:(UIButton *)sender {
    if ([self.inputField hasText]) {
        self.inputField.text = [NSString stringWithFormat:@"(%@)", self.inputField.text];
    }
}

- (IBAction)negate:(UIButton *)sender {
    if ([self.inputField hasText]) {
        self.inputField.text = [NSString stringWithFormat:@"¬(%@)", self.inputField.text];
    }
}

@end

@implementation  NyTuTesterPlist

- (id) init {
    self = [super init];
    if (self) {

        NSString *filePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"plist"];
        
        self.testDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        self.questionsDictionary = [self.testDictionary objectForKey:@"questions"];
        
        self.keyLabelText = [self.testDictionary objectForKey:@"keyLabelText"];
        self.inputLabelText = [self.testDictionary objectForKey:@"inputLabelText"];
        self.valueLabelText = [self.testDictionary objectForKey:@"valueLabelText"];
    }
    return self;
}

- (void)configureSubviews:(UIView *)view {
    [super configureSubviews:view];
    
    self.keyLabel.text = self.keyLabelText;
    self.inputLabel.text = self.inputLabelText;
    self.valueLabel.text = self.valueLabelText;
}

- (void)nextTest {
    [super nextTest];
    
    NSUInteger idx = arc4random() % [self.questionsDictionary count];
    
    self.key = [[self.questionsDictionary allKeys] objectAtIndex:idx];
    self.keyField.text = self.key;
}

- (void)checkTest {
    [super checkTest];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ .,;]*" options:0 error:nil];
    
    NSString *aCorrectAnswer = [self.questionsDictionary valueForKey:self.key];
    NSString *yourAnswer = self.inputField.text;
    
    NSString *aca = [regex stringByReplacingMatchesInString:aCorrectAnswer options:0 range:NSMakeRange(0, [aCorrectAnswer length]) withTemplate:@""];
    NSString *yan = [regex stringByReplacingMatchesInString:yourAnswer options:0 range:NSMakeRange(0, [yourAnswer length]) withTemplate:@""];
    
    if ([aca compare:yan options:NSCaseInsensitiveSearch|NSWidthInsensitiveSearch] == 0) self.inputField.backgroundColor = self.rightColor;
    
    self.valueField.text = aCorrectAnswer;
    
}

@end

@implementation  NyTuTester101

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation  NyTuTester111

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

@end

@implementation  NyTuTester121

- (void)configureAccessoryView {
    [self disableControls:@[self.xorButton, self.bicButton, self.lparButton, self.rparButton, self.parButton, self.nparButton]];
}

@end
