//
//  NyTuDetailViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyPgDetailViewController.h"

@interface NyPgDetailViewController ()
@end

@implementation NyPgDetailViewController
@synthesize canvasView;

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Playground", @"Playground");
}

- (void)configureView
{
    [super configureView];
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [self.canvasView setNeedsDisplay];
}

- (void)viewDidUnload {
    [self setCanvasView:nil];
    [super viewDidUnload];
}
@end
