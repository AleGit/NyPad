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
@end

@implementation NyTuDetailViewController

- (UIStoryboard*)testStoryboard {
    static UIStoryboard *_tustoryboard;
    if (!_tustoryboard) {
        _tustoryboard = [UIStoryboard storyboardWithName:@"NyTuTest" bundle:nil];
    }
    return _tustoryboard;
}

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Choose Tutorial", @"user can choose tutorial freely");
}

- (void)configureView
{
    self.backButton.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.detailItem) {
        NSString *sectionTitle = [self.detailItem objectAtIndex:0];
        
        NSArray *tutorial = [self.detailItem objectAtIndex:1];
        NSString *tutorialTitle = [tutorial objectAtIndex:0];
        self.tutorialKey = [tutorial objectAtIndex:1];
        NSString *tutorialFileName = [NSString stringWithFormat:@"tutorial%@", self.tutorialKey];
        NSURL *tutorialUrl = [[NSBundle mainBundle] URLForResource:tutorialFileName withExtension:@"html"];

        self.navigationItem.title = [NSString stringWithFormat:@"%@ – %@",sectionTitle, tutorialTitle];
        
        if (tutorialUrl) {
            self.navigationItem.rightBarButtonItem.enabled=[NyTuTester testerExistsForKey:self.tutorialKey];
            self.tutorialHtml = [tutorialUrl lastPathComponent];
            self.webView.delegate = self;
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:tutorialUrl]];
           
        }
        else {
            self.tutorialHtml = nil;
            self.webView.delegate = nil;
            NSLog(@"%@.html does not exist",tutorialFileName);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidUnload {
    self.webView = nil;
    self.backButton = nil;
    
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
    testViewController.tester.delegate = testViewController;
    // testViewController.delegate = self;  
    
    NSLog(@"“%@” ‘%@’ ‘%@’ \n%@", segue.identifier, [segue.sourceViewController class], [segue.destinationViewController class]
          , testViewController.instructionsName);
}

@end
