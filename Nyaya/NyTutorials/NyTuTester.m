//
//  NyTuTester.m
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyTuTester.h"

@implementation NyTuTester

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

- (void)firstTest:(UIView *)view {
     NSLog(@"%@ firstTest", [self class] );
    
    self.keyLabel = (UILabel*)[view viewWithTag:1];
    self.keyField = (UITextField*)[view viewWithTag:2];
    self.inputLabel = (UILabel*)[view viewWithTag:3];
    self.inputField = (UITextField*)[view viewWithTag:4];
    self.valueLabel = (UILabel*)[view viewWithTag:5];
    self.valueField = (UITextField*)[view viewWithTag:6];
    
    self.greyColor = self.keyField.backgroundColor;
    self.wrongColor = self.valueField.backgroundColor;
    self.rightColor = self.inputField.backgroundColor;
    
    [[NSBundle mainBundle] loadNibNamed:@"NyAccessoryView" owner:self options:nil];
    self.inputField.inputAccessoryView = self.accessoryView;
    [self.inputField addTarget:self.delegate action:@selector(check:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.keyField.backgroundColor = self.greyColor;
    self.valueField.backgroundColor = self.greyColor;
    
    [self nextTest];
}

-  (void)checkTest {
    NSLog(@"%@ checkTest", [self class] );
}

- (void)nextTest {
    NSLog(@"%@ nextTest", [self class] );
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
        
        self.keyLabelKey = [self.testDictionary objectForKey:@"keyLabel"];
        self.inputLabelKey = [self.testDictionary objectForKey:@"inputLabel"];
        self.valueLabelKey = [self.testDictionary objectForKey:@"valueLabel"];
        
        
    }
    return self;
}

- (void)firstTest:(UIView *)view {
    [super firstTest:view];
    
    self.keyLabel.text = NSLocalizedString(self.keyLabelKey, nil);
    self.inputLabel.text = NSLocalizedString(self.inputLabelKey, nil);
    self.valueLabel.text = NSLocalizedString(self.valueLabelKey, nil);
 
}

- (void)nextTest {
    [super nextTest];
    
    // reset all fields
    self.inputField.backgroundColor = nil; // default
   
    self.inputField.text = @"";
    self.valueField.text = @"";
    
    NSUInteger idx = arc4random() % [self.questionsDictionary count];
    self.inputField.enabled = YES;
    
    self.key = [[self.questionsDictionary allKeys] objectAtIndex:idx];
    
    self.keyField.text = self.key;
    self.valueField.text = @"";
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
- (void)firstTest:(UIView *)view {
    [super firstTest:view];
    view.superview.frame = CGRectMake(10,10,100,100);
    self.inputField.inputAccessoryView = nil;
}
@end

@implementation  NyTuTester111
@end

@implementation  NyTuTester121
@end
