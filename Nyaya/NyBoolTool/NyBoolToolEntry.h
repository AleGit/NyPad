//
//  NyBoolToolEntry.h
//  Nyaya
//
//  Created by Alexander Maringele on 03.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NyBoolToolEntry : NSObject

+ (id)entryWithDate:(NSDate*)date input:(NSString*)input;

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString* input;

@end
