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

- (IBAction)compute:(id)sender;

@end
