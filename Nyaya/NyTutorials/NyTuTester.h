//
//  NyTuTester.h
//  Nyaya
//
//  Created by Alexander Maringele on 30.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyAccessoryController.h"
#import "NyTreeView.h"
#import "NyayaFormula.h"
#import "NyayaBddView.h"


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
@property (nonatomic, weak) IBOutlet UILabel *additionalLabel;      // additional information

@property (nonatomic, weak) IBOutlet UITextView *questionField;     // the content of the question
@property (nonatomic, weak) IBOutlet UITextView *solutionField;     // the content of the solution
@property (nonatomic, weak) IBOutlet UITextView *answerField;       // the answer of the user
@property (weak, nonatomic) IBOutlet UILabel *okLabel;
@property (weak, nonatomic) IBOutlet UILabel *nokLabel;
@property (weak, nonatomic) IBOutlet UILabel *validationLabel;

@property (nonatomic, readonly) NSString *testerKey;                // key to find configuration and content for the test
@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly) NSUInteger succCount;
@property (nonatomic, readonly) NSUInteger failCount;

- (IBAction)toggleButton:(UIButton *)sender;

@end

@interface NyTuTesterPlist : NyTuTester

@property (nonatomic, strong) NSDictionary *testDictionary;

@property (nonatomic, strong) NSString *questionLabelText;
@property (nonatomic, strong) NSString *answerLabelText;
@property (nonatomic, strong) NSString *solutionLabelText;
@property (nonatomic, strong) NSString *additionalLabelText;

@property (nonatomic, readonly) NSString *question;       // question = key, solution = value from dictionary (101,102,103)
@property (nonatomic, readonly) NSString *answer;
@property (nonatomic, readonly) NSString *solution;

@end

@interface NyTuTesterDictionaryQuestions : NyTuTesterPlist
@property (nonatomic, strong) NSDictionary *questionsDictionary;
@end

@interface NyTuTesterRandomQuestions : NyTuTesterPlist

@property (readonly, nonatomic) NSIndexSet *rootTypes;
@property (readonly, nonatomic) NSIndexSet *nodeTypes;
@property (readonly, nonatomic) NSRange lengths;
@property (readonly, nonatomic) NSArray *variables;
@property (readonly, nonatomic) NyayaNode *questionTree;
@end



#pragma mark - Chapter 1 Introduction

@interface NyTuTester11 : NyTuTesterDictionaryQuestions
@end

@interface NyTuTester12 : NyTuTesterDictionaryQuestions
@end

@interface NyTuTester13 : NyTuTesterDictionaryQuestions
@end



#pragma mark - Chapter 2 syntax

@interface NyTuTester21 : NyTuTesterRandomQuestions
@end

@interface NyTuTester22 : NyTuTesterRandomQuestions
@end

@interface NyTuTester23 : NyTuTesterRandomQuestions
@end

@interface NyTuTester24 : NyTuTesterRandomQuestions <NyTreeViewDataSource, NyTreeViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *canvasView;
@property (weak, nonatomic) NyTreeView *syntaxTreeView;

@end

@interface NyTuTester25 : NyTuTesterRandomQuestions
@end



#pragma mark - Chapter 3 semantics

@interface NyTuTester31: NyTuTesterRandomQuestions
@end

@interface NyTuTester32: NyTuTesterRandomQuestions
@property (weak, nonatomic) IBOutlet UITextView *variable1;
@property (weak, nonatomic) IBOutlet UITextView *variable2;
@property (weak, nonatomic) IBOutlet UITextView *variable3;

@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *fields3;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons3;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *fields2;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons2;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *fields1;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons1;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ftButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *solutionButtons;
@end

@interface NyTuTester33: NyTuTesterRandomQuestions
@property (strong, nonatomic) NSArray *questionsArray;
@property (weak, nonatomic) IBOutlet UISwitch *holdsSwitch;

@end

@interface NyTuTester34: NyTuTesterRandomQuestions

@property (weak, nonatomic) IBOutlet UISwitch *validSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *satisSwitch;

@end

#pragma mark - Chapter 4 normal forms

@interface NyTuTester40 : NyTuTesterRandomQuestions

- (NyayaNode*)answerTree;
- (NyayaNode*)solutionTree;

@end

@interface NyTuTester41: NyTuTester40
@end

@interface NyTuTester42: NyTuTester41
@end

@interface NyTuTester43: NyTuTester42
@end

@interface NyTuTester44: NyTuTester42
@end

#pragma mark - Chapter 5 binary decisions

@interface NyTuTester50 : NyTuTesterRandomQuestions
@end

@interface NyTuTester51 : NyTuTester50
@end

@interface NyTuTester52 : NyTuTester50



@end

@interface NyTuTester53 : NyTuTester50
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *binaryButtons;
@property (weak, nonatomic) IBOutlet NyayaBddView *BddView;

@end

// @interface NyTuTester54 : NyTuTester50
// @end
