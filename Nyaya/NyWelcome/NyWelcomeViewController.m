//
//  NyWelcomeViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 13.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyWelcomeViewController.h"

@interface NyWelcomeViewController () <WKNavigationDelegate>

@end

@implementation NyWelcomeViewController
@synthesize webView;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    webView.navigationDelegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"html"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

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

@end
