//
//  NyTuMasterViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyTuMasterViewController.h"

#import "NyTuDetailViewController.h"

@interface NyTuMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation NyTuMasterViewController

- (NyTuDetailViewController*)tutorialViewController {
    return (NyTuDetailViewController*)super.detailViewController;
}

@end
