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

@property (nonatomic, readonly) NSString *symbol;       // atoms (a,b,c,...) or connectives (¬,∨,∧,→,↔)
@property (nonatomic, readonly) NSArray *nodes;
@property (nonatomic, weak) NyayaNode *parent;


@property (nonatomic, readonly, getter=isWellFormed) BOOL wellFormed;

+ (id)nodeWithFormula:(NSString*)input;

// - (NyayaNode*)reducedFormula;

- (NSUInteger)count;
- (NSComparisonResult)compare:(NyayaNode*)other;

- (TruthTable*)truthTable:(BOOL)compact;
- (BddNode*)OBDD: (BOOL)reduced;

- (NyayaNode*)IMF;
- (NyayaNode*)NNF;
- (NyayaNode*)CNF;
- (NyayaNode*)DNF;

@end


