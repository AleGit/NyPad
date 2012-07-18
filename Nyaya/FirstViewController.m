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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setInput:nil];
    [self setAst:nil];
    [self setImf:nil];
    [self setNnf:nil];
    [self setCnf:nil];
    [self setDnf:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)compute:(id)sender {
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
    

    
    
}
@end
