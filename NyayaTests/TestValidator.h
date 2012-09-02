//
//  NyayaTestsValidator.h
//  Nyaya
//
//  Created by Alexander Maringele on 02.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestValidator : NSObject

@property (nonatomic, readonly) NSString *input;

+ (id)validatorWithInput:(NSString*)input;
- (BOOL)validate;

@end
