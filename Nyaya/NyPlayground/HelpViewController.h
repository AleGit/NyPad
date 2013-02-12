//
//  HelpViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 12.02.13.
//  Copyright (c) 2013 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *helpView;

- (IBAction)closeHelp:(UIBarButtonItem *)sender;

@end
