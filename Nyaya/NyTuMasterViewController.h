//
//  NyTuMasterViewController.h
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NyMasterViewController.h"

@class NyTuDetailViewController;

@interface NyTuMasterViewController : NyMasterViewController

@property (readonly, nonatomic) NyTuDetailViewController *tutorialViewController;

@end
