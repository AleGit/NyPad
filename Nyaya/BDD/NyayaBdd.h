//
//  BDDNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NyayaNode.h"

@interface NyayaBdd : NSObject

@property (nonatomic, assign) NyayaBool bddValue;
@property (nonatomic, strong) NyayaBdd *leftBdd;
@property (nonatomic, strong) NyayaBdd *rightBdd;

@end
