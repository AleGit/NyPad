//
//  NyGlDetailViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyGlDetailViewController.h"
#import "NyGlossaryEntry.h"

@interface NyGlDetailViewController () {
    NSURL *_baseurl;
}

@end

@implementation NyGlDetailViewController

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Glossary", @"Glossary");
}

- (void)configureView
{
    [super configureView];
    
    NyGlossaryEntry *entry = (NyGlossaryEntry*)self.detailItem;
    
    NSURL *newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"#%@",entry.entryId] relativeToURL:_baseurl];
    NSURLRequest *request = [NSURLRequest requestWithURL: newUrl];
    [self.webView loadRequest:request];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.webView.delegate = self;
    _baseurl = [[NSBundle mainBundle] URLForResource:@"glossary" withExtension:@"html"];
    if (_baseurl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:_baseurl];
        [self.webView loadRequest:request];
    }
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
