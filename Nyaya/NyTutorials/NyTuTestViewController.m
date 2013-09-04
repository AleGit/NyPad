//
//  NyTuXyzViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 25.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyTuTestViewController.h"
#import "NyTuDetailViewController.h"

@interface NyTuTestViewController ()
@end

@implementation NyTuTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.instructionsName withExtension:@"html"];
    
    if (url) {
        self.instructionsView.hidden = NO;
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        [self.instructionsView loadRequest:request];
    }
    else {
        self.instructionsView.hidden = YES;
    }*/
    
    
    self.nextButton.enabled = NO;
    [self.tester firstTest:self.view];
}

- (void)viewDidUnload
{
    [self setInstructionsView:nil];
    [self setCheckButton:nil];
    [self setNextButton:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)done:(id)sender {
    [self.tester removeTest];
}

- (IBAction)check:(id)sender {
    [self.tester checkTest];
}

- (IBAction)next:(id)sender {
    [self.tester nextTest];
}

- (void)tester:(id<NyTuTester>)tester didCheckTest:(BOOL)success {
    self.nextButton.enabled = YES;
}

- (void)tester:(id<NyTuTester>)tester didNextTest:(BOOL)success {
    self.nextButton.enabled = NO;
}

- (void)tester:(id<NyTuTester>)tester didRemoveTest:(BOOL)success {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
