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

@interface BddNode : NSObject

// used be reduce algorithm
@property (nonatomic, readonly) NSInteger id;

// the name ot the atom: x, y, 0, 1, a, b, etc.
@property (nonatomic, readonly) NSString *name;

// follow this path if the atom 'name' evaluates to 0
@property (nonatomic, readonly) BddNode *leftBranch;
// follow this path if the atom 'name' evaluates to 1
@property (nonatomic, readonly) BddNode *rightBranch;

// Marks if the reduce algorithm was used
@property (nonatomic, readonly) BOOL reduced;

// Ordered BBDs has an array of levels:
// The first ('lowest') level contains '0' and '1'
// Reduced OBDDs which represent tautologies ('1')
// or contradictions ('0') have one level with one entry.
// The second level contains entries of the first atom. etc.
// Reduced OBDDs holds the same 'name:id' multiple times.
// (every 'name:id' must not be drawn more than once)
// ===============================================
// !a&!b    reduced                unreduced
// -----------------------------------------------
//            [a:3]                  [a:6]
//        [0:0  ,  b:2]          [b:4  ,  b:5]
//      [1:1,0:0,0:0,0:0]      [1:0,0:1,0:2,0:3]
// ===============================================
// OBDDs contain at most #(atoms)+1 levels.
// (unordered BDDs will not contain levels
// but drawing is not supported yet.)
@property (nonatomic, readonly) NSArray *levels;        

+(BddNode*)bddWithTruthTable:(TruthTable*)truthTable reduce:(BOOL)reduce;
+ (id)top;
+ (id)bottom;
-(BOOL)isLeaf;

// usually [node pathsTo:@"0"] and [node pathsTo:@"1"],
// but [node pathsTo:@"x"] is possible too

- (NyayaNode*)IMF;
- (NyayaNode*)CNF;
- (NyayaNode*)DNF;
- (NyayaNode*)NNF;

@end
