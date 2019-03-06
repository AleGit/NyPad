//
//  HelpViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 12.02.13.
//  Copyright (c) 2013 private. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)configureView
{
    NSURL *playgroundUrl = [[NSBundle mainBundle] URLForResource:@"playground" withExtension:@"html"];
    if (playgroundUrl) {
        [self.helpView loadRequest:[NSURLRequest requestWithURL:playgroundUrl]];
    }
    else {
        NSLog(@"%@.html does not exist", @"playground");
    }
}

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
    [self configureView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHelpView:nil];
    [super viewDidUnload];
}

- (IBAction)closeHelp:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
