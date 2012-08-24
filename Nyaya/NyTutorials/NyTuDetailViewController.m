//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyTuDetailViewController.h"

@interface NyTuDetailViewController ()
@end

@implementation NyTuDetailViewController

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Tutorials", @"Tutorials");
}

- (void)configureView
{
    [super configureView];
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

@end
