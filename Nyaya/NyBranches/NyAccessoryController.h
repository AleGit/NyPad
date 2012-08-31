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
@property (weak, nonatomic) IBOutlet UIButton *notButton;
@property (weak, nonatomic) IBOutlet UIButton *andButton;
@property (weak, nonatomic) IBOutlet UIButton *orButton;
@property (weak, nonatomic) IBOutlet UIButton *xorButton;
@property (weak, nonatomic) IBOutlet UIButton *bicButton;
@property (weak, nonatomic) IBOutlet UIButton *lparButton;
@property (weak, nonatomic) IBOutlet UIButton *impButton;
@property (weak, nonatomic) IBOutlet UIButton *rparButton;
@property (weak, nonatomic) IBOutlet UIButton *parButton;
@property (weak, nonatomic) IBOutlet UIButton *nparButton;

- (IBAction)press:(UIButton *)sender;
- (IBAction)parenthesize:(UIButton *)sender;
- (IBAction)negate:(UIButton *)sender;

@end
