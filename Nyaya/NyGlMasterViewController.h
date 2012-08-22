//
//  NyGlMasterViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyMasterViewController.h"
#import "NyGlDetailViewController.h"

@interface NyGlMasterViewController : NyMasterViewController

@property (readonly, nonatomic) NyGlDetailViewController *glossaryViewController;

@end
