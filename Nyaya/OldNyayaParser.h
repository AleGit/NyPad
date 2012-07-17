//
//  NyayaParser.h
//  Nyaya
//
//  Created by Alexander Maringele on 16.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldNyayaParser : NSObject

@property (readonly) NSString* input;
@property (readonly) NSArray* tokens;
@property (readonly) NSArray* sequence;

- (void)parse:(NSString*)input;

@end
