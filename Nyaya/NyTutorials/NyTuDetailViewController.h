//
//  NyTuDetailViewController.h
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyDetailViewController.h"
#import <WebKit/WebKit.h>

@interface NyTuDetailViewController : NyDetailViewController

@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)back:(id)sender;

@end


