//
//  NyGlDetailViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyGlDetailViewController.h"

@interface NyGlDetailViewController ()
@end

@implementation NyGlDetailViewController

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Glossary", @"Glossary");
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
