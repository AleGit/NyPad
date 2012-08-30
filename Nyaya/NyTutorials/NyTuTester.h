//
//  NyTuTester.h
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NyTuTestViewController;

@interface NyTuTester : NSObject

@property (weak, nonatomic) NyTuTestViewController *delegate;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *inputLabel;

@property (nonatomic, strong) UITextField *keyField;
@property (nonatomic, strong) UITextField *valueField;
@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UIColor *greyColor;
@property (nonatomic, strong) UIColor *wrongColor;
@property (nonatomic, strong) UIColor *rightColor;

+ (BOOL)testerExistsForKey:(NSString*)key;
+ (id)testerForKey:(NSString*)key;

- (void)firstTest:(UIView*)view;
- (void)checkTest;
- (void)nextTest;
- (void)removeTest;

- (IBAction)press:(UIButton *)sender;
- (IBAction)parenthesize:(UIButton *)sender;
- (IBAction)negate:(UIButton *)sender;

@end

@interface NyTuTesterPlist : NyTuTester
@property (nonatomic, strong) NSDictionary *testDictionary;
@property (nonatomic, strong) NSDictionary *questionsDictionary;
@property (nonatomic, strong) NSString *keyLabelKey;
@property (nonatomic, strong) NSString *inputLabelKey;
@property (nonatomic, strong) NSString *valueLabelKey;

@property (nonatomic, strong) NSString *key;

@end

@interface NyTuTester101 : NyTuTesterPlist
@end

@interface NyTuTester111 : NyTuTesterPlist
@end
