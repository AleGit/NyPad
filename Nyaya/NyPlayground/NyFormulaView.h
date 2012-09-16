//
//  NyFormulaView.h
//  Nyaya
//
//  Created by Alexander Maringele on 16.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NyFormulaView : UIView

@property (assign, nonatomic, getter = isSelected) BOOL selected;
@property (assign, nonatomic, getter = isLocked) BOOL locked;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *formulaTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *formulaPanGestureRecognizer;

@end
