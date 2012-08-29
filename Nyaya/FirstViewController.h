//
//  FirstViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 16.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UITextView *ast;
@property (weak, nonatomic) IBOutlet UITextView *imf;
@property (weak, nonatomic) IBOutlet UITextView *nnf;
@property (weak, nonatomic) IBOutlet UITextView *cnf;
@property (weak, nonatomic) IBOutlet UITextView *dnf;
@property (weak, nonatomic) IBOutlet UITextView *subformulas;
@property (strong, nonatomic) IBOutlet UITextView *errors;

@property (strong, nonatomic) IBOutlet UIView *accessoryView;

- (IBAction)compute:(id)sender;
- (IBAction)press:(UIButton *)sender;
- (IBAction)delete:(UIButton *)sender; // deprecated
- (IBAction)parenthesize:(UIButton *)sender;
- (IBAction)negate:(UIButton *)sender;

@end
