//
//  NyBtDetailViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyDetailViewController.h"
#import "NyayaBddView.h"

@interface NyBtDetailViewController : NyDetailInputViewController

@property (strong, nonatomic) IBOutlet UITextView *parsedField;

@property (strong, nonatomic) IBOutlet UIScrollView *resultView;

@property (strong, nonatomic) IBOutlet UITextView *satisfiabilityLabel;
@property (strong, nonatomic) IBOutlet UITextView *tautologyLabel;
@property (strong, nonatomic) IBOutlet UITextView *contradictionLabel;

@property (strong, nonatomic) IBOutlet UITextView *nnfLabel;
@property (strong, nonatomic) IBOutlet UITextView *nnfField;
@property (strong, nonatomic) IBOutlet UITextView *cnfLabel;
@property (strong, nonatomic) IBOutlet UITextView *cnfField;
@property (strong, nonatomic) IBOutlet UITextView *dnfLabel;
@property (strong, nonatomic) IBOutlet UITextView *dnfField;
@property (strong, nonatomic) IBOutlet NyayaBddView *bddView;
@property (strong, nonatomic) IBOutlet UIWebView *truthTableView;

- (IBAction)send:(id)sender;
- (IBAction)didEndOnExit:(id)sender;
- (IBAction)editingChanged:(id)sender;
- (IBAction)editingDidBegin:(id)sender;

@end
