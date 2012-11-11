//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyTuDetailViewController.h"
#import "NyTuTestViewController.h"
#import "NyTuTester.h"

@interface NyTuDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) NSString *tutorialHtml;
@property (strong, nonatomic) NSString *tutorialKey;
@property (strong, nonatomic) UIBarButtonItem *exerciseButton;
@end

@implementation NyTuDetailViewController

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Choose Tutorial", @"user can choose tutorial freely");
}

- (NSString*)sectionTitle {
    return [self.detailItem objectAtIndex:0];
}

- (NSArray*)tutorial {
    return [self.detailItem objectAtIndex:1];
}

- (NSString*)tutorialTitle {
    return [self.tutorial objectAtIndex:0];
}

- (NSString*)tutorialKey {
    return [self.tutorial objectAtIndex:1];
}

- (NSString*)tutorialFileName {
    return [NSString stringWithFormat:@"tutorial%@", self.tutorialKey];
}

- (void)configureView
{
    self.backButton.hidden = YES;
    
    if (self.navigationItem.rightBarButtonItem) {
        self.exerciseButton = self.navigationItem.rightBarButtonItem;
    }
    
    if (self.detailItem) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ – %@", self.sectionTitle, self.tutorialTitle];
        
        NSURL *tutorialUrl = [[NSBundle mainBundle] URLForResource:self.tutorialFileName withExtension:@"html"];
        
        if (tutorialUrl) {
            BOOL enabled = [NyTuTester testerExistsForKey:self.tutorialKey];
            if (enabled) {
                self.navigationItem.rightBarButtonItem = self.exerciseButton;
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            else if (!enabled) {
                self.navigationItem.rightBarButtonItem = nil;
            }
            
            
            self.tutorialHtml = [tutorialUrl lastPathComponent];
            self.webView.delegate = self;
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:tutorialUrl]];
           
        }
        else {
            self.tutorialHtml = nil;
            self.webView.delegate = nil;
            NSLog(@"%@.html does not exist", self.tutorialFileName);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.hidden = YES;
    if (self.navigationItem.rightBarButtonItem) {
        self.exerciseButton = self.navigationItem.rightBarButtonItem;
    }
}

- (void)viewDidUnload {
    self.webView = nil;
    self.backButton = nil;
    self.exerciseButton = nil;
    
    [super viewDidUnload];
}

- (IBAction)back:(id)sender {
    [self.webView goBack];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.backButton.hidden = !self.webView.canGoBack || [self.tutorialHtml isEqual:[webView.request.URL lastPathComponent]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NyTuTestViewController *testViewController = (NyTuTestViewController*)segue.destinationViewController;
    
    
    
    
    
    testViewController.instructionsName = [NSString stringWithFormat:@"instructions%@", [[self.detailItem objectAtIndex:1] objectAtIndex:1]];
    testViewController.tester = [NyTuTester testerForKey:self.tutorialKey];
    testViewController.modalPresentationStyle = testViewController.tester.modalPresentationStyle;
    testViewController.modalTransitionStyle = testViewController.tester.modalTransitionStyle;
    testViewController.tester.delegate = testViewController;
}

@end
