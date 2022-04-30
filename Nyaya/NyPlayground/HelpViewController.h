//
//  HelpViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 12.02.13.
//  Copyright (c) 2013 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HelpViewController : UIViewController

@property (weak, nonatomic) IBOutlet WKWebView *helpView;

- (IBAction)closeHelp:(UIBarButtonItem *)sender;

@end
