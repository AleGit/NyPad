//
//  NyayaNode+Creation.h
//  Nyaya
//
//  Created by Alexander Maringele on 04.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyayaNode.h"

@interface NyayaNode (Creation)

+ (NyayaNode*)atom:(NSString*)name;
+ (NyayaNode*)negation:(NyayaNode*)firstNode;
+ (NyayaNode*)conjunction:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)disjunction:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)xdisjunction:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)implication:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)bicondition:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;

+ (NyayaNode*)sequence:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;
+ (NyayaNode*)entailment:(NyayaNode*)firstNode with:(NyayaNode*)secondNode;

+ (NyayaNode*)function:(NSString*)name with:(NSArray*)nodes;

@end
