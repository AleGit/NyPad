//
//  NyTuXyzViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 25.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NyTuDetailViewController;

@interface NyTuTestViewController : UIViewController

@property (nonatomic, weak) NyTuDetailViewController *delegate;

@property (strong, nonatomic) IBOutlet UIWebView *instructionsView;
@property (copy, nonatomic) NSString *instructionsName;

- (IBAction)done:(id)sender;
- (IBAction)check:(id)sender;
- (IBAction)next:(id)sender;

@end
