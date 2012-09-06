//
//  BDDNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TruthTable.h"

@interface BddNode : NSObject
@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) BddNode *leftBranch;
@property (nonatomic, readonly) BddNode *rightBranch;

+(BddNode*)diagramWithTruthTable:(TruthTable*)truthTable;
+ (id)top;
+ (id)bottom;
-(BOOL)isLeaf;
-(NSString*)cnfDescription;
-(NSString*)dnfDescription;
-(NSUInteger)levelCount;
-(NSUInteger)nodeCount;


@end
