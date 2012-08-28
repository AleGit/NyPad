//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyTuDetailViewController.h"
#import "NyTuXyzViewController.h"

@interface NyTuDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) NyTuXyzViewController *exerciseViewController;
@property (strong, nonatomic) NSString *tutorialFileName;
@end

@implementation NyTuDetailViewController

- (UIStoryboard*)tustoryboard {
    static UIStoryboard *_tustoryboard;
    if (!_tustoryboard) {
        _tustoryboard = [UIStoryboard storyboardWithName:@"NyTuXyz" bundle:nil];
    }
    return _tustoryboard;
}

- (UIColor*)tubackground {
    static UIColor *_tubackground;
    if (!_tubackground) {
        _tubackground = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paper"]];
    }
    return _tubackground;
}

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Tutorials", @"Tutorials");
}

- (void)configureView
{
    self.backButton.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.detailItem) {
        NSString *sectionTitle = [self.detailItem objectAtIndex:0];
        NSArray *tutorial = [self.detailItem objectAtIndex:1];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@ – %@",sectionTitle, [tutorial objectAtIndex:0]];
        
        NSString *tutorialKey = [tutorial objectAtIndex:1];
        
        NSString *name = [NSString stringWithFormat:@"tutorial%@", tutorialKey];
        NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"html"];
        _tutorialFileName = [url lastPathComponent];
        if (url) {
            self.webView.delegate = self;
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
           
        }
        else {
            NSLog(@"%@.html does not exist",name);
        }
        
        NSString *identifier = [NSString stringWithFormat:@"NyTu%@ViewController", tutorialKey];
        if (![[[self.exerciseViewController class] description] isEqualToString:identifier]) {
            @try {
                self.exerciseViewController = [[self tustoryboard] instantiateViewControllerWithIdentifier:identifier];
                self.exerciseViewController.delegate = self;
                
                self.exerciseViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                self.exerciseViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                self.exerciseViewController.view.backgroundColor = [self tubackground];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            @catch (NSException *ex) {
                self.exerciseViewController = nil;
            }
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
    self.exerciseViewController = nil;
    self.backButton = nil;
    
    [super viewDidUnload];
}

- (IBAction)back:(id)sender {
    [self.webView goBack];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.backButton.hidden = !self.webView.canGoBack || [_tutorialFileName isEqual:[webView.request.URL lastPathComponent]];
}

- (IBAction)exercise:(id)sender {
    if (self.exerciseViewController) {
        [self presentModalViewController:self.exerciseViewController animated:YES];
    }
}

- (void)exerciseDone {
    [self.exerciseViewController dismissModalViewControllerAnimated:YES];
}
@end
