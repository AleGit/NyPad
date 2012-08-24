//
//  NyTuMasterViewController.m
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyTuMasterViewController.h"

@interface NyTuMasterViewController ()
@end

@implementation NyTuMasterViewController

- (NyTuDetailViewController*)tutorialViewController {
    return (NyTuDetailViewController*)super.detailViewController;
}

- (BOOL)tableViewIsEditable {
#ifdef DEBUG
#warning code is for testing only
    if (!_objects) _objects = [NSMutableArray array];
    if ([_objects count] == 0) [_objects addObject:@"Hello, World"];
#endif
    return NO;
}

@end
