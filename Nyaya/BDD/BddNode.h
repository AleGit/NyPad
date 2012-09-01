//
//  BDDNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyayaNode.h"

@interface BddNode : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSString *variable;
@property (nonatomic, assign) BOOL value;
@property (nonatomic, strong) BddNode *leftBdd;
@property (nonatomic, strong) BddNode *rightBdd;

@end
