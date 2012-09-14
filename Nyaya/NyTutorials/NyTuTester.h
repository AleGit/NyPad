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

@property(nonatomic,weak) id<NyTuTesterDelegate> delegate;
@property(nonatomic,readonly) UIModalTransitionStyle modalTransitionStyle;
@property(nonatomic,readonly) UIModalPresentationStyle modalPresentationStyle;

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

@property (nonatomic, strong) IBOutlet UIView *testView;
@property (nonatomic, weak) IBOutlet UILabel *keyLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UILabel *inputLabel;

@property (nonatomic, weak) IBOutlet UITextView *keyField;
@property (nonatomic, weak) IBOutlet UITextView *valueField;
@property (nonatomic, weak) IBOutlet UITextView *inputField;

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
