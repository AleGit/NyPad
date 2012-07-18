//
//  FirstViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "FirstViewController.h"
#import "NyayaParser.h"
#import "NyayaNode.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize input;
@synthesize ast;
@synthesize imf;
@synthesize nnf;
@synthesize cnf;
@synthesize dnf;
@synthesize subformulas;
@synthesize myInputView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // self.input.inputView = [[UIButton alloc] init];
    /*self.input.inputAccessoryView = [[UIButton alloc] init];
    
    CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 77.0);
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
    inputAccessoryView.backgroundColor = [UIColor blueColor];
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    compButton.frame = CGRectMake(313.0, 20.0, 158.0, 37.0);
    [compButton setTitle: @"Word Completions" forState:UIControlStateNormal];
    [compButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [compButton addTarget:self action:@selector(completeCurrentWord:)
         forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:compButton];*/
    self.input.inputView = self.myInputView;
    // self.input.inputAccessoryView = self.myInputView;
    [self.input becomeFirstResponder];
    
    // self.input.inputView = self.myInputView;
}


- (void)viewDidUnload
{
    [self setInput:nil];
    [self setAst:nil];
    [self setImf:nil];
    [self setNnf:nil];
    [self setCnf:nil];
    [self setDnf:nil];
    [self setSubformulas:nil];
    [self setMyInputView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)compute:(id)sender {
    if (![self.input hasText]) {
        // show alert
    }
    else {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:self.input.text];
        NyayaNode *a = [parser parseFormula];
        self.ast.text = [a description];
        
        NyayaNode *i = [a imf];
        self.imf.text = [i description];
        
        
        NyayaNode *n = [i nnf];
        self.nnf.text = [n description];
        
        
        NyayaNode *c = [n cnf];
        self.cnf.text = [c description];
        
        
        NyayaNode *d = [n dnf];
        self.dnf.text = [d description];
        
        self.subformulas.text = [[a sortedSubformulas] componentsJoinedByString:@"; "];
        
        
        [self.input resignFirstResponder];
    }
    
}

- (IBAction)press:(UIButton *)sender {
    [self.input insertText:sender.currentTitle];
    
}

- (IBAction)delete:(UIButton *)sender {
    [self.input deleteBackward];
}

@end
