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

@interface NyTuDetailViewController () <WKNavigationDelegate>

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
            self.webView.navigationDelegate = self;
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:tutorialUrl]];
           
        }
        else {
            self.tutorialHtml = nil;
            self.webView.navigationDelegate = nil;
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

- (IBAction)back:(id)sender {
    [self.webView goBack];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    if (url.isFileURL) {
        NSLog(@"Open file url: %@", url);
        decisionHandler(WKNavigationActionPolicyAllow);
        
    } else if (url) {
        NSLog(@"Open web url: %@", url);
        decisionHandler(WKNavigationActionPolicyCancel);
        [[UIApplication sharedApplication] openURL:url options: @{} completionHandler:nil];
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NyTuTestViewController *testViewController = (NyTuTestViewController*)segue.destinationViewController;
    testViewController.tester = [NyTuTester testerForKey:self.tutorialKey];
    testViewController.modalPresentationStyle = testViewController.tester.modalPresentationStyle;
    testViewController.modalTransitionStyle = testViewController.tester.modalTransitionStyle;
    testViewController.tester.delegate = testViewController;
}

@end
