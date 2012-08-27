//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyTuDetailViewController.h"
#import "NyTuXyzViewController.h"

@interface NyTuDetailViewController () 

@property (strong, nonatomic) NyTuXyzViewController *exerciseViewController;
@end

@implementation NyTuDetailViewController

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Tutorials", @"Tutorials");
}

- (void)configureView
{
    if (self.detailItem) {
        NSString *sectionTitle = [self.detailItem objectAtIndex:0];
        NSArray *tutorial = [self.detailItem objectAtIndex:1];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@ – %@",sectionTitle, [tutorial objectAtIndex:0]];
        
        NSString *tutorialKey = [tutorial objectAtIndex:1];
        
        NSString *name = [NSString stringWithFormat:@"tutorial%@", tutorialKey];
        NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"html"];
        if (url) {
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }
        else {
            NSLog(@"%@.html does not exist",name);
        }
        
        name = [NSString stringWithFormat:@"NyTu%@ViewController", tutorialKey];
        if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"] != nil) {
            
            self.exerciseViewController = [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
            self.exerciseViewController.delegate = self;
            self.exerciseViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            self.exerciseViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            self.exerciseButton.hidden = NO;
        }
        else {
            self.exerciseViewController = nil;
            self.exerciseButton.hidden = YES;
            NSLog(@"%@.xib does not exist",name);
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exerciseButton.hidden = YES;
}

- (void)viewDidUnload {
    self.webView = nil;
    self.exerciseButton = nil;
    self.exerciseViewController = nil;
    [super viewDidUnload];
}

- (IBAction)exercise:(id)sender {
    if (self.exerciseViewController) {
        
        
        [self presentModalViewController:self.exerciseViewController animated:YES];
        // self.exerciseViewController.view.bounds = CGRectMake(40,40,708,964);
        
        
    }
}

- (void)exerciseDone {
    [self.exerciseViewController dismissModalViewControllerAnimated:YES];
}
@end
