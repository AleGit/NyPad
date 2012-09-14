//
//  NyayaTruthTable.h
//  Nyaya
//
//  Created by Alexander Maringele on 24.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NyayaNode;

@interface TruthTable : NSObject

@property (nonatomic, readonly) NyayaNode *formula;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray *variables;
@property (nonatomic, readonly) NSArray *headers;
@property (nonatomic, readonly) BOOL compact;

@property (nonatomic, readonly) NSUInteger rowsCount;

- (id)initWithNode:(NyayaNode*)node;
- (id)initWithNode:(NyayaNode *)node compact:(BOOL)compact;
- (void)evaluateTable;

// - (NSString*)minimalDescription;
- (void)setOrder: (NSArray*)variableNames;

- (BOOL)isTautology;
- (BOOL)isContradiction;
- (BOOL)isSatisfiable;
- (NSUInteger)truthCount;
- (NSUInteger)falseCount;

- (BOOL)evalAtRow:(NSUInteger)rowIdx;



@end

@interface ExpandedTruthTable : TruthTable
@end

