//
//  NyDetailViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NyAccessoryController.h"

@interface NyDetailViewController : UIViewController  <UISplitViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) id detailItem;

- (void)configureView; // override implementation in subclasses

@end

@interface NyDetailInputViewController : NyDetailViewController <NyAccessoryController,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *inputField;

@end


