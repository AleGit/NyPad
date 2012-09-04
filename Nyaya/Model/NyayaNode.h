//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NyayaNode : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *symbol;       // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, weak) NyayaNode *parent;

@end


