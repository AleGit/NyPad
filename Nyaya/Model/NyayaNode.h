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

@interface NyayaNode : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *symbol;   // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;     // subformulas
@property (nonatomic, weak) NyayaNode *parent;

// return the number of nodes (#atoms + #connectives)
// "a&b" count == 3 (2 atoms + 1 conjunction)
- (NSUInteger)length;

// comparison by length
- (NSComparisonResult)compare:(NyayaNode*)other;



@end


