//
//  NyTuTester.h
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyAccessoryController.h"

@class NyTuTestViewController;

@protocol NyTuTester <NSObject>

@property (weak, nonatomic) id delegate;
+ (BOOL)testerExistsForKey:(NSString*)key;
+ (id)testerForKey:(NSString*)key;

- (void)firstTest:(UIView*)view;
- (void)checkTest;
- (void)nextTest;
- (void)removeTest;

@end

@interface NyTuTester : NSObject <NyTuTester, NyAccessoryController>

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *inputLabel;

@property (nonatomic, strong) UITextField *keyField;
@property (nonatomic, strong) UITextField *valueField;
@property (nonatomic, strong) UITextField *inputField;

@end

@interface NyTuTesterPlist : NyTuTester

@property (nonatomic, strong) NSDictionary *testDictionary;
@property (nonatomic, strong) NSDictionary *questionsDictionary;
@property (nonatomic, strong) NSString *keyLabelText;
@property (nonatomic, strong) NSString *inputLabelText;
@property (nonatomic, strong) NSString *valueLabelText;

@property (nonatomic, strong) NSString *key;

@end

@interface NyTuTester101 : NyTuTesterPlist
@end

@interface NyTuTester111 : NyTuTesterPlist
@end

@interface NyTuTester121 : NyTuTesterPlist
@end
