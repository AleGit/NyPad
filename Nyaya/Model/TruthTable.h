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

@property (nonatomic, readonly) NSUInteger rowsCount;

- (id)initWithFormula:(NyayaNode*)formula;
- (id)initWithFormula:(NyayaNode *)formula expanded:(BOOL)expanded;
- (void)evaluateTable;

- (NSString*)minimalDescription; 
- (void)setOrder: (NSArray*)variableNames;

- (BOOL)isTautology;
- (BOOL)isContradiction;
- (BOOL)isSatisfiable;

- (NSSet*)cnfSet;
- (NSSet*)dnfSet;
- (NSString *)cnfDescription;
- (NSString *)dnfDescription;

- (BOOL)evalAtRow:(NSUInteger)rowIdx;



@end
