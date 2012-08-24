//
//  NyTuMasterViewController.h
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyMasterViewController.h"
#import "NyPgDetailViewController.h"

@interface NyPgMasterViewController : NyMasterViewController

@property (readonly, nonatomic) NyPgDetailViewController *playgroundViewController;

@end
