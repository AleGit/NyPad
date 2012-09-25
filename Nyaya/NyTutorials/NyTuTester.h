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
// properties
@property(nonatomic,weak) id<NyTuTesterDelegate> delegate;
@property(nonatomic,readonly) UIModalTransitionStyle modalTransitionStyle;
@property(nonatomic,readonly) UIModalPresentationStyle modalPresentationStyle;
// creation
+ (BOOL)testerExistsForKey:(NSString*)key;
+ (id)testerForKey:(NSString*)key;
// template methods
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
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;        // how to read the question
@property (nonatomic, weak) IBOutlet UILabel *solutionLabel;        // how to read the solution
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;          // how to write the answer

@property (nonatomic, weak) IBOutlet UITextView *questionField;     // the content of the question
@property (nonatomic, weak) IBOutlet UITextView *solutionField;     // the content of the solution
@property (nonatomic, weak) IBOutlet UITextView *answerField;       // the answer of the user

@property (nonatomic, readonly) NSString *testerKey;                // key to find configuration and content for the test
@property (nonatomic, readonly) BOOL success;

@end

@interface NyTuTesterPlist : NyTuTester

@property (nonatomic, strong) NSDictionary *testDictionary;
@property (nonatomic, strong) NSDictionary *questionsDictionary;

@property (nonatomic, strong) NSString *questionLabelText;
@property (nonatomic, strong) NSString *answerLabelText;
@property (nonatomic, strong) NSString *solutionLabelText;

@property (nonatomic, readonly) NSString *question;       // question = key, solution = value from dictionary (101,102,103)
@property (nonatomic, readonly) NSString *answer;
@property (nonatomic, readonly) NSString *solution;

@end

@interface NyTuTester101 : NyTuTesterPlist
@end

@interface NyTuTester102 : NyTuTesterPlist
@end

@interface NyTuTester103 : NyTuTesterPlist
@end

@interface NyTuTester201 : NyTuTesterPlist
@end
