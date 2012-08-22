//
//  NyGlMasterViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyGlMasterViewController.h"

@interface NyGlMasterViewController ()
@end

@implementation NyGlMasterViewController

- (NyGlDetailViewController*)glossaryViewController {
    return (NyGlDetailViewController*)super.detailViewController;
}

@end
