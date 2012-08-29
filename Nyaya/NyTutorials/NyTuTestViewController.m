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
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.instructionsName withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.instructionsView loadRequest:request];
}

- (void)viewDidUnload
{
    [self setInstructionsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)done:(id)sender {
    NSLog(@"%@", NSStringFromClass([self.presentingViewController class]));
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)check:(id)sender {
    NSLog(@"check");
}

- (IBAction)next:(id)sender {
    NSLog(@"next");
}

@end
