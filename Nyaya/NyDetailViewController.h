//
//  NyDetailViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NyDetailViewController : UIViewController  <UISplitViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) id detailItem;

- (void)configureView; // override implementation in subclasses

@end
