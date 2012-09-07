//
//  NyAccessoryDelegate.h
//  Nyaya
//
//  Created by Alexander Maringele on 31.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NyAccessoryController <NSObject>

@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (readonly, readonly) BOOL accessoryViewShouldBeVisible;

- (void)loadAccessoryView;
- (void)configureAccessoryView;
- (void)unloadAccessoryView;


- (IBAction)press:(UIButton*)sender;
- (IBAction)back:(UIButton*)sender;
- (IBAction)process:(UIButton*)sender;
- (IBAction)dismiss:(UIButton*)sender;
- (IBAction)parenthesize:(UIButton*)sender;
- (IBAction)negate:(UIButton*)sender;

@end
