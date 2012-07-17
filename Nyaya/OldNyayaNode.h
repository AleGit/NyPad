//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 16.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldNyayaNode : NSObject

@property (readonly) NSString *token;
@property (readonly) NSMutableArray *nodes;

- (id)initWithToken:(NSString*)token;

@end
