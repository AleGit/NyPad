//
//  NyTuXyzViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 25.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NyTuDetailViewController;

@interface NyTuXyzViewController : UIViewController

@property (nonatomic, weak) NyTuDetailViewController *delegate;

- (IBAction)done:(id)sender;

@end
