//
//  BDDNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 06.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TruthTable;
@class NyayaNode;

@interface BddNode : NSObject <NSCopying>

// used be reduce algorithm
@property (nonatomic, readonly) NSInteger id;

// the name ot the atom: x, y, 0, 1, a, b, etc.
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger layer;

// follow this path if the atom 'name' evaluates to 0
@property (nonatomic, readonly) BddNode *leftBranch;
// follow this path if the atom 'name' evaluates to 1
@property (nonatomic, readonly) BddNode *rightBranch;

// Marks if the reduce algorithm was used
@property (nonatomic, readonly) BOOL reduced;


@property (nonatomic,readonly) NSArray *names;  // root.names != nil, !root.names == nil

// Constructs an Ordered BDD with variable order of 'truth table'
+(BddNode*)bddWithTruthTable:(TruthTable*)truthTable reduce:(BOOL)reduce;
+(BddNode*)obddWithNode:(NyayaNode*)node order:(NSArray*)variables reduce:(BOOL)reduce;


+ (id)top;
+ (id)bottom;
-(BOOL)isLeaf;

// usually [node pathsTo:@"0"] and [node pathsTo:@"1"],
// but [node pathsTo:@"x"] is possible too

- (NSString*)cnfDescription;
- (NSString*)dnfDescription;

- (NSUInteger)width;
- (NSUInteger)height;

- (void)fillStructure:(NSMutableDictionary*)dictionary;

@end
