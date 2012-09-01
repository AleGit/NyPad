//
//  NyTuTester.h
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyAccessoryController.h"


@class NyTuTestViewController;      // external declaration
@protocol NyTuTesterDelegate;       // forward declaration
@protocol NyTuTester;               // forward declaration
@class NyTuTester;                  // forward declaration

@protocol NyTuTester <NSObject>

@property (weak, nonatomic) id<NyTuTesterDelegate> delegate;
+ (BOOL)testerExistsForKey:(NSString*)key;
+ (id)testerForKey:(NSString*)key;

- (void)firstTest:(UIView*)view;
- (void)nextTest;
- (void)checkTest;
- (void)removeTest;

@end

@protocol NyTuTesterDelegate <NSObject>
- (void)tester:(id<NyTuTester>)tester didNextTest:(BOOL)success;
- (void)tester:(id<NyTuTester>)tester didCheckTest:(BOOL)success;
- (void)tester:(id<NyTuTester>)tester didRemoveTest:(BOOL)success;
@end

@interface NyTuTester : NSObject <NyTuTester, NyAccessoryController>

@property (nonatomic, weak) UILabel *keyLabel;
@property (nonatomic, weak) UILabel *valueLabel;
@property (nonatomic, weak) UILabel *inputLabel;

@property (nonatomic, weak) UITextField *keyField;
@property (nonatomic, weak) UITextField *valueField;
@property (nonatomic, weak) UITextField *inputField;

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
