//
//  NyTuXyzViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 25.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NyTuTester.h"

@class NyTuDetailViewController;


@interface NyTuTestViewController : UIViewController <NyTuTesterDelegate>


@property (strong, nonatomic) IBOutlet WKWebView *instructionsView;
@property (copy, nonatomic) NSString *instructionsName;
@property (strong, nonatomic) id<NyTuTester> tester;

- (IBAction)done:(id)sender;
- (IBAction)check:(id)sender;
- (IBAction)next:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *checkButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end
