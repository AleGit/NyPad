//
//  NyTuDetailViewController.h
//  NyTutorial
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 Alexander Maringele. All rights reserved.
//

#import "NyDetailViewController.h"

@interface NyTuDetailViewController : NyDetailViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *exerciseButton;

- (IBAction)exercise:(id)sender;

@end
