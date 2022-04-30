//
//  NyGlDetailViewController.h
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyDetailViewController.h"
#import <Webkit/WebKit.h>

@interface NyGlDetailViewController : NyDetailViewController

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end
