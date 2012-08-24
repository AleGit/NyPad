//
//  NyTuMasterViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyPgMasterViewController.h"

@interface NyPgMasterViewController ()
@end

@implementation NyPgMasterViewController

- (NyPgDetailViewController*)playgroundViewController {
    return (NyPgDetailViewController*)super.detailViewController;
}

@end
