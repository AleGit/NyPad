//
//  NyayaNode.h
//  Nyaya
//
//  Created by Alexander Maringele on 17.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TruthTable.h"
#import "BddNode.h"
#import "DisplayNode.h"

@interface NyayaNode : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *symbol;   // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;     // subformulas
// @property (nonatomic, weak) NyayaNode *parent;   // deprecated because nodes should be unmutable

// return the number of nodes (#atoms + #connectives)
// "a&b" count == 3 (2 atoms + 1 conjunction)
- (NSUInteger)length;

- (NSUInteger)width;        // width . dx = frame width of syntax tree
- (NSUInteger)height;       // height . dy = frame height of syntax treee

// comparison by length
- (NSComparisonResult)compare:(NyayaNode*)other;

- (BOOL)isSemanticallyEqualToNode:(NyayaNode*)other;
- (BOOL)isSyntacticallyEqualToNode:(NyayaNode*)other;

@end


