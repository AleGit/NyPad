//
//  NyBtDetailViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyDetailViewController.h"
#import "NyayaBddView.h"

@protocol InputSaver<NSObject>

- (BOOL) save:(NSString*)name input:(NSString*)input;

@end

@interface NyBtDetailViewController : NyDetailViewController

@property (weak, nonatomic) id<InputSaver>inputSaver;

@property (strong, nonatomic) IBOutlet UITextField *inputName;
@property (strong, nonatomic) IBOutlet UITextField *inputField;

@property (strong, nonatomic) IBOutlet UITextView *parsedField;

@property (strong, nonatomic) IBOutlet UIScrollView *resultView;

@property (strong, nonatomic) IBOutlet UITextView *satisfiabilityLabel;
@property (strong, nonatomic) IBOutlet UITextView *tautologyLabel;
@property (strong, nonatomic) IBOutlet UITextView *contradictionLabel;

@property (strong, nonatomic) IBOutlet UITextView *stdLabel;
@property (strong, nonatomic) IBOutlet UITextView *stdField;
@property (strong, nonatomic) IBOutlet UITextView *nnfLabel;
@property (strong, nonatomic) IBOutlet UITextView *nnfField;
@property (strong, nonatomic) IBOutlet UITextView *cnfLabel;
@property (strong, nonatomic) IBOutlet UITextView *cnfField;
@property (strong, nonatomic) IBOutlet UITextView *dnfLabel;
@property (strong, nonatomic) IBOutlet UITextView *dnfField;
@property (strong, nonatomic) IBOutlet NyayaBddView *bddView;

- (IBAction)send:(id)sender;
- (IBAction)didEndOnExit:(id)sender;
- (IBAction)editingChanged:(id)sender;
- (IBAction)editingDidBegin:(id)sender;

@end
