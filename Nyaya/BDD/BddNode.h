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
@property (nonatomic, strong) NSArray *levels;

+(BddNode*)bddWithTruthTable:(TruthTable*)truthTable reduce:(BOOL)optimize;
+ (id)top;
+ (id)bottom;
-(BOOL)isLeaf;

-(NSString*)cnfDescription;
-(NSString*)dnfDescription;

// usually [node pathsTo:@"0"] and [node pathsTo:@"1"],
// but [node pathsTo:@"x"] is possible too
- (NSMutableSet*)pathsTo:(NSString*)name;
- (NSMutableSet*)disjunctiveSet;
- (NSMutableSet*)conjunctiveSet;
- (NSString*)disjunctiveDescription;
- (NSString*)conjunctiveDescription;

@end
