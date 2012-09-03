//
//  NyBoolToolEntry.h
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NyBoolToolEntry : NSObject

+ (id)entryWithTitle:(NSString*)title input:(NSString*)input;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* input;

@end
