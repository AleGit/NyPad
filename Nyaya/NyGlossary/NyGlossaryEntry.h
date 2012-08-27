//
//  NyGlossaryEntry.h
//  Nyaya
//
//  Created by Alexander Maringele on 27.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NyGlossaryEntry : NSObject

@property (nonatomic, copy) NSString *entryTitle;
@property (nonatomic, copy) NSString *entryId;

- (id)initWithString:(NSString*)string;
+ (id)entryWithString:(NSString*)string;

@end
