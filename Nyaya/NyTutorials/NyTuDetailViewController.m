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
        
        NSString *identifier = [NSString stringWithFormat:@"NyTu%@ViewController", tutorialKey];
        if (![[[self.exerciseViewController class] description] isEqualToString:identifier]) {
            @try {
                self.exerciseViewController = [[self tustoryboard] instantiateViewControllerWithIdentifier:identifier];
                self.exerciseViewController.delegate = self;
                self.exerciseViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                self.exerciseViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                self.exerciseViewController.view.backgroundColor = [self tubackground];
                self.exerciseButton.hidden = NO;
            }
            @catch (NSException *ex) {
                NSLog(@"%@ does not exist in storyboard.", identifier);
                self.exerciseViewController = nil;
                self.exerciseButton.hidden = YES;
            }
        }
        else {
            NSLog(@"%@ allready created", identifier);
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
