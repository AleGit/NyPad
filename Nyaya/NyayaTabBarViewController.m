//
//  MyTabBarViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 07.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaTabBarViewController.h"

@interface NyayaTabBarViewController ()

@end

@implementation NyayaTabBarViewController

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
    
    // configure split view controllers (master detail):
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UISplitViewController class]]) {
            UISplitViewController *splitViewController = obj;
            UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
            splitViewController.delegate = (id)navigationController.topViewController;
        }
    }];
  

    NSString *currentSytemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *requiredSystemVersion = @"6.0";
    NSComparisonResult result = [currentSytemVersion compare: requiredSystemVersion options:NSNumericSearch];
    NSLog(@"%@ %@ %i", currentSytemVersion, requiredSystemVersion, result);
    
    if (result == NSOrderedAscending) { // current < required
        // Workaround: On iOS < 6.0.1 the playground crashes if it is not shown first
        self.selectedViewController = [self.viewControllers objectAtIndex:2]; // 2 = playground
    }
    else {
        self.selectedViewController = [self.viewControllers objectAtIndex:4]; // 1=tutorial, 2=playground, 3=gloassary, 4=booltool
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
